//
//  ViewController.m
//  Lesson21Task
//
//  Created by Анастасия Распутняк on 04.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    ARViewColourGreen,
    ARViewColourCyan,
    ARViewColourBlue,
    ARViewColourMagenta
} ARViewColour;

@interface ViewController ()
@property (strong, nonatomic) NSArray* colours;

- (void) moveViewHorizontically:(UIView*)view inTime:(NSTimeInterval)time andOptions:(UIViewAnimationOptions)options;
- (void) moveViewClockwise:(UIView*)view inTime:(NSTimeInterval)time andOptions:(UIViewAnimationOptions)options;
- (UIColor*) randomColour;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.colours = @[[UIColor greenColor], [UIColor cyanColor], [UIColor blueColor], [UIColor magentaColor]];
    
    /*
    int indent = 30;
    int rectWidth = 100;
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, indent, rectWidth, rectWidth)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(0, indent * 2 + rectWidth, rectWidth, rectWidth)];
    view2.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view2];
    
    UIView* view3 = [[UIView alloc] initWithFrame:CGRectMake(0, indent * 3 + rectWidth * 2, rectWidth, rectWidth)];
    view3.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:view3];
    
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(0, indent * 4 + rectWidth * 3, rectWidth, rectWidth)];
    view4.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view4];
    
    NSTimeInterval generalInterval = 3;
    
    [self moveViewHorizontically:view1
                          inTime:generalInterval
                      andOptions:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
    
    [self moveViewHorizontically:view2
                          inTime:generalInterval
                      andOptions:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
    
    [self moveViewHorizontically:view3
                          inTime:generalInterval
                      andOptions:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
    
    [self moveViewHorizontically:view4
                          inTime:generalInterval
                      andOptions:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat];
    */
    
    /*
    int viewWidth = 200;
    CGRect mainViewRect = self.view.frame;
    
    UIView* view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
    view1.backgroundColor = [self.colours objectAtIndex:0];
    view1.tag = ARViewColourGreen;
    [self.view addSubview:view1];
    
    UIView* view2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewRect) - viewWidth, 0, viewWidth, viewWidth)];
    view2.backgroundColor = [self.colours objectAtIndex:1];
    view2.tag = ARViewColourCyan;
    [self.view addSubview:view2];
    
    UIView* view3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(mainViewRect) - viewWidth, CGRectGetHeight(mainViewRect) - viewWidth, viewWidth, viewWidth)];
    view3.backgroundColor = [self.colours objectAtIndex:2];
    view3.tag = ARViewColourBlue;
    [self.view addSubview:view3];
    
    UIView* view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(mainViewRect) - viewWidth, viewWidth, viewWidth)];
    view4.backgroundColor = [self.colours objectAtIndex:3];
    view4.tag = ARViewColourMagenta;
    [self.view addSubview:view4];
    
    
    int generalInterval = 5;
    [self moveViewClockwise:view1 inTime:generalInterval andOptions:UIViewAnimationOptionCurveLinear];
    [self moveViewClockwise:view2 inTime:generalInterval andOptions:UIViewAnimationOptionCurveLinear];
    [self moveViewClockwise:view3 inTime:generalInterval andOptions:UIViewAnimationOptionCurveLinear];
    [self moveViewClockwise:view4 inTime:generalInterval andOptions:UIViewAnimationOptionCurveLinear]; */
    
    int manWidth = 200;
    int manHeight = 100;
    int indent = 100;
    
    UIImageView* walkingMan = [[UIImageView alloc] initWithFrame: CGRectMake(CGRectGetWidth(self.view.frame) - manWidth, indent, manWidth, manHeight)];
    walkingMan.backgroundColor = [UIColor blueColor];
    walkingMan.animationDuration = 1.f;
    [self.view addSubview:walkingMan];
    
    UIImage* img11 = [UIImage imageNamed:@"4.png"];
    UIImage* img22 = [UIImage imageNamed:@"5.png"];
    UIImage* img33 = [UIImage imageNamed:@"6.png"];
    UIImage* img44 = [UIImage imageNamed:@"7.png"];
    
    NSArray* walkingManImgs = @[img11, img22, img33, img44];
    walkingMan.animationImages = walkingManImgs;
    [walkingMan startAnimating];
    
    UIImageView* flyingMan = [[UIImageView alloc] initWithFrame:CGRectMake(indent, CGRectGetHeight(self.view.frame) - manHeight, manWidth, manHeight)];
    flyingMan.backgroundColor = [UIColor whiteColor];
    flyingMan.animationDuration = 1.f;
    [self.view addSubview:flyingMan];
    
    UIImage* img1 = [UIImage imageNamed:@"1.png"];
    UIImage* img2 = [UIImage imageNamed:@"2.png"];
    UIImage* img3 = [UIImage imageNamed:@"3.png"];
    
    NSArray* flyingManImgs = @[img1, img2, img3, img2];
    flyingMan.animationImages = flyingManImgs;
    [flyingMan startAnimating];
    
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         CGPoint newCentre = CGPointMake(200, walkingMan.center.y);
                         walkingMan.center = newCentre;
                     }
                     completion:^(BOOL finished) {
                         // NSLog(@"animation completed");
                     }];
    
    [UIView animateWithDuration:5
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                     animations:^{
                         CGPoint newCentre = CGPointMake(flyingMan.center.x, 600);
                         flyingMan.center = newCentre;
                     }
                     completion:^(BOOL finished) {
                         // NSLog(@"animation completed");
                     }];
    
    
}

