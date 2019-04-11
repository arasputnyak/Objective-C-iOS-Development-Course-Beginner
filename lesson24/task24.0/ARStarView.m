//
//  ARStarView.m
//  Lesson24Task
//
//  Created by Анастасия Распутняк on 08.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARStarView.h"

@interface ARStarView ()
@property (strong, nonatomic) NSMutableArray* vertices;
@property (strong, nonatomic) NSMutableArray* starRects;
@end

@implementation ARStarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.vertices = [[NSMutableArray alloc] init];
    self.starRects = [[NSMutableArray alloc] init];
    double theta = 2 * M_PI * (2.0 / 5.0); // 144 degrees
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (self.starsCount != 0) {
        // создаем первую звезду
        // double r = self.pentagonSize / 2;
        double r = [self randomFrom:20 To:40];
        
        CGFloat centreX = [self randomFrom:r + 15 To:CGRectGetWidth(rect) - r - 15];
        CGFloat centreY = [self randomFrom:r + 15 To:CGRectGetHeight(rect) - r - 15];
        NSLog(@"%@", NSStringFromCGPoint(CGPointMake(centreX, centreY)));
        
        [self.starRects addObject:[NSValue valueWithCGRect:CGRectMake(centreX - r, centreY - r, 2 * r, 2 * r)]];
        
        for (int i = 1; i < self.starsCount; i++) {
            while (YES) {
                double newR = [self randomFrom:20 To:40];
                
                CGFloat newCentreX = [self randomFrom:newR + 15 To:CGRectGetWidth(rect) - newR - 15];
                CGFloat newCentreY = [self randomFrom:newR + 15 To:CGRectGetHeight(rect) - newR - 15];
                CGRect newRect = CGRectMake(newCentreX - newR, newCentreY - newR, 2 * newR, 2 * newR);
                
                if (![self doesRect:newRect crossSomeOfRects:self.starRects]) {
                    [self.starRects addObject:[NSValue valueWithCGRect:newRect]];
                    break;
                }
            }
        }
    }
    
    for (NSValue* valRect in self.starRects) {
        CGRect starRect = [valRect CGRectValue];
        
        CGFloat r = CGRectGetWidth(starRect) / 2;
        CGPoint centrePoint = CGPointMake(CGRectGetMidX(starRect), CGRectGetMidY(starRect));
        NSLog(@"another = %@", NSStringFromCGPoint(centrePoint));
        
        for (int i = 0; i < 5; i++) {
            float x = r * sin(i * theta) + centrePoint.x;
            float y = r * cos(i * theta) + centrePoint.y;
            
            CGPoint vertex = CGPointMake(x, y);
            
            [self.vertices addObject:[NSValue valueWithCGPoint:vertex]];
        }
        
        CGContextMoveToPoint(context, [[self.vertices objectAtIndex:0] CGPointValue].x, [[self.vertices objectAtIndex:0] CGPointValue].y);
        for (int i = 1; i < 5; i++)
        {
            CGContextAddLineToPoint(context, [[self.vertices objectAtIndex:i] CGPointValue].x, [[self.vertices objectAtIndex:i] CGPointValue].y);
        }
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [self randomColor].CGColor);
        CGContextFillPath(context);
        
        CGFloat rectSize = 10;
        for (NSValue* point in self.vertices) {
            CGRect miniRect = CGRectMake([point CGPointValue].x - rectSize / 2, [point CGPointValue].y - rectSize / 2, rectSize, rectSize);
            CGContextAddEllipseInRect(context, miniRect);
        }
        CGContextSetFillColorWithColor(context, [self randomColor].CGColor);
        CGContextFillPath(context);
        
        CGContextMoveToPoint(context, [[self.vertices objectAtIndex:0] CGPointValue].x, [[self.vertices objectAtIndex:0] CGPointValue].y);
        CGContextAddLineToPoint(context, [[self.vertices objectAtIndex:3] CGPointValue].x, [[self.vertices objectAtIndex:3] CGPointValue].y);
        CGContextAddLineToPoint(context, [[self.vertices objectAtIndex:1] CGPointValue].x, [[self.vertices objectAtIndex:1] CGPointValue].y);
        CGContextAddLineToPoint(context, [[self.vertices objectAtIndex:4] CGPointValue].x, [[self.vertices objectAtIndex:4] CGPointValue].y);
        CGContextAddLineToPoint(context, [[self.vertices objectAtIndex:2] CGPointValue].x, [[self.vertices objectAtIndex:2] CGPointValue].y);
        CGContextAddLineToPoint(context, [[self.vertices objectAtIndex:0] CGPointValue].x, [[self.vertices objectAtIndex:0] CGPointValue].y);
        
        CGContextSetStrokeColorWithColor(context, [self randomColor].CGColor);
        CGContextStrokePath(context);
        
        [self.vertices removeAllObjects];
    }
        
    NSLog(@"drawRect = %@", NSStringFromCGRect(rect));
}

#pragma mark - additional methods -

- (BOOL)doesRect:(CGRect)rect crossSomeOfRects:(NSMutableArray*)rects {
    BOOL result = NO;
    for (NSValue* valRect in rects) {
        CGRect someRect = [valRect CGRectValue];
        if (CGRectIntersectsRect(someRect, rect)) {
            result = YES;
            break;
        }
    }
    return result;
}

- (UIColor*)randomColor {
    CGFloat r = (arc4random() % 256) / 255.f;
    CGFloat g = (arc4random() % 256) / 255.f;
    CGFloat b = (arc4random() % 256) / 255.f;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.f];
}

- (CGFloat)randomFrom:(CGFloat)from To:(CGFloat)to {
    return (arc4random() % (int)(to - from)) + from;
}


@end
