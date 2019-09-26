//
//  UniversityViewController.m
//  CoreData
//
//  Created by Dzmitry Noska on 9/24/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "UniversityViewController.h"
#import "University+CoreDataClass.h"
#import "DBOldSchoolManagerService.h"
#import "DBNewSchoolManagerService.h"
#import "Student+CoreDataClass.h"
#import "CoreData/CoreData.h"
#import "StudentsViewController.h"

@interface UniversityViewController ()
@end

static NSString* UNIVERSITY_ENTITY_NAME = @"University";

@implementation UniversityViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUniversityAction)];
}

#pragma mark - Fetched results controller

- (void) addUniversityAction {
    
    UIAlertController* addFeedAlert = [UIAlertController alertControllerWithTitle:@"Add new university"
                                                                          message:@"Enter university name."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [addFeedAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Name";
    }];
    
    [addFeedAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [addFeedAlert addAction:[UIAlertAction actionWithTitle:@"Save"
                                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                         NSArray<UITextField*>* textField = addFeedAlert.textFields;
                                                         
                                                         UITextField* nameTextField = [textField firstObject];
                                                         
                                                         if (![nameTextField.text isEqualToString:@""]) {
                                                             
                                                             if (self.dataSourceStrategyID == 0) {
                                                                 University* university = [self.dbSchoolManagerService addUniversityWithName:nameTextField.text];
                                                                 NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
                                                                 [context insertObject:university];
                                                                 
                                                                 NSThread* thread = [[NSThread alloc] initWithBlock:^{
                                                                     NSError *error = nil;
                                                                     if (![context save:&error]) {
                                                                         NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                                                                         abort();
                                                                     }
                                                                 }];
                                                                 [thread start];
                                                             } else {
                                                                 
                                                                 NSManagedObjectContext *parentContext = [self.fetchedResultsController managedObjectContext];
                                                                 NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                                                                 [childContext setParentContext:parentContext];
                                                                 
                                                                 [self.dbSchoolManagerService addUniversityWithName:nameTextField.text andContext:childContext];
                                                                 
                                                                 [childContext performBlock:^{
                                                                     
                                                                     NSError* error = nil;
                                                                     if (![childContext save:&error]) {
                                                                         NSLog(@"Error saving context = %@ %@", [error localizedDescription], [error userInfo]);
                                                                         abort();
                                                                     }
                                                                     [parentContext performBlockAndWait:^{
                                                                         NSError *error = nil;
                                                                         if (![parentContext save:&error]) {
                                                                             NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
                                                                             abort();
                                                                         }
                                                                     }];
                                                                 }];
                                                             }
                                                             
                                                         } else {
                                                             NSLog(@"exeption");
                                                         }
                                                     }
                             ]];
    
    [self presentViewController:addFeedAlert animated:YES completion:nil];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    NSSortDescriptor* sortByname = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [request setSortDescriptors:@[sortByname]];
    
    
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:UNIVERSITY_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext
                                                                             sectionNameKeyPath:nil
                                                                                                        cacheName:@"Master"];
    frc.delegate = self;
    self.fetchedResultsController = frc;
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    return self.fetchedResultsController;
}

#pragma mark UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath {
    University* university = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = university.name;
    cell.detailTextLabel.text = nil;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    University* university = [self.fetchedResultsController objectAtIndexPath:indexPath];
    StudentsViewController* svc = [[StudentsViewController alloc] init];
    svc.university = university;
    [self.navigationController pushViewController:svc animated:YES];
}

@end
