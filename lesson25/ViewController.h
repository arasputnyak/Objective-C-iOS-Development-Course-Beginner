//
//  ViewController.h
//  Lesson25Task
//
//  Created by Анастасия Распутняк on 09.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AROperationTypeNone,
    AROperationTypeSummation,
    AROperationTypeSubtraction,
    AROperationTypeMultiplication,
    AROperationTypeDivision
} AROperationType;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *equalityButton;
@property (weak, nonatomic) IBOutlet UIButton *signButton;
@property (weak, nonatomic) IBOutlet UIButton *commaButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *numbers;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *operations;

@property (assign, nonatomic) double firstNumber;
@property (assign, nonatomic) double secondNumber;
@property (assign, nonatomic) AROperationType operation;

@end

