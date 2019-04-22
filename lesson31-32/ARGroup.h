//
//  ARGroup.h
//  Lesson31Task
//
//  Created by Анастасия Распутняк on 21.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARGroup : NSObject

@property (strong, nonatomic) NSString* groupName;
@property (strong, nonatomic) NSArray* groupMembers;

@end

NS_ASSUME_NONNULL_END
