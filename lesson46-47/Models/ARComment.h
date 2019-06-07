//
//  ARComment.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARComment : ARServerObject

@property (strong, nonatomic) ARServerObject* fromObject;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* commentText;

@end

NS_ASSUME_NONNULL_END
