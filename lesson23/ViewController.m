//
//  ViewController.m
//  Lesson23Task
//
//  Created by Анастасия Распутняк on 06.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *simpleView;
@property (strong, nonatomic) UIViewPropertyAnimator* tapAnimator;
@property (strong, nonatomic) UIViewPropertyAnimator* rightSwipeAnimator;
@property (strong, nonatomic) UIViewPropertyAnimator* leftSwipeAnimator;
@property (assign, nonatomic) CGFloat simpleViewScale;
@property (assign, nonatomic) CGFloat simpleViewRotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view bringSubviewToFront:self.simpleView];
    self.simpleView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                      UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin;
    
    // single tap
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(handlerTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // double tap
    UITapGestureRecognizer* doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlerDoubleTap:)];
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
    
    [tapGesture requireGestureRecognizerToFail:doubleTapGesture]; // не запускаем тап, если был сделан тап-тап
    
    // right swipe
    UISwipeGestureRecognizer* rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handlerRightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGesture];
    
    // left swipe
    UISwipeGestureRecognizer* leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                           action:@selector(handlerLeftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGesture];
    
    // pinch
    UIPinchGestureRecognizer* pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handlerPinch:)];
    [self.view addGestureRecognizer:pinchGesture];
    
    // rotation
    UIRotationGestureRecognizer* rotationGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleRotation:)];
    [self.view addGestureRecognizer:rotationGesture];
    
    rotationGesture.delegate = self;
    pinchGesture.delegate = self;
}

#pragma mark - methods -

- (void)handlerTap:(UITapGestureRecognizer*)tapGesture {
    NSLog(@"tap!");
    
    self.tapAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:1
                                                                  curve:UIViewAnimationCurveLinear
                                                             animations:^{
                                                                 CGPoint tapPoint = [tapGesture locationInView:self.view];
                                                                 self.simpleView.center = tapPoint;
                                                                 // NSLog(@"tap = %@", NSStringFromCGPoint(tapPoint));
                                                             }];
    
    [self.tapAnimator startAnimation];
}

- (void)handlerDoubleTap:(UITapGestureRecognizer*)doubleTapGesture {
    NSLog(@"tap-tap!");
    
    [self.tapAnimator stopAnimation:YES];
    [self.rightSwipeAnimator stopAnimation:YES];
    [self.leftSwipeAnimator stopAnimation:YES];
    
}

- (void)handlerRightSwipe:(UISwipeGestureRecognizer*)rightSwipeGesture {
    NSLog(@"right swipe!");
    
    [self.leftSwipeAnimator stopAnimation:YES];
    
    self.rightSwipeAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:3
                                                                         curve:UIViewAnimationCurveLinear
                                                                    animations:^{
                                                                        
                                                                        for (int i = 0; i < 4; i++) {
                                                                            CGAffineTransform transform = CGAffineTransformRotate(self.simpleView.transform, M_PI_2);
                                                                            self.simpleView.transform = transform;
                                                                        }
                                                                        
                                                                    }];
    
    [self.rightSwipeAnimator startAnimation];
}

- (void)handlerLeftSwipe:(UISwipeGestureRecognizer*)leftSwipeGesture {
    NSLog(@"left swipe!");
    
    [self.rightSwipeAnimator stopAnimation:YES];
    
    self.leftSwipeAnimator = [[UIViewPropertyAnimator alloc] initWithDuration:3
                                                                        curve:UIViewAnimationCurveLinear
                                                                   animations:^{

                                                                       for (int i = 0; i < 4; i++) {
                                                                           CGAffineTransform transform = CGAffineTransformRotate(self.simpleView.transform, -M_PI_2);
                                                                           self.simpleView.transform = transform;
                                                                       }
                                                                    }];
    
    [self.leftSwipeAnimator startAnimation];
}

- (void)handlerPinch:(UIPinchGestureRecognizer*)pinchGesture {
    NSLog(@"pinch!");
    
    if (pinchGesture.state == UIGestureRecognizerStateBegan) {
        self.simpleViewScale = 1.f;
    }
    
    CGFloat newScale = 1.f + pinchGesture.scale - self.simpleViewScale;
    
    CGAffineTransform currentTransform = self.simpleView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, newScale, newScale);
    
    self.simpleView.transform = newTransform;
    self.simpleViewScale = pinchGesture.scale;
}

- (void)handleRotation:(UIRotationGestureRecognizer*)rotationGesture {
    NSLog(@"rotation!");
    
    if (rotationGesture.state == UIGestureRecognizerStateBegan) {
        self.simpleViewRotation = 0;
    }
    
    CGFloat newRotation = rotationGesture.rotation - self.simpleViewRotation;
    
    CGAffineTransform currentTransform = self.simpleView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, newRotation);
    
    self.simpleView.transform = newTransform;
    self.simpleViewRotation = rotationGesture.rotation;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - lock orientation

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskPortrait;
}

@end
