//
//  ARCommunity.m
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 28.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARCommunity.h"

@implementation ARCommunity

- (id)initWithServerResponse:(NSDictionary*)response {
    self = [super init];
    
    if (self) {
        self.name = [response objectForKey:@"name"];
        
        NSString* stringURL = [response objectForKey:@"photo_50"];
        self.imageURL = [NSURL URLWithString:stringURL];
    }
    
    return self;
}

@end
