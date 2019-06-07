//
//  ARGroup.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARGroup.h"

@implementation ARGroup

- (id)initWithServerResponse:(NSDictionary*)response {
    self = [super initWithServerResponse:response];
    
    if (self) {
        self.objectId *= -1;
        self.name = [response objectForKey:@"name"];
        
        self.photosCount = [NSString stringWithFormat:@"%@", [[response objectForKey:@"counters"] objectForKey:@"photos"]];
        self.videosCount = [NSString stringWithFormat:@"%@", [[response objectForKey:@"counters"] objectForKey:@"videos"]];
    }
    
    return self;
}

@end
