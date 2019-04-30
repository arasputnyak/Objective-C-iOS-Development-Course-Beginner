//
//  ARDatePickerController.m
//  Lesson36Task
//
//  Created by Анастасия Распутняк on 29.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARDatePickerController.h"

@interface ARDatePickerController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)actionCancel:(UIButton *)sender;
- (IBAction)actionOk:(UIButton *)sender;
@end

@implementation ARDatePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preferredContentSize = CGSizeMake(340, 380);
}

#pragma mark - Actions -

- (IBAction)actionCancel:(UIButton *)sender {
    NSLog(@"cancel button");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionOk:(UIButton *)sender {
    NSLog(@"ok button");
    
    if (![self.date isEqual:self.datePicker.date]) {
        self.date = self.datePicker.date;
        [self.delegate dateControllerendsUpdates:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
