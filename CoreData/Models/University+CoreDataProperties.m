//
//  University+CoreDataProperties.m
//  CoreData
//
//  Created by Dzmitry Noska on 9/24/19.
//  Copyright © 2019 USER. All rights reserved.
//
//

#import "University+CoreDataProperties.h"

@implementation University (CoreDataProperties)

+ (NSFetchRequest<University *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"University"];
}

@dynamic name;
@dynamic students;

@end
