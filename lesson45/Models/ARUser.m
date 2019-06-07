//
//  ARUser.m
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 25.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUser.h"

@implementation ARUser

- (id)initWithServerResponse:(NSDictionary*)response {
    self = [super init];
    
    if (self) {
        self.userId = [response objectForKey:@"id"];
        self.firstName = [response objectForKey:@"first_name"];
        self.lastName = [response objectForKey:@"last_name"];
        self.country = [[response objectForKey:@"country"] objectForKey:@"title"];
        self.city = [[response objectForKey:@"city"] objectForKey:@"title"];
        self.status = [response objectForKey:@"status"];
        self.online = [[response objectForKey:@"online"] boolValue];
        
        NSString* stringURL = [response objectForKey:@"photo_50"];
        self.imageURL = [NSURL URLWithString:stringURL];
        
        NSString* largeStringURL = [response objectForKey:@"photo_200"];
        self.largeImageURL = [NSURL URLWithString:largeStringURL];
    }
    
    return self;
}

@end
