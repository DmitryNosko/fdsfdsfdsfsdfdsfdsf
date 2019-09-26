//
//  DataBaseManagerFactory.m
//  CoreData
//
//  Created by Dzmitry Noska on 9/26/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "DataBaseManagerFactory.h"
#import "DBOldSchoolManagerService.h"
#import "DBNewSchoolManagerService.h"

@interface DataBaseManagerFactory ()
@property (strong, nonatomic) NSDictionary<NSNumber*, id<DataBaseManagerServiceProtocol>>* serviceByID;
@end

@implementation DataBaseManagerFactory

static DataBaseManagerFactory* shared;

+(instancetype) sharedDataBaseManagerFactory {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [DataBaseManagerFactory new];
        shared.serviceByID = @{@(0) : [DBOldSchoolManagerService sharedDBOldSchoolManagerService],
                               @(1) : [DBNewSchoolManagerService sharedDBNewSchoolManagerService]
                               };
    });
    return shared;
}

- (id<DataBaseManagerServiceProtocol>) dataBaseManagerProtocol:(NSNumber*) storageValue {
    return [self.serviceByID objectForKey:@(storageValue.integerValue)];
}

@end
