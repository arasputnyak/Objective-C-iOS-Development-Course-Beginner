//
//  ARUsersListTVController.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 23.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUsersTVController.h"
#import "../Models/ARUser+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ARListControllerTypeSingle,
    ARListControllerTypeMultiple
} ARListControllerType;

@protocol ARUsersListTVControllerDelegate;

@interface ARUsersListTVController : ARUsersTVController

@property (assign, nonatomic) ARListControllerType controllerType;
@property (strong, nonatomic) NSMutableArray* chosenUsers;
@property (strong, nonatomic) id <ARUsersListTVControllerDelegate> delegate;

@end


@protocol ARUsersListTVControllerDelegate <NSObject>

- (void)updateUsers:(ARUsersListTVController*)listController;

@end

NS_ASSUME_NONNULL_END
