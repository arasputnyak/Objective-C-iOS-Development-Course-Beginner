//
//  ARVideo.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARVideo : ARServerObject

@property (assign, nonatomic) NSInteger views;
@property (strong, nonatomic) NSURL* videoURL;

@end

NS_ASSUME_NONNULL_END
