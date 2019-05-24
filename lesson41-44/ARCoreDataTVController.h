//
//  ARCoreDataTVController.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 18.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ARObject+CoreDataClass.h"
#import "ARDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARCoreDataTVController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController<ARObject *> *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell withObject:(ARObject *)object;

@end

NS_ASSUME_NONNULL_END
