//
//  ViewController.h
//  Lesson26Task
//
//  Created by Анастасия Распутняк on 12.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UISwitch *rotationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *scaleSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *translationSwitch;

- (IBAction)actionSlider:(UISlider *)slider;
- (IBAction)actionSegmControl:(UISegmentedControl *)sender;

@end

