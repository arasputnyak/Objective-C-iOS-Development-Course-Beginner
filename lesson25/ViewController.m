//
//  ViewController.m
//  Lesson25Task
//
//  Created by Анастасия Распутняк on 09.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // for storyboard
    /*
    CGFloat offsetWidth = 10;
    CGFloat buttonWidth = (CGRectGetWidth(self.panelView.frame) - offsetWidth * 3) / 4;
    CGFloat offsetHeight = (CGRectGetHeight(self.panelView.frame) - buttonWidth * 5) / 4;
    
    NSLog(@"size = %f", buttonWidth);
    NSLog(@"offset y = %f", offsetHeight);
     */
    
    NSArray* buttons = [self.panelView subviews];
    for (UIButton* button in buttons) {
        button.layer.cornerRadius = 20;
        button.layer.masksToBounds = true;
        button.layer.borderColor = button.currentTitleColor.CGColor;
        button.layer.borderWidth = 1.0f;
        
        // set background color for highlighted-state????
    }
    
    for (UIButton* numberButton in self.numbers) {
        [numberButton addTarget:self
                         action:@selector(actionNumber:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (UIButton* operationButton in self.operations) {
        [operationButton addTarget:self
                            action:@selector(actionOperation:)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.equalityButton addTarget:self
                            action:@selector(actionEqual:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self.cancelButton addTarget:self
                          action:@selector(actionCancel:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self.signButton addTarget:self
                        action:@selector(actionSign:)
              forControlEvents:UIControlEventTouchUpInside];
    
    [self.commaButton addTarget:self
                         action:@selector(actionComma:)
               forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - actions -

- (void)actionNumber:(UIButton*)numberButton {
    double newLabelNumber;
    
    // "обнулить" лэйбл перед вводом второго числа операции
    if (self.operation != AROperationTypeNone && self.secondNumber == 0 && ![[self.displayLabel.text substringFromIndex:[self.displayLabel.text length] - 1] isEqualToString:@","] && ![self.displayLabel.text isEqualToString:@"-0"] && ![[self.displayLabel.text substringFromIndex:[self.displayLabel.text length] - 1] isEqualToString:@"0"]) {
        self.displayLabel.text = @"0";
    }
    
    NSString* labelText = self.displayLabel.text;
    NSRange commaRange = [labelText rangeOfString:@","];
    NSRange minusRange = [labelText rangeOfString:@"-"];
    
    
    if ([labelText length] < 9 || ([labelText length] == 9 && commaRange.location != NSNotFound)) {
        NSMutableString* new;
        
        NSInteger buttonNumber = [numberButton.titleLabel.text integerValue];
        
        if ([labelText isEqualToString:@"0"]) {
            new = [numberButton.titleLabel.text mutableCopy];
        } else if ([labelText isEqualToString:@"-0"]) {
            new = [[NSString stringWithFormat:@"-%@", numberButton.titleLabel.text] mutableCopy];
        } else {
            new = [[labelText stringByAppendingString:numberButton.titleLabel.text] mutableCopy];
        }
    
        self.displayLabel.text = new;
        
        if (commaRange.location == NSNotFound) {
            newLabelNumber = minusRange.location == NSNotFound ? ([labelText longLongValue] * 10 + buttonNumber) : (-([labelText longLongValue] * 10 + buttonNumber));
            // newLabelNumber = [labelText longLongValue] * 10 + buttonNumber;
        } else {
            [new replaceCharactersInRange:commaRange withString:@"."];
            newLabelNumber = [new doubleValue];
        }
        
        if (self.operation == AROperationTypeNone) {
            self.firstNumber = newLabelNumber;
        } else {
            self.secondNumber = newLabelNumber;
        }
        
    }
    
    NSLog(@"first = %f, second = %f", self.firstNumber, self.secondNumber);
    
}

- (void)actionOperation:(UIButton*)operationButton {
    
    if (operationButton.tag == AROperationTypeSummation) {
        self.operation = AROperationTypeSummation;
    }
    
    if (operationButton.tag == AROperationTypeSubtraction) {
        self.operation = AROperationTypeSubtraction;
    }
    
    if (operationButton.tag == AROperationTypeMultiplication) {
        self.operation = AROperationTypeMultiplication;
    }
    
    if (operationButton.tag == AROperationTypeDivision) {
        self.operation = AROperationTypeDivision;
    }
    
}

- (void)actionEqual:(UIButton*)equalityButton {
    double result = 0;
    
    if (self.operation == AROperationTypeNone) {
        result = self.firstNumber;
    } else {
        
        switch (self.operation) {
                
            case AROperationTypeSummation:
                result = self.firstNumber + self.secondNumber;
                break;
                
            case AROperationTypeSubtraction:
                result = self.firstNumber - self.secondNumber;
                break;
                
            case AROperationTypeMultiplication:
                result = self.firstNumber * self.secondNumber;
                break;
                
                case AROperationTypeDivision:
                result = self.firstNumber / self.secondNumber;
                break;
                
            default:
                break;
        }
        
        self.firstNumber = result;
        self.secondNumber = 0;
        for (UIButton* operationButton in self.operations) {
            if (operationButton.tag == self.operation) {
                [operationButton setSelected:NO];
            }
        }
        self.operation = AROperationTypeNone;
        
    }
    
    self.displayLabel.text = [self doubleToString:result];
    
}

- (void)actionCancel:(UIButton*)cancelButton {
    
    if (self.operation == AROperationTypeNone) {
        self.firstNumber = 0;
        
        self.displayLabel.text = @"0";
    } else {
        
        for (UIButton* operationButton in self.operations) {
            if (operationButton.tag == self.operation) {
                if (self.secondNumber != 0) {
                    [operationButton setSelected:YES];
                } else {
                    [operationButton setSelected:NO];
                    self.operation = AROperationTypeNone;
                }
            }
        }
        
        self.secondNumber = 0;
        
        self.displayLabel.text = @"0";
    }
}

- (void)actionSign:(UIButton*)signButton {
    if (self.operation == AROperationTypeNone) {
        self.firstNumber *= -1;
    } else {
        self.secondNumber *= -1;
        self.displayLabel.text = @"0";
    }
    
    NSRange minusRange = [self.displayLabel.text rangeOfString:@"-"];
    if (minusRange.location == NSNotFound) {
        self.displayLabel.text = [NSString stringWithFormat:@"-%@", self.displayLabel.text];
    } else {
        self.displayLabel.text = [self.displayLabel.text substringFromIndex:minusRange.location + 1];
    }
    
}

- (void)actionComma:(UIButton*)commaButton {
    
    NSString* labelNumber = self.displayLabel.text;
    
    if (![labelNumber containsString:@","] && [labelNumber length] < 9) {
        self.displayLabel.text = [labelNumber stringByAppendingString:@","];
    }
}

#pragma mark - additional methods -

- (NSString*)doubleToString:(double)doubleNumber {

    NSMutableString* newLabelText = [[NSString stringWithFormat:@"%.12lf", doubleNumber] mutableCopy];
    
    while ([[newLabelText substringFromIndex:[newLabelText length] - 1] isEqualToString:@"0"]) {
        [newLabelText deleteCharactersInRange:NSMakeRange([newLabelText length] - 1, 1)];
    }
    
    NSRange dotRange = [newLabelText rangeOfString:@"."];
    
    if ([[newLabelText substringFromIndex:[newLabelText length] - 1] isEqualToString:@"."]) {
        [newLabelText deleteCharactersInRange:NSMakeRange([newLabelText length] - 1, 1)];
    } else {
        [newLabelText replaceCharactersInRange:dotRange withString:@","];
    }
    
    return newLabelText;
}

#pragma mark - lock orientation -

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskPortrait;
}

@end
