//
//  ARServerManager.h
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 25.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARUser.h"
#import "ARCommunity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARServerManager : NSObject

+ (ARServerManager*)sharedManager;

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* friends))success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getUserInfoById:(NSString*)userId
              onSuccess:(void(^)(ARUser* user))success
              onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getUserFollowersById:(NSString*)userId
                      withOffset:(NSInteger)offset
                        andCount:(NSInteger)count
                       onSuccess:(void(^)(NSArray* followers))success
                       onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getUserSubscriptionsById:(NSString*)userId
                      withOffset:(NSInteger)offset
                        andCount:(NSInteger)count
                       onSuccess:(void(^)(NSArray* subscriptions))success
                       onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

@end

NS_ASSUME_NONNULL_END
