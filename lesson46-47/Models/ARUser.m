//
//  ARUser.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUser.h"

@implementation ARUser

- (id)initWithServerResponse:(NSDictionary*)response {
    self = [super initWithServerResponse:response];
    
    if (self) {
        NSString* firstName = [response objectForKey:@"first_name"];
        NSString* lastName = [response objectForKey:@"last_name"];
        self.name = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    }
    
    return self;
}

@end
