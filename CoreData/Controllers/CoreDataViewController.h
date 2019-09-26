//
//  CoreDataViewController.h
//  CoreData
//
//  Created by Dzmitry Noska on 9/24/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData/CoreData.h"
#import "DataBaseManagerServiceProtocol.h"

@interface CoreDataViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController* fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;
@property (strong, nonatomic) UISegmentedControl* contextSwither;
@property (strong, nonatomic) NSNumber* dataSourceStrategyID;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *) indexPath;
@property (strong, nonatomic) id<DataBaseManagerServiceProtocol> dbSchoolManagerService;
@end
