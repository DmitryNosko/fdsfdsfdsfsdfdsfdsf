//
//  AppDelegate.m
//  CoreData
//
//  Created by USER on 9/23/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "AppDelegate.h"
#import "DBManager/DBOldSchoolManagerService.h"
#import "UniversityViewController.h"
#import "Student+CoreDataClass.h"
#import "University+CoreDataClass.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:[[UniversityViewController alloc] init]];
    [self.window setRootViewController:nvc];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[DBOldSchoolManagerService sharedDBOldSchoolManagerService] saveContext];
}

@end
