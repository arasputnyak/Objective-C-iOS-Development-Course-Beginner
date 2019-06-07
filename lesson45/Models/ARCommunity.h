//
//  ARCommunity.h
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 28.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARCommunity : NSObject

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSURL* imageURL;

- (id)initWithServerResponse:(NSDictionary*)response;

@end

NS_ASSUME_NONNULL_END
