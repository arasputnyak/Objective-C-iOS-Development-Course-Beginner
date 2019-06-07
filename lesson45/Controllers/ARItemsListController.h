//
//  ARItemsListController.h
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 29.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ARControllerTypeFriends,
    ARControllerTypeFollowers,
    ARControllerTypeSubscriptions
} ARControllerType;

@interface ARItemsListController : UIViewController

@property (assign, nonatomic) ARControllerType controllerType;
@property (assign, nonatomic) NSString* userId;

@end

NS_ASSUME_NONNULL_END
