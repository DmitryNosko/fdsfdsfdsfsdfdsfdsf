//
//  DBNewSchoolManager.h
//  CoreData
//
//  Created by Dzmitry Noska on 9/26/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Student+CoreDataClass.h"
#import "University+CoreDataClass.h"
#import "DataBaseManagerServiceProtocol.h"


@interface DBNewSchoolManagerService : NSObject <DataBaseManagerServiceProtocol>
+ (instancetype) sharedDBNewSchoolManagerService;
@end

