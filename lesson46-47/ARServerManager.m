//
//  ARServerManager.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerManager.h"
#import "Libs/AFNetworking/AFNetworking.h"
#import "Controllers/ARAuthorizationController.h"

@interface ARServerManager () <UIPopoverPresentationControllerDelegate>
@property (strong, nonatomic) AFHTTPSessionManager* sessionManager;
@property (strong, nonatomic) ARAccessToken* accessToken;
@end

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

- (instancetype)init {
    self = [super init];
    
    if (self) {
        NSURL* baseURL = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    }
    
    return self;
}

#pragma mark - GET requests -

- (void)getUserInfoWithAccessToken:(ARAccessToken*)accessToken
                         onSuccess:(void(^)(ARUser* user))success
                         onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : @(accessToken.userId),
                              @"fields" : @"photo_50",
                        @"access_token" : accessToken.token,
                                   @"v" : version
                             };
    
    [self.sessionManager GET:@"users.get"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSDictionary* userDict = [[responseObject objectForKey:@"response"] firstObject];
                         ARUser* user = [[ARUser alloc] initWithServerResponse:userDict];
                         
                         if (success) {
                             success(user);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getGroupInfoById:(NSInteger)groupId
               onSuccess:(void(^)(ARGroup* group))success
               onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"group_id" : @(groupId * -1),
                               @"fields" : @"counters",
                         @"access_token" : self.accessToken.token,
                                    @"v" : version
                             };
    
    [self.sessionManager GET:@"groups.getById"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSDictionary* groupDict = [[responseObject objectForKey:@"response"] firstObject];
                         ARGroup* group = [[ARGroup alloc] initWithServerResponse:groupDict];
                         
                         if (success) {
                             success(group);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         NSLog(@"Error!!!!!!!!: %@", error);
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getGroupWallById:(NSInteger)groupId
               withCount:(NSInteger)count
               andOffset:(NSInteger)offset
               onSuccess:(void(^)(NSInteger maxPosts, NSArray* posts))success
               onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"owner_id" : @(groupId),
                               @"offset" : @(offset),
                                @"count" : @(count),
                             @"extended" : @1,
                         @"access_token" : self.accessToken.token,
                                    @"v" : version
                                   };
    
    [self.sessionManager GET:@"wall.get"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         
                         NSInteger maxPosts = [[[responseObject objectForKey:@"response"] objectForKey:@"count"] integerValue];
                         
                         NSArray* items = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSArray* profiles = [[responseObject objectForKey:@"response"] objectForKey:@"profiles"];
                         NSArray* groups = [[responseObject objectForKey:@"response"] objectForKey:@"groups"];
                         NSMutableArray* posts = [NSMutableArray array];
                         
                         for (NSDictionary* item in items) {
                             if ([item objectForKey:@"copy_history"] == nil) {
                                 ARPost* post = [[ARPost alloc] initWithServerResponse:item];
                                 
                                 NSInteger fromId = [[item objectForKey:@"from_id"] integerValue];
                                 if (fromId < 0) {
                                     for (NSDictionary* group in groups) {
                                         if ([[group objectForKey:@"id"] integerValue] == -fromId) {
                                             ARGroup* fromGroup = [[ARGroup alloc] initWithServerResponse:group];
                                             post.fromObject = fromGroup;
                                         }
                                     }
                                 } else {
                                     for (NSDictionary* user in profiles) {
                                         if ([[user objectForKey:@"id"] integerValue] == fromId) {
                                             ARUser* fromUser = [[ARUser alloc] initWithServerResponse:user];
                                             post.fromObject = fromUser;
                                         }
                                     }
                                     
                                 }
                                 
                                 [posts addObject:post];
                             }
                         }
                         
                         if (success) {
                             success(maxPosts, posts);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getCommentsForPost:(NSInteger)postId
                  onWallOf:(NSInteger)wallOwnerId
                 onSuccess:(void(^)(NSArray* comments))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"owner_id" : @(wallOwnerId),
                              @"post_id" : @(postId),
                               @"offset" : @(0),
                                @"count" : @(10),
                                 @"sort" : @"asc",
                       @"preview_length" : @(0),
                             @"extended" : @1,
                         @"access_token" : self.accessToken.token,
                                    @"v" : version
                             };
    
    [self.sessionManager GET:@"wall.getComments"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         
                         NSArray* items = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSArray* profiles = [[responseObject objectForKey:@"response"] objectForKey:@"profiles"];
                         NSArray* groups = [[responseObject objectForKey:@"response"] objectForKey:@"groups"];
                         NSMutableArray* comments = [NSMutableArray array];
                         
                         for (NSDictionary* item in items) {
                             ARComment* comment = [[ARComment alloc] initWithServerResponse:item];
                             
                             NSInteger fromId = [[item objectForKey:@"from_id"] integerValue];
                             if (fromId < 0) {
                                 for (NSDictionary* group in groups) {
                                     if ([[group objectForKey:@"id"] integerValue] == -fromId) {
                                         ARGroup* fromGroup = [[ARGroup alloc] initWithServerResponse:group];
                                         comment.fromObject = fromGroup;
                                     }
                                 }
                             } else {
                                 for (NSDictionary* user in profiles) {
                                     if ([[user objectForKey:@"id"] integerValue] == fromId) {
                                         ARUser* fromUser = [[ARUser alloc] initWithServerResponse:user];
                                         comment.fromObject = fromUser;
                                     }
                                 }
                             }
                             
                             [comments addObject:comment];
                         }
                         
                         if (success) {
                             success(comments);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
    
}

- (void)getUsersFriendsById:(NSInteger)userId
                 withOffset:(NSInteger)offset
                      count:(NSInteger)count
                  onSuccess:(void(^)(NSInteger maxFriends, NSArray* friends))success
                  onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : @(userId),
                               @"order" : @"name",
                               @"count" : @(count),
                              @"offset" : @(offset),
                              @"fields" : @"photo_50, photo_100",
                         @"access_token": self.accessToken.token,
                                   @"v" : version
                             };
    
    [self.sessionManager GET:@"friends.get"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSInteger maxFriends = [[[responseObject objectForKey:@"response"] objectForKey:@"count"] integerValue];
                         
                         NSArray* friendsDict = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSMutableArray* friends = [NSMutableArray array];
                         for (NSDictionary* friendDict in friendsDict) {
                             ARUser* friend = [[ARUser alloc] initWithServerResponse:friendDict];
                             [friends addObject:friend];
                         }
                         
                         if (success) {
                             success(maxFriends, friends);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)getVideosById:(NSInteger)groupId
           withOffset:(NSInteger)offset
                count:(NSInteger)count
            onSuccess:(void(^)(NSInteger maxVideos, NSArray* videos))success
            onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"owner_id" : @(groupId),
                                @"count" : @(count),
                               @"offset" : @(offset),
                          @"access_token": self.accessToken.token,
                                    @"v" : version
                             };
    
    [self.sessionManager GET:@"video.get"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         NSInteger maxVideos = [[[responseObject objectForKey:@"response"] objectForKey:@"count"] integerValue];

                         NSArray* videosDict = [[responseObject objectForKey:@"response"] objectForKey:@"items"];
                         NSMutableArray* videos = [NSMutableArray array];
                         for (NSDictionary* videoDict in videosDict) {
                             ARVideo* video = [[ARVideo alloc] initWithServerResponse:videoDict];
                             [videos addObject:video];
                         }

                         if (success) {
                             success(maxVideos, videos);
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

- (void)isPost:(NSInteger)postId
      onWallOf:(NSInteger)wallOwnerId
   likedByUser:(NSInteger)userId
     onSuccess:(void(^)(BOOL liked))success
     onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"user_id" : @(userId),
                                @"type" : @"post",
                            @"owner_id" : @(wallOwnerId),
                             @"item_id" : @(postId),
                         @"access_token": self.accessToken.token,
                                   @"v" : version
                             };
    
    [self.sessionManager GET:@"likes.isLiked"
                  parameters:params
                     headers:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         if ([responseObject objectForKey:@"response"]) {
                             
                             BOOL liked = [[[responseObject objectForKey:@"response"] objectForKey:@"liked"] boolValue];
                             
                             if (success) {
                                 success(liked);
                             }
                         }
                         
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         
                         if (failure) {
                             failure(task.error, error.code);
                         }
                     }];
}

#pragma mark - POST requests -

- (void)sendMessage:(NSString*)message
         toUserById:(NSInteger)userId
          onSuccess:(void(^)(BOOL sended))success
          onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSInteger sign = (CGFloat)(arc4random() % 1001) / 1000 > 0.5 ? 1 : -1;
    NSLog(@"sign = %ld", sign);
    NSInteger randomId = arc4random();
    
    NSDictionary* params = @{@"user_id" : @(userId),
                           @"random_id" : @(randomId),
                             @"message" : message,
                         @"access_token": self.accessToken.token,
                                   @"v" : version
                             };
    
    [self.sessionManager POST:@"messages.send"
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          BOOL sended = [responseObject objectForKey:@"response"] != nil;
                          
                          if (success) {
                              success(sended);
                          }
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if (failure) {
                              failure(task.error, error.code);
                          }
                      }];
}

