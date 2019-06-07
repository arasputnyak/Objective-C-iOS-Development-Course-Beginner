//
//  ARCommentsTVController.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/ARPost.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARCommentsTVController : UITableViewController

@property (strong, nonatomic) ARPost* currentPost;
@property (assign, nonatomic) NSInteger wallOwnerId;

@end

NS_ASSUME_NONNULL_END
