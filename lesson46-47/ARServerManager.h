//
//  ARServerManager.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Models/ARUser.h"
#import "Models/ARGroup.h"
#import "Models/ARPost.h"
#import "Models/ARComment.h"
#import "Models/ARVideo.h"
#import "ARAccessToken.h"

NS_ASSUME_NONNULL_BEGIN

@interface ARServerManager : NSObject

@property (strong, nonatomic) ARUser* currentUser;

+ (ARServerManager*)sharedManager;

- (void)authorizeUser:(void(^)(void))completion;

#pragma mark - GET requests -

- (void)getUserInfoWithAccessToken:(ARAccessToken*)accessToken
              onSuccess:(void(^)(ARUser* user))success
              onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getGroupInfoById:(NSInteger)groupId
               onSuccess:(void(^)(ARGroup* group))success
               onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getGroupWallById:(NSInteger)groupId
               withCount:(NSInteger)count
               andOffset:(NSInteger)offset
               onSuccess:(void(^)(NSInteger maxPosts, NSArray* posts))success
               onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)isPost:(NSInteger)postId
      onWallOf:(NSInteger)wallOwnerId
   likedByUser:(NSInteger)userId
     onSuccess:(void(^)(BOOL liked))success
     onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getCommentsForPost:(NSInteger)postId
                  onWallOf:(NSInteger)wallOwnerId
                 onSuccess:(void(^)(NSArray* comments))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getUsersFriendsById:(NSInteger)userId
                 withOffset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(void(^)(NSInteger maxFriends, NSArray* friends))success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)getVideosById:(NSInteger)groupId
           withOffset:(NSInteger)offset
                count:(NSInteger)count
            onSuccess:(void(^)(NSInteger maxVideos, NSArray* videos))success
            onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

#pragma mark - POST requests -

- (void)sendMessage:(NSString*)message
         toUserById:(NSInteger)userId
          onSuccess:(void(^)(BOOL sended))success
          onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)addLikeOnPost:(NSInteger)postId
            onSuccess:(void(^)(BOOL likeAdded))success
            onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)deleteLikeFromPost:(NSInteger)postId
                 onSuccess:(void(^)(BOOL likeDeleted))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)addComment:(NSString*)commentText
           forPost:(NSInteger)postId
          onWallOf:(NSInteger)wallOwnerId
         onSuccess:(void(^)(BOOL commentAdded, ARComment* newComment))success
         onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

- (void)addPost:(NSString*)postText
       onWallOf:(NSInteger)wallOwnerId
      onSuccess:(void(^)(BOOL postAdded, ARPost* newPost))success
      onFailure:(void(^)(NSError* error, NSInteger statusCode))failure;

@end

NS_ASSUME_NONNULL_END
