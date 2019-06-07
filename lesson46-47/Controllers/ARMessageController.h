//
//  ARMessageController.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 31.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/ARUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARMessageController : UIViewController

@property (strong, nonatomic) ARUser* user;

@end

NS_ASSUME_NONNULL_END