- (void) moveViewHorizontically:(UIView*)view inTime:(NSTimeInterval)time andOptions:(UIViewAnimationOptions)options {
    
    [UIView animateWithDuration:time
                          delay:0
                        options:options
                     animations:^{
                         CGPoint newCentre = CGPointMake(CGRectGetWidth(self.view.frame) - view.center.x, view.center.y);
                         view.center = newCentre;
                         
                         view.backgroundColor = [self randomColour];
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"animation completed");
                     }];
    
}

- (void) moveViewClockwise:(UIView*)view inTime:(NSTimeInterval)time andOptions:(UIViewAnimationOptions)options {
    
    [UIView animateWithDuration:time
                          delay:0
                        options:options
                     animations:^{
                         CGRect mainRect = self.view.frame;
                         
                         CGPoint top1 = CGPointMake(0, 0);
                         CGPoint top2 = CGPointMake(CGRectGetWidth(mainRect) - CGRectGetWidth(view.frame), 0);
                         CGPoint top3 = CGPointMake(CGRectGetWidth(mainRect) - CGRectGetWidth(view.frame), CGRectGetHeight(mainRect) - CGRectGetHeight(view.frame));
                         CGPoint top4 = CGPointMake(0, CGRectGetHeight(mainRect) - CGRectGetHeight(view.frame));
                         
                         if (CGPointEqualToPoint(view.frame.origin, top1) || CGPointEqualToPoint(view.frame.origin, top3)) {
                             CGPoint newCentre = CGPointMake(fabs(CGRectGetWidth(mainRect) - view.center.x), view.center.y);
                             view.center = newCentre;
                         } else if (CGPointEqualToPoint(view.frame.origin, top2) || CGPointEqualToPoint(view.frame.origin, top4)) {
                             CGPoint newCentre = CGPointMake(view.center.x, fabs(CGRectGetHeight(mainRect) - view.center.y));
                             view.center = newCentre;
                         }
                         
                         switch (view.tag) {
                             case ARViewColourGreen:
                                 view.backgroundColor = [self.colours objectAtIndex:ARViewColourCyan];
                                 view.tag = ARViewColourCyan;
                                 break;
                                 
                             case ARViewColourCyan:
                                 view.backgroundColor = [self.colours objectAtIndex:ARViewColourBlue];
                                 view.tag = ARViewColourBlue;
                                 break;
                                 
                             case ARViewColourBlue:
                                 view.backgroundColor = [self.colours objectAtIndex:ARViewColourMagenta];
                                 view.tag = ARViewColourMagenta;
                                 break;
                                 
                             case ARViewColourMagenta:
                                 view.backgroundColor = [self.colours objectAtIndex:ARViewColourGreen];
                                 view.tag = ARViewColourGreen;
                                 break;
                                 
                             default:
                                 break;
                         }
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"animation completed");
                         
                         [self moveViewClockwise:view inTime:time andOptions:options];
                     }];
    
}

- (UIColor*) randomColour {
    float r = (float)(arc4random() % 256) / 255;
    float g = (float)(arc4random() % 256) / 255;
    float b = (float)(arc4random() % 256) / 255;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

@end
