//
//  ARExplanationController.m
//  Lesson36Task
//
//  Created by Анастасия Распутняк on 28.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARExplanationController.h"

@interface ARExplanationController ()
- (IBAction)actionOk:(UIButton *)sender;
@end

@implementation ARExplanationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preferredContentSize = CGSizeMake(340, 340);
    
    self.view.layer.shadowOffset = CGSizeMake(0, 5);
    self.view.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1f].CGColor;
    self.view.layer.shadowOpacity = 0.5;
    self.view.layer.shadowRadius = 5;
}

- (IBAction)actionOk:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