- (void)addLikeOnPost:(NSInteger)postId
            onSuccess:(void(^)(BOOL likeAdded))success
            onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"type" : @"post",
                         @"owner_id" : @"-58860049",
                          @"item_id" : @(postId),
                      @"access_token": self.accessToken.token,
                                @"v" : version
                             };
    
    [self.sessionManager POST:@"likes.add"
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          BOOL likeAdded = [[responseObject objectForKey:@"response"] objectForKey:@"likes"] != nil;

                          if (success) {
                              success(likeAdded);
                          }
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if (failure) {
                              failure(task.error, error.code);
                          }
                      }];
}

- (void)deleteLikeFromPost:(NSInteger)postId
                 onSuccess:(void(^)(BOOL likeDeleted))success
                 onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"type" : @"post",
                         @"owner_id" : @"-58860049",
                          @"item_id" : @(postId),
                      @"access_token": self.accessToken.token,
                                @"v" : version
                             };
    
    [self.sessionManager POST:@"likes.delete"
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          NSLog(@"JSON: %@", responseObject);
                          
                          BOOL likeDeleted = [[responseObject objectForKey:@"response"] objectForKey:@"likes"] != nil;
                          
                          if (success) {
                              success(likeDeleted);
                          }
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                          
                          if (failure) {
                              failure(task.error, error.code);
                          }
                      }];
}

