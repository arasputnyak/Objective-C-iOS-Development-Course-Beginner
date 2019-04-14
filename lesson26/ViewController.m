//
//  ViewController.m
//  Lesson26Task
//
//  Created by Анастасия Распутняк on 12.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    ARSwitchTypeRotation,
    ARSwitchTypeScale,
    ARSwitchTypeTranslation
} ARSwitchType;

typedef enum {
    ARSegmControlImageOne,
    ARSegmControlImageTwo,
    ARSegmControlImageThree
} ARSegmControlImage;

@interface ViewController ()

@property (strong, nonatomic) UIImageView* imageView;

@property (strong, nonatomic) CABasicAnimation* rotationAnimation;
@property (strong, nonatomic) CABasicAnimation* scaleAnimation;
@property (strong, nonatomic) CABasicAnimation* translationAnimation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.frame = self.mainView.bounds;
    [self.mainView addSubview:self.imageView];
    
    
    [self.rotationSwitch addTarget:self
                            action:@selector(actionSwitch)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.scaleSwitch addTarget:self
                            action:@selector(actionSwitch)
                  forControlEvents:UIControlEventValueChanged];
    
    [self.translationSwitch addTarget:self
                            action:@selector(actionSwitch)
                  forControlEvents:UIControlEventValueChanged];
    
    self.rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    self.rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    self.rotationAnimation.duration = self.speedSlider.value;
    self.rotationAnimation.repeatCount = HUGE_VALF;
    
    self.scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    self.scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    self.scaleAnimation.toValue = [NSNumber numberWithFloat:2.0];
    self.scaleAnimation.repeatCount = HUGE_VAL;
    self.scaleAnimation.duration = self.speedSlider.value;
    self.scaleAnimation.autoreverses = YES;
    
    CGPoint startPoint = self.mainView.center;
    CGPoint endPoint = CGPointMake(CGRectGetWidth(self.view.frame) - startPoint.x, startPoint.y);
    self.translationAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    self.translationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.translationAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    self.translationAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    self.translationAnimation.duration = self.speedSlider.value;
    self.translationAnimation.autoreverses = YES;
    self.translationAnimation.repeatCount = HUGE_VAL;
    
}

#pragma mark - actions -

- (IBAction)actionSlider:(UISlider *)slider {
    [self.mainView.layer removeAllAnimations];
    
    self.scaleAnimation.duration = slider.value;
    self.rotationAnimation.duration = slider.value;
    self.translationAnimation.duration = slider.value;
    
    [self actionSwitch];
}

- (IBAction)actionSegmControl:(UISegmentedControl *)pictureSegmControl {
    switch (pictureSegmControl.selectedSegmentIndex) {
        case ARSegmControlImageOne:
            self.imageView.image = [UIImage imageNamed:@"full-moon-with-face.png"];
            break;
            
        case ARSegmControlImageTwo:
            self.imageView.image = [UIImage imageNamed:@"princess-light-skin-tone.png"];
            break;
            
        case ARSegmControlImageThree:
            self.imageView.image = [UIImage imageNamed:@"emoji-eye-png-8.png"];
            break;
            
        default:
            break;
    }
}

- (void)actionSwitch {
    if (self.rotationSwitch.isOn) {
        [self.mainView.layer addAnimation:self.rotationAnimation forKey:@"rotation"];
    } else {
        [self.mainView.layer removeAnimationForKey:@"rotation"];
    }
    
    if (self.scaleSwitch.isOn) {
        [self.mainView.layer addAnimation:self.scaleAnimation forKey:@"scale"];
    } else {
        [self.mainView.layer removeAnimationForKey:@"scale"];
    }
    
    if (self.translationSwitch.isOn) {
        [self.mainView.layer addAnimation:self.translationAnimation forKey:@"translation"];
    } else {
        [self.mainView.layer removeAnimationForKey:@"translation"];
    }
}

#pragma mark - lock orientation -

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskPortrait;
}

@end
