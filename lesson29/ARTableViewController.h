//
//  ARTableViewController.h
//  Lesson29Task
//
//  Created by Анастасия Распутняк on 17.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARTableViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFields;
@property (weak, nonatomic) IBOutlet UISegmentedControl *languageControl;
@property (weak, nonatomic) IBOutlet UISwitch *notificationsSwitch;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

- (IBAction)actionControl:(UISegmentedControl *)sender;
- (IBAction)actionSwitch:(UISwitch *)sender;
- (IBAction)actionSlider:(UISlider *)sender;
- (IBAction)actionTextFieldChanged:(UITextField *)sender;


@end

NS_ASSUME_NONNULL_END
