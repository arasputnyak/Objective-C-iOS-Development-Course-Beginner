//
//  ARGroup.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARGroup : ARServerObject

@property (strong, nonatomic) NSString* photosCount;
@property (strong, nonatomic) NSString* videosCount;

@end

NS_ASSUME_NONNULL_END
