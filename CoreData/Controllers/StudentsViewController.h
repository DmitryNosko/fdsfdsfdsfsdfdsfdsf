//
//  StudentsViewController.h
//  CoreData
//
//  Created by Dzmitry Noska on 9/25/19.
//  Copyright © 2019 USER. All rights reserved.
//

#import "CoreDataViewController.h"

@class University;

@interface StudentsViewController : CoreDataViewController
@property (strong, nonatomic) University* university;
@end

