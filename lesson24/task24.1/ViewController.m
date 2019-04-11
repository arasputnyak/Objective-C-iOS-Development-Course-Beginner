//
//  ViewController.m
//  Lesson24Task1
//
//  Created by Анастасия Распутняк on 09.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"
#import "ARDrawView.h"

typedef enum {
    ARDrawViewNone,
    ARViewTypeColor,
    ARViewTypeSize,
    ARViewTypeDrawView
} ARViewType;

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *colors;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *sizes;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.tag = ARDrawViewNone;
    
    for (UIView* color in self.colors) {
        color.tag = ARViewTypeColor;
    }
    
    int r = 10;
    for (UIView* size in self.sizes) {
        size.tag = ARViewTypeSize;
        
        size.layer.cornerRadius = r;
        size.layer.masksToBounds = true;
        
        r += 8;
    }
    
    self.drawView.tag = ARViewTypeDrawView;
    self.drawView.drawColor = [UIColor clearColor];
    self.drawView.drawPoints = [[NSMutableDictionary alloc] init];
    self.drawView.layer.borderColor = [UIColor blackColor].CGColor;
    self.drawView.layer.borderWidth = 1.f;
    
    self.settingsPanel.layer.cornerRadius = 20;
    self.settingsPanel.layer.masksToBounds = true;
    self.settingsPanel.layer.borderColor = [UIColor blackColor].CGColor;
    self.settingsPanel.layer.borderWidth = 3.0f;
    
}

#pragma mark - touches -

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"began");
    
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    UIView* view = [self.view hitTest:touchPoint withEvent:event];    
    
    if (view.tag == ARViewTypeColor) {
        self.drawView.drawColor = view.backgroundColor;
    }
    
    if (view.tag == ARViewTypeSize) {
        self.drawView.drawSize = CGRectGetWidth(view.frame);
    }
    
    [self drawOnView:view withTouch:touch];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"moved");
    
    UITouch* touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    UIView* view = [self.view hitTest:touchPoint withEvent:event];
    
    [self drawOnView:view withTouch:touch];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"ended");
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"cancelled");
    
}

#pragma mark - drawing -

- (void)drawOnView:(UIView*)view withTouch:(UITouch*)touch {
    if (view.tag == ARViewTypeDrawView) {
        NSArray* pointParametres = @[self.drawView.drawColor, [NSNumber numberWithFloat:self.drawView.drawSize]];
        [self.drawView.drawPoints setObject:pointParametres forKey:NSStringFromCGPoint([touch locationInView:self.drawView])];
        
        // рисуем
        [self.drawView setNeedsDisplay];
    }
}

#pragma mark - lock orientation -

// these methods don't work
// ???

//-(NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//-(BOOL)shouldAutorotate {
//    return NO;
//}

//-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
//    return UIInterfaceOrientationMaskPortrait;
//}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
