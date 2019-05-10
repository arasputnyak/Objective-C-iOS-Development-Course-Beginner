//
//  UIView+MKAnnotationView.m
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 08.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "UIView+MKAnnotationView.h"

@implementation UIView (MKAnnotationView)

- (MKAnnotationView*)superAnnotationView {
    if (!self.superview) {
        return nil;
    }
    
    if ([self isKindOfClass:[MKAnnotationView class]]) {
        return (MKAnnotationView*)self;
    }
    
    return [self.superview superAnnotationView];
}

@end
