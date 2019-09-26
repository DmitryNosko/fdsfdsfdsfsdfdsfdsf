//
//  dataBaseManagerProtocol.h
//  CoreData
//
//  Created by Dzmitry Noska on 9/26/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "University+CoreDataClass.h"
#import "Student+CoreDataClass.h"

@protocol dataBaseManagerProtocol <NSObject>
- (void)saveContext;
- (void) printAllObjects;
- (void) deleteAllObjects;
- (University *) addUniversityWithName:(NSString *) name;
- (Student *) addStudentWithFirstName:(NSString *) firstName lastName:(NSString *) lastName score:(double) score;
- (void) deleteAllStudents;
- (void) deleteStudent:(Student *) student;
- (void) deleteAllUniversities;
- (void) deleteUniversity:(University *) university;
- (University *) addUniversityWithName:(NSString *) name andContext:(NSManagedObjectContext *) context;
- (Student *) addStudentWithFirstName:(NSString *) firstName lastName:(NSString *) lastName score:(double) score andContext:(NSManagedObjectContext *) context;
@end