- (void)addComment:(NSString*)commentText
           forPost:(NSInteger)postId
          onWallOf:(NSInteger)wallOwnerId
         onSuccess:(void(^)(BOOL commentAdded, ARComment* newComment))success
         onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"message" : commentText,
                            @"owner_id" : @(wallOwnerId),
                             @"post_id" : @(postId),
                         @"access_token": self.accessToken.token,
                                   @"v" : version
                             };
    
    [self.sessionManager POST:@"wall.createComment"
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          BOOL commentAdded = [[responseObject objectForKey:@"response"] objectForKey:@"comment_id"] != nil;
                          
                          ARComment* newComment = [[ARComment alloc] init];
                          
                          if (commentAdded) {
                              
                              newComment.objectId = [[[responseObject objectForKey:@"response"] objectForKey:@"comment_id"] integerValue];
                              newComment.fromObject = self.currentUser;
                              newComment.date = [NSDate dateWithTimeIntervalSinceNow:2];
                              newComment.commentText = commentText;
                              
                          }
                          
                          if (success) {
                              success(commentAdded, newComment);
                          }
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          
                          if (failure) {
                              failure(task.error, error.code);
                          }
                      }];
}

- (void)addPost:(NSString*)postText
       onWallOf:(NSInteger)wallOwnerId
      onSuccess:(void(^)(BOOL postAdded, ARPost* newPost))success
      onFailure:(void(^)(NSError* error, NSInteger statusCode))failure {
    
    NSDictionary* params = @{@"message" : postText,
                            @"owner_id" : @(wallOwnerId),
                         @"access_token": self.accessToken.token,
                                   @"v" : version
                             };
    
    [self.sessionManager POST:@"wall.post"
                   parameters:params
                      headers:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          BOOL postAdded = [[responseObject objectForKey:@"response"] objectForKey:@"post_id"] != nil;
                          
                          ARPost* newPost = [[ARPost alloc] init];
                          if (postAdded) {
                              
                              newPost.objectId = [[[responseObject objectForKey:@"response"] objectForKey:@"post_id"] integerValue];
                              newPost.fromObject = self.currentUser;
                              newPost.date = [NSDate dateWithTimeIntervalSinceNow:2];
                              newPost.liked = NO;
                              newPost.likesCount = 0;
                              newPost.commentsCount = 0;
                              newPost.postText = postText;
                              
                          }

                          if (success) {
                              success(postAdded, newPost);
                          }
                          
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          NSLog(@"Error: %@", error);
                          
                          if (failure) {
                              failure(task.error, error.code);
                          }
                      }];
}

- (void)authorizeUser:(void(^)(void))completion {
    
    ARAuthorizationController* authController = [[ARAuthorizationController alloc] initWithCompletionBlock:^(ARAccessToken * _Nonnull accessToken) {
        self.accessToken = accessToken;
        
        [self getUserInfoWithAccessToken:self.accessToken
                               onSuccess:^(ARUser * _Nonnull user) {
                                   self.currentUser = user;
                                   
                                   if (completion) {
                                       completion();
                                   }
                               }
                               onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                   NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                               }];
        
    }];
    
    UINavigationController* authNavigController = [[UINavigationController alloc] initWithRootViewController:authController];
    authNavigController.modalPresentationStyle = UIModalPresentationPopover;
    
    UIViewController* mainVC = [[UIApplication sharedApplication].windows firstObject].rootViewController;
    [mainVC presentViewController:authNavigController
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController* popController = [authNavigController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.delegate = self;
    
}


@end
