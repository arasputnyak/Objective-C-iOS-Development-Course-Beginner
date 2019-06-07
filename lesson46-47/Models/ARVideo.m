//
//  ARVideo.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARVideo.h"

@implementation ARVideo

- (id)initWithServerResponse:(NSDictionary *)response {
    self = [super initWithServerResponse:response];
    
    if (self) {
        self.name = [response objectForKey:@"title"];
        self.views = [[response objectForKey:@"views"] integerValue];
        
        NSString* largeStringURL = [response objectForKey:@"photo_130"];
        self.largeImageURL = [NSURL URLWithString:largeStringURL];
        
        NSString* stringURL = [response objectForKey:@"player"];
        self.videoURL = [NSURL URLWithString:stringURL];
    }
    
    return self;
}

@end
