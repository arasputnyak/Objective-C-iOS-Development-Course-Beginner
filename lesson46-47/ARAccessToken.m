//
//  ARAccessToken.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARAccessToken.h"

@implementation ARAccessToken

- (NSString*)description {
    return [NSString stringWithFormat:@"token = %@, userId = %ld", self.token, self.userId];
}

@end
