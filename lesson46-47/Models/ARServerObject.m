//
//  ARServerObject.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARServerObject.h"

@implementation ARServerObject

- (id)initWithServerResponse:(NSDictionary*)response {
    
    self = [super init];
    
    if (self) {
        self.objectId = [[response objectForKey:@"id"] integerValue];
        
        NSString* stringURL = [response objectForKey:@"photo_50"];
        self.imageURL = [NSURL URLWithString:stringURL];
        
        NSString* largeStringURL = [response objectForKey:@"photo_100"];
        self.largeImageURL = [NSURL URLWithString:largeStringURL];
    }
    
    return self;
}

@end
