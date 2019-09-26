//
//  DataBaseManagerFactory.h
//  CoreData
//
//  Created by Dzmitry Noska on 9/26/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataBaseManagerServiceProtocol.h"

@interface DataBaseManagerFactory : NSObject

+(instancetype) sharedDataBaseManagerFactory;
- (id<DataBaseManagerServiceProtocol>) dataBaseManagerProtocol:(NSNumber*) storageValue;

@end

