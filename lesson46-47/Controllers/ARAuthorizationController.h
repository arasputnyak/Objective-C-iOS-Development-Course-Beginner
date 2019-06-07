//
//  ARAuthorizationController.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../ARAccessToken.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ASAuthorizationBlock)(ARAccessToken* accessToken);

@interface ARAuthorizationController : UIViewController

- (id)initWithCompletionBlock:(ASAuthorizationBlock)completion;

@end

NS_ASSUME_NONNULL_END
