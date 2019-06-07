//
//  ARServerObject.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARServerObject : NSObject

@property (assign, nonatomic) NSInteger objectId;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* largeImageURL;

- (id)initWithServerResponse:(NSDictionary*)response;

@end

NS_ASSUME_NONNULL_END
