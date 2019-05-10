//
//  ARStudentInfoTVController.h
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 08.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ARStudentInfoDelegate;

@interface ARStudentInfoTVController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UITextView *adressText;

@property (weak, nonatomic) id <ARStudentInfoDelegate> delegate;

@end



@protocol ARStudentInfoDelegate <NSObject>

- (void)insertStudentInfo:(ARStudentInfoTVController*)controller;

@end

NS_ASSUME_NONNULL_END
