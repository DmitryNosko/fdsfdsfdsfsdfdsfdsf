//
//  StudentsViewController.m
//  CoreData
//
//  Created by Dzmitry Noska on 9/25/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "StudentsViewController.h"
#import "Student+CoreDataClass.h"
#import "University+CoreDataClass.h"
#import "DBOldSchoolManagerService.h"
#import "DBNewSchoolManagerService.h"

@interface StudentsViewController ()

@end

static NSString* STUDENT_ENTITY_NAME = @"Student";

@implementation StudentsViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addStudentAction)];
}

- (void) addStudentAction {
    
    UIAlertController* addFeedAlert = [UIAlertController alertControllerWithTitle:@"Add new student"
                                                                          message:@"Enter name, sername and score."
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    [addFeedAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"FirstName";
    }];
    [addFeedAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"LastName";
    }];
    [addFeedAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Score";
    }];
    
    [addFeedAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [addFeedAlert addAction:[UIAlertAction actionWithTitle:@"Save"
                                                      style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                          NSArray<UITextField*>* textField = addFeedAlert.textFields;
                                                          UITextField* firstNameTextField = [textField firstObject];
                                                          UITextField* lastNameTextField = [textField objectAtIndex:1];
                                                          UITextField* scoreTextField = [textField lastObject];
                                                          
                                                          if (![firstNameTextField.text isEqualToString:@""] && ![lastNameTextField.text isEqualToString:@""] && ![scoreTextField.text isEqualToString:@""]) {
                                                              
//                                                              Student* student = [[DBOldSchoolManager sharedDBManager] addStudentWithFirstName:firstNameTextField.text lastName:lastNameTextField.text score:scoreTextField.text.doubleValue];
//                                                              student.university = self.university;
//                                                              NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//                                                              [context insertObject:student];
//
//                                                              NSThread* thread = [[NSThread alloc] initWithBlock:^{
//                                                                  NSError *error = nil;
//                                                                  if (![context save:&error]) {
//                                                                      NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//                                                                      abort();
//                                                                  }
//                                                              }];
//                                                              [thread start];
                                                              
//                                                              NSManagedObjectContext *parentContext = [self.fetchedResultsController managedObjectContext];
//                                                              NSManagedObjectContext *childContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
//                                                              [childContext setParentContext:parentContext];
//                                                              
//                                                              [[DBNewSchoolManagerService sharedDBNewSchoolManagerService] addStudentWithFirstName:firstNameTextField.text lastName:lastNameTextField.text score:scoreTextField.text.doubleValue university:self.university andContext:self.managedObjectContext];
//                                                              
//                                                              [childContext performBlock:^{
//                                                                  
//                                                                  NSError* error = nil;
//                                                                  if (![childContext save:&error]) {
//                                                                      NSLog(@"Error saving context = %@ %@", [error localizedDescription], [error userInfo]);
//                                                                      abort();
//                                                                  }
//                                                                  [parentContext performBlockAndWait:^{
//                                                                      NSError *error = nil;
//                                                                      if (![parentContext save:&error]) {
//                                                                          NSLog(@"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
//                                                                          abort();
//                                                                      }
//                                                                  }];
//                                                              }];
                                                              
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
    NSSortDescriptor* sortByname = [[NSSortDescriptor alloc] initWithKey:@"firstName" ascending:YES];
    [request setSortDescriptors:@[sortByname]];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"university == %@", self.university];
    [request setPredicate:predicate];
    
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:STUDENT_ENTITY_NAME inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSFetchedResultsController* frc = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.managedObjectContext
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
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
    Student* student = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", @(student.score)];
}

@end
