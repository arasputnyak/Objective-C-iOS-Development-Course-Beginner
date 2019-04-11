//
//  ViewController.m
//  Lesson24Task
//
//  Created by Анастасия Распутняк on 08.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"
#import "ARStarView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.starView.starsCount = 5;
    
    self.starView.layer.borderColor = [UIColor blackColor].CGColor;
    self.starView.layer.borderWidth = 1.f;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
        [self.starView setNeedsDisplay];
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}


@end
