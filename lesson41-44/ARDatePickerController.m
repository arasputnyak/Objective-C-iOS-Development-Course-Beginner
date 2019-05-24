//
//  ARDatePickerController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 22.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARDatePickerController.h"

@interface ARDatePickerController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)actionOk:(UIButton *)sender;
- (IBAction)actionCancel:(UIButton *)sender;
@end

@implementation ARDatePickerController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if (self.date) [self.datePicker setDate:self.date];
    
}

#pragma mark - Actions -

- (IBAction)actionOk:(UIButton *)sender {
    
    if (![self.date isEqual:self.datePicker.date]) {
        self.date = self.datePicker.date;
        [self.delegate dateControllerSendsUpdates:self];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionCancel:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
