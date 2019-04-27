//
//  ARStudent.h
//  Lesson35Task
//
//  Created by Анастасия Распутняк on 24.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSDate* birthDate;

+ (ARStudent*)randomStudent;

@end

NS_ASSUME_NONNULL_END
