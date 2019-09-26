//
//  CoreDataViewController.m
//  CoreData
//
//  Created by Dzmitry Noska on 9/24/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "CoreDataViewController.h"
//#import "DBOldSchoolManager.h"
#import "DBNewSchoolManagerService.h"
#import "DataBaseManagerFactory.h"


@interface CoreDataViewController ()

@end

static NSString* CELL_IDENTIFIER = @"Cell";
static NSNumber* DEFAULT_CONTEXT_INDEX = 0;

@implementation CoreDataViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViewController];
    
    NSNumber* storageStrategyID = @(self.contextSwither.selectedSegmentIndex);
    self.dbSchoolManagerService = [[DataBaseManagerFactory sharedDataBaseManagerFactory] dataBaseManagerProtocol:storageStrategyID];
}

- (NSManagedObjectContext *) managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [self.dbSchoolManagerService managedObjectContext];
        //_managedObjectContext = [[DBOldSchoolManager sharedDBManager] managedObjectContext];
        //_managedObjectContext = [[DBNewSchoolManagerService sharedDBNewSchoolManagerService] managedObjectContext];
    }
    
    return _managedObjectContext;
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFIER];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_IDENTIFIER];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSThread* thread = [[NSThread alloc] initWithBlock:^{
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                abort();
            }
        }];
        [thread start];
    }
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    return nil;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self performSelectorOnMainThread:@selector(reloadDataHandler) withObject:nil waitUntilDone:YES];
}

- (void) reloadDataHandler {
    [self.tableView reloadData];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath {
}

#pragma mark - ViewCotrollerSetUp

- (void) setUpViewController {
    
    self.contextSwither = [[UISegmentedControl alloc] initWithItems:@[@"old school", @"new school"]];
    [self.contextSwither addTarget:self action:@selector(changeContext:) forControlEvents:UIControlEventValueChanged];
    
    if ([NSUserDefaults.standardUserDefaults objectForKey:@"dataSourceStrategyID"]) {
        [self.contextSwither setSelectedSegmentIndex:[[NSUserDefaults.standardUserDefaults objectForKey:@"dataSourceStrategyID"] integerValue]];
    } else {
        [self.contextSwither setSelectedSegmentIndex:0];
        [NSUserDefaults.standardUserDefaults setObject:DEFAULT_CONTEXT_INDEX forKey:@"dataSourceStrategyID"];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
    
    self.navigationItem.titleView = self.contextSwither;
}

- (void) changeContext:(UISegmentedControl *) sender {
    self.dataSourceStrategyID = @(sender.selectedSegmentIndex);
    self.dbSchoolManagerService = [[DataBaseManagerFactory sharedDataBaseManagerFactory] dataBaseManagerProtocol:self.dataSourceStrategyID];
    self.managedObjectContext = [self.dbSchoolManagerService managedObjectContext];
    
    //notify about changeContext
    [NSUserDefaults.standardUserDefaults setObject:self.dataSourceStrategyID forKey:@"dataSourceStrategyID"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
