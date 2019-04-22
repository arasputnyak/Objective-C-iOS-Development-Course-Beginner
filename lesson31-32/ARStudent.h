//
//  ARStudent.h
//  Lesson31Task
//
//  Created by Анастасия Распутняк on 21.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) CGFloat averageMark;

+ (ARStudent*)randomStudent;

@end

NS_ASSUME_NONNULL_END
