//
//  ARDrawView.m
//  Lesson24Task1
//
//  Created by Анастасия Распутняк on 09.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARDrawView.h"

@implementation ARDrawView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray* dictKeys = [self.drawPoints allKeys];
    
    for (NSString* key in dictKeys) {
        CGPoint drawPoint = CGPointFromString(key);
        
        NSArray* pointParametres = [self.drawPoints objectForKey:key];  // [color, size]
        
        UIColor* color = (UIColor*)[pointParametres objectAtIndex:0];
        CGContextSetFillColorWithColor(context, color.CGColor);
        
        CGFloat size = [[pointParametres objectAtIndex:1] floatValue];
        CGRect drawRect = CGRectMake(drawPoint.x - size / 2, drawPoint.y - size / 2, size, size);
        
        CGContextAddEllipseInRect(context, drawRect);
        CGContextFillPath(context);
    }
    
    NSLog(@"draw!");
}

@end
