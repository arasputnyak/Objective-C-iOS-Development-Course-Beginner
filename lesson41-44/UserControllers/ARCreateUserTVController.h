//
//  ARCreateUserTVController.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 16.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/ARUser+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ARUserControllerTypeCreate,
    ARUserControllerTypeEdit
} ARUserControllerType;

@interface ARCreateUserTVController : UITableViewController

@property (assign, nonatomic) ARUserControllerType controllerType;
@property (strong, nonatomic) ARUser* editingUser;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

NS_ASSUME_NONNULL_END
