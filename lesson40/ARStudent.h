//
//  ARStudent.h
//  Lesson40Task
//
//  Created by Анастасия Распутняк on 12.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) NSInteger grade;
@property (weak, nonatomic) ARStudent* bff;

- (void)resetProperties;

@end

NS_ASSUME_NONNULL_END
