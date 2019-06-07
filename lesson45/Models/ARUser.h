//
//  ARUser.h
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 25.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARUser : NSObject

@property (strong, nonatomic) NSString* userId;
@property (strong, nonatomic) NSURL* imageURL;
@property (strong, nonatomic) NSURL* largeImageURL;
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (strong, nonatomic) NSString* country;
@property (strong, nonatomic) NSString* city;
@property (strong, nonatomic) NSString* status;
@property (assign, nonatomic) BOOL online;

- (id)initWithServerResponse:(NSDictionary*)response;

@end

NS_ASSUME_NONNULL_END
