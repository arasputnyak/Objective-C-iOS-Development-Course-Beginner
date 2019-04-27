//
//  ARSection.h
//  Lesson35Task
//
//  Created by Анастасия Распутняк on 25.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARSection : NSObject

@property (strong, nonatomic) NSString* sectionName;
@property (strong, nonatomic) NSMutableArray* sectionMembers;

@end

NS_ASSUME_NONNULL_END
