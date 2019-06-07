//
//  ARComment.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARComment.h"

@implementation ARComment

- (id)initWithServerResponse:(NSDictionary*)response {
    self = [super initWithServerResponse:response];
    
    if (self) {
        
        double dateInterval = [[response objectForKey:@"date"] doubleValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:dateInterval];
        
        self.commentText = [response objectForKey:@"text"];

    }
    
    return self;
}

@end
