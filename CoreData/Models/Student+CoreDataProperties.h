//
//  Student+CoreDataProperties.h
//  CoreData
//
//  Created by Dzmitry Noska on 9/24/19.
//  Copyright © 2019 USER. All rights reserved.
//
//

#import "Student+CoreDataClass.h"
#import "University+CoreDataClass.h"

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *) fetchRequest;

@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nonatomic) double score;
@property (nullable, nonatomic, retain) University *university;

@end
