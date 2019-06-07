//
//  ARPost.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 31.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARPost.h"

@implementation ARPost

- (id)initWithServerResponse:(NSDictionary*)response {
    self = [super initWithServerResponse:response];
    
    if (self) {

        double dateInterval = [[response objectForKey:@"date"] doubleValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:dateInterval];
        
        self.liked = ![[[response objectForKey:@"likes"] objectForKey:@"can_like"] boolValue];
        
        self.likesCount = [[[response objectForKey:@"likes"] objectForKey:@"count"] integerValue];
        self.commentsCount = [[[response objectForKey:@"comments"] objectForKey:@"count"] integerValue];
        
        self.postText = [response objectForKey:@"text"];
        
        NSArray* attachments = [response objectForKey:@"attachments"];
        NSMutableArray* photos = [NSMutableArray array];
        for (NSDictionary* dict in attachments) {
            if ([[dict objectForKey:@"type"] isEqualToString:@"photo"]) {
                NSString* stringURL = [[[[dict objectForKey:@"photo"] objectForKey:@"sizes"] lastObject] objectForKey:@"url"];
                [photos addObject:[NSURL URLWithString:stringURL]];
            }
        }
        self.postPhotos = photos;
    }
    
    return self;
}

@end
