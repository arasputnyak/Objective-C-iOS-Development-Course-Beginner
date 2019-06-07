//
//  ARServerManager.m
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 25.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerManager.h"
#import "Libs/AFNetworking/AFNetworking.h"

@interface ARServerManager ()
@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@end

static NSString* accessToken = @"25de887c25de887c25de887c2425b447b3225de25de887c7932ee4bb1511f70c07359ed";
static NSString* version = @"5.95";

@implementation ARServerManager

+ (ARServerManager*)sharedManager {
    static ARServerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ARServerManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSURL* baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    return self;
}

- (void)getFriendsWithOffset:(NSInteger)offset
                       count:(NSInteger)count
                   onSuccess:(void(^)(NSArray* friends))success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : @"19566512",
                             @"order" : @"name",
                             @"count" : @(count),
                             @"offset" : @(offset),
                             @"fields" : @"photo_50, online",
                             @"access_token": accessToken,
                             @"v" : version
                             };
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         NSArray* friendsDict = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSMutableArray* friends = [NSMutableArray array];
                         for (NSDictionary* friendDict in friendsDict) {
                             ARUser* friend = [[ARUser alloc] initWithServerResponse:friendDict];
                             [friends addObject:friend];
                         }
                         
                         if (success) {
                             success(friends);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getUserInfoById:(NSString*)userId
              onSuccess:(void(^)(ARUser* user))success
              onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : userId,
                             @"fields" : @"city, country, status, photo_200",
                             @"access_token" : accessToken,
                             @"v" : version
                             };
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSDictionary* userDict = [[responseObject objectForKey:@"response"] objectAtIndex:0];
                         ARUser* user = [[ARUser alloc] initWithServerResponse:userDict];
                         
                         if (success) {
                             success(user);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getUserFollowersById:(NSString*)userId
                  withOffset:(NSInteger)offset
                    andCount:(NSInteger)count
                   onSuccess:(void(^)(NSArray* followers))success
                   onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : userId,
                             @"count" : @(count),
                             @"offset" : @(offset),
                             @"fields" : @"photo_50",
                             @"access_token": accessToken,
                             @"v" : version
                             };
    
    [self.sessionManager GET:@"users.getFollowers"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray* followersDict = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSMutableArray* followers = [NSMutableArray array];
                         for (NSDictionary* followerDict in followersDict) {
                             ARUser* follower = [[ARUser alloc] initWithServerResponse:followerDict];
                             [followers addObject:follower];
                         }
                         
                         if (success) {
                             success(followers);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getUserSubscriptionsById:(NSString*)userId
                      withOffset:(NSInteger)offset
                        andCount:(NSInteger)count
                       onSuccess:(void(^)(NSArray* subscriptions))success
                       onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : userId,
                             @"extended" : @1,
                             @"count" : @(count),
                             @"offset" : @(offset),
                             @"fields" : @"photo_50",
                             @"access_token": accessToken,
                             @"v" : version
                             };
    
    [self.sessionManager GET:@"users.getSubscriptions"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSArray* subscriptionsDict = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSMutableArray* subscriptions = [NSMutableArray array];
                         for (NSDictionary* subscriptionDict in subscriptionsDict) {
                             
                             NSObject* subscription;
                             if ([[subscriptionDict objectForKey:@"type"] isEqualToString:@"profile"]) {
                                 subscription = [[ARUser alloc] initWithServerResponse:subscriptionDict];
                             } else {
                                 subscription = [[ARCommunity alloc] initWithServerResponse:subscriptionDict];
                             }
                             
                             [subscriptions addObject:subscription];
                         }
                         
                         if (success) {
                             success(subscriptions);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error: %@", error);
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}


@end
