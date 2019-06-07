//
//  ARPost.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 31.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARPost : ARServerObject

@property (strong, nonatomic) ARServerObject* fromObject;
@property (strong, nonatomic) NSDate* date;
@property (assign, nonatomic) BOOL liked;

@property (assign, nonatomic) NSInteger likesCount;
@property (assign, nonatomic) NSInteger commentsCount;

@property (strong, nonatomic) NSString* postText;
@property (strong, nonatomic) NSArray* postPhotos;

@end

NS_ASSUME_NONNULL_END
