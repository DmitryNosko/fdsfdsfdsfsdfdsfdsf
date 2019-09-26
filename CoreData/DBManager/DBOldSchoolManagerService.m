//
//  DBManager.m
//  CoreData
//
//  Created by Dzmitry Noska on 9/24/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "DBOldSchoolManagerService.h"

@implementation DBOldSchoolManagerService
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mocDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}
static DBOldSchoolManagerService* shared;
+(instancetype) sharedDBOldSchoolManagerService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [DBOldSchoolManagerService new];
    });
    return shared;
}

#pragma mark - Notification

- (void) mocDidSaveNotification:(NSNotification *) notification {
    NSManagedObjectContext* context = [notification object];
    
    if (_managedObjectContext == context) {
        return;
    }
    
    if (_managedObjectContext.persistentStoreCoordinator != context.persistentStoreCoordinator) {
        return;
    }
    
    __weak DBOldSchoolManagerService* weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];
    });
}

#pragma mark - PRINT DELETE ALL

- (void) printAllObjects {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"DNObject" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (id obj in [resultArray copy]) {
        if ([obj isKindOfClass:[Student class]]) {
            NSLog(@"student = %@ %@ university = %@", [obj valueForKey:@"firstName"], [obj valueForKey:@"lastName"], [[obj valueForKey:@"university"] valueForKey:@"name"]);
        } else if ([obj isKindOfClass:[University class]]) {
            NSLog(@"university = %@", [obj valueForKey:@"name"]);
        }
    }
}

- (void) deleteAllObjects {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"DNObject" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (id st in resultArray) {
        NSManagedObjectID* stID = [st objectID];
        id obj = [self.managedObjectContext existingObjectWithID:stID error:nil];
        [self.managedObjectContext deleteObject:obj];
    }
    [self.managedObjectContext save:nil];
}

#pragma mark - CREATE UNIVERSITY STUDENT

- (University *) addUniversityWithName:(NSString *) name {
    University* univercity = [NSEntityDescription insertNewObjectForEntityForName:@"University" inManagedObjectContext:self.managedObjectContext];
    [univercity setValue:name forKey:@"name"];
    return univercity;
}

- (University *) addUniversityWithName:(NSString *) name andContext:(NSManagedObjectContext *) context {
    University* univercity = [NSEntityDescription insertNewObjectForEntityForName:@"University" inManagedObjectContext:context];
    [univercity setValue:name forKey:@"name"];
    return univercity;
}

- (Student *) addStudentWithFirstName:(NSString *) firstName lastName:(NSString *) lastName score:(double) score  {
    Student* student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    [student setValue:firstName forKey:@"firstName"];
    [student setValue:lastName forKey:@"lastName"];
    return student;
}

- (Student *) addStudentWithFirstName:(NSString *) firstName lastName:(NSString *) lastName score:(double) score andContext:(NSManagedObjectContext *) context {
    Student* student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:context];
    [student setValue:firstName forKey:@"firstName"];
    [student setValue:lastName forKey:@"lastName"];
    return student;
}

#pragma mark - DELETE ALL STUDENT, 1 STUDENT, ALL UNIVERSITY, 1 UNIVERSITY

- (void) deleteAllStudents {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSArray<Student *>* resultArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (Student* st in resultArray) {
        NSManagedObjectID* stID = [st objectID];
        id obj = [self.managedObjectContext existingObjectWithID:stID error:nil];
        [self.managedObjectContext deleteObject:obj];
    }
    [self.managedObjectContext save:nil];
}

- (void) deleteStudent:(Student *) student {
    NSManagedObjectID* studentToDeleteID = [student objectID];
    id obj = [self.managedObjectContext existingObjectWithID:studentToDeleteID error:nil];
    [self.managedObjectContext deleteObject:obj];
    [self.managedObjectContext save:nil];
}

- (void) deleteAllUniversities {
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    [request setResultType:NSManagedObjectResultType];
    NSEntityDescription* description = [NSEntityDescription entityForName:@"University" inManagedObjectContext:self.managedObjectContext];
    [request setEntity:description];
    
    NSArray<University *>* resultArray = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (University* st in resultArray) {
        NSManagedObjectID* stID = [st objectID];
        id obj = [self.managedObjectContext existingObjectWithID:stID error:nil];
        [self.managedObjectContext deleteObject:obj];
    }
    [self.managedObjectContext save:nil];
}

- (void) deleteUniversity:(University *) university {
    NSManagedObjectID* universityToDeleteID = [university objectID];
    id obj = [self.managedObjectContext existingObjectWithID:universityToDeleteID error:nil];
    [self.managedObjectContext deleteObject:obj];
    [self.managedObjectContext save:nil];
}

#pragma mark - Setters Getters

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator* coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    
    return _managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL* storeURL = [[self applicationDocumentDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError* error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
//                [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
//                [_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *) applicationDocumentDirectory {
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return [paths lastObject];
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
