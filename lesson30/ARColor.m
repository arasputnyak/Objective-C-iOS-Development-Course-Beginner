//
//  ARColor.m
//  Lesson30Task
//
//  Created by Анастасия Распутняк on 18.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARColor.h"
// #import <UIKit/UIKit.h>

@implementation ARColor

- (id)initColor {
    self = [super init];
    
    if (self) {
        NSInteger red = arc4random() % 256;
        NSInteger green = arc4random() % 256;
        NSInteger blue = arc4random() % 256;
        
        self.colorName = [NSString stringWithFormat:@"red = %ld, green = %ld, blue = %ld", (long)red, (long)green, (long)blue];
        self.color = [UIColor colorWithRed:red / 255.f
                                     green:green / 255.f
                                      blue:blue / 255.f
                                     alpha:1.f];
    }
    
    return self;
}

@end
