//
//  ViewController.m
//  Lesson27Task
//
//  Created by Анастасия Распутняк on 14.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    ARTextFieldTypeFirstName,
    ARTextFieldTypeLastName,
    ARTextFieldTypeLogin,
    ARTextFieldTypePassword,
    ARTextFieldTypeAge,
    ARTextFieldTypeMobile,
    ARTextFieldTypeEmail,
    ARTextFieldTypeAdress
} ARTextFieldType;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    for (UITextField* textField in self.textFields) {
        textField.delegate = self;
    }
}

#pragma mark - actions -

- (IBAction)actionTextFieldChanged:(UITextField *)textField {
    switch (textField.tag) {
        case ARTextFieldTypeFirstName:
            self.firstNameLabel.text = textField.text;
            break;
            
        case ARTextFieldTypeLastName:
            self.lastNameLabel.text = textField.text;
            break;
            
        case ARTextFieldTypeLogin:
            self.loginLabel.text = textField.text;
            break;
            
        case ARTextFieldTypePassword:
            self.passwordLabel.text = textField.text;
            break;
            
        case ARTextFieldTypeAge:
            self.ageLabel.text = textField.text;
            break;
            
        case ARTextFieldTypeMobile:
            self.mobileLabel.text = textField.text;
            break;
            
        case ARTextFieldTypeEmail:
            self.emailLabel.text = textField.text;
            break;
            
        case ARTextFieldTypeAdress:
            self.adressLabel.text = textField.text;
            break;
            
        default:
            break;
    }
}

- (IBAction)actionTextFieldBeginEditing:(UITextField *)textField {
    [self formatMobileField:textField];
    self.mobileLabel.text = @"+7 (9  ) ";
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger current = [self.textFields indexOfObject:textField];
    
    if (![textField isEqual:self.adressTextField]) {
        UITextField* next = [self.textFields objectAtIndex:current + 1];
        [next becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return  YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    switch (textField.tag) {
        case ARTextFieldTypeFirstName:
            self.firstNameLabel.text = @"";
            break;
            
        case ARTextFieldTypeLastName:
            self.lastNameLabel.text = @"";
            break;
            
        case ARTextFieldTypeLogin:
            self.loginLabel.text = @"";
            break;
            
        case ARTextFieldTypePassword:
            self.passwordLabel.text = @"";
            break;
            
        case ARTextFieldTypeAge:
            self.ageLabel.text = @"";
            break;
            
        case ARTextFieldTypeMobile:
            self.mobileLabel.text = @"";
            [self formatMobileField:textField];
            break;
            
        case ARTextFieldTypeEmail:
            self.emailLabel.text = @"";
            break;
            
        case ARTextFieldTypeAdress:
            self.adressLabel.text = @"";
            break;
            
        default:
            break;
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"range = %@", NSStringFromRange(range));
    NSLog(@"string = %@", string);
    
    if (textField.tag == ARTextFieldTypeFirstName || textField.tag == ARTextFieldTypeLastName) {
        // NSLog(@"name$$$!");
        NSCharacterSet* validationSet = [[NSCharacterSet letterCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        
        if ([components count] > 1) return NO;
        
        // ограничение по длине??
    }
    
    if (textField.tag == ARTextFieldTypeAge) {
        // NSLog(@"age");
        NSString* result = [textField.text stringByAppendingString:string];
        if ([result length] > 2) {
            return NO;
        }
        
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        if ([components count] > 1) return NO;
    }
    
    if (textField.tag == ARTextFieldTypeMobile) {
        static const int countryLen = 1;
        static const int regionLen = 3;
        static const int numFirstPart = 3;
        static const int numSecPart = 4;
        
        int maxNumberLength = countryLen + regionLen + numFirstPart + numSecPart;
        
        // запрет на изменение шаблона
        if ((range.location >= 0 && range.location <= 4) || range.location == 7) {
            NSLog(@"2");
            return NO;
        }
        
        // запрет на добавление НЕ-цифр
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        if ([components count] > 1) return NO;
        
        // запрет на номер длиннее 11 цифр
        NSArray* cmps = [textField.text componentsSeparatedByCharactersInSet:validationSet];
        NSString* numbers = [[cmps componentsJoinedByString:@""] stringByAppendingString:string];
        if ([numbers length] > maxNumberLength) return NO;
        
        
        if ([string length] == 1) {
            if (range.location >= 5 && range.location <= 6) {
                
                NSRange replaceRange = NSMakeRange(range.location, [string length]);
                NSMutableString* res = [textField.text mutableCopy];
                [res replaceCharactersInRange:replaceRange withString:string];
                textField.text = res;
                
                if (range.location == 5) {
                    [self selectTextForInput:textField atRange:NSMakeRange(replaceRange.location + replaceRange.length, 0)];
                }
                
                [self actionTextFieldChanged:textField];
                
                return NO;
            }
            
            if (range.location == 11) {
                NSMutableString* res = [[[textField.text stringByAppendingString:string] stringByAppendingString:@"-"] mutableCopy];
                textField.text = res;
                
                [self actionTextFieldChanged:textField];
                
                return NO;
                
            }
        
        }
        
        if ([string length] > 1) return NO;  // - for now
        
    }
    
    if (textField.tag == ARTextFieldTypeEmail) {
        if ([[textField.text stringByAppendingString:string] length] > 30) return NO;
        
        if ([string length] > 0) {
            NSMutableCharacterSet* superset = [NSMutableCharacterSet characterSetWithCharactersInString:@".-_@"];
            
            if (([textField.text isEqualToString:@""] || range.location == 0) && [superset characterIsMember:[string characterAtIndex:0]]) return NO;
            
            NSRange rangOfA = [textField.text rangeOfString:@"@"];
            if (rangOfA.location != NSNotFound) {
                
                NSMutableCharacterSet* miniset = [NSMutableCharacterSet characterSetWithCharactersInString:@"-_@"];
                NSArray* cmps = [string componentsSeparatedByCharactersInSet:miniset];
                if ([cmps count] > 1) return NO;
                
                if (rangOfA.location == [textField.text length] - 1 && [string characterAtIndex:0] == '.') return NO;
            }
            
            if ([superset characterIsMember:[textField.text characterAtIndex:[textField.text length] - 1]] && [string characterAtIndex:0] == '@') return NO;
            
            
            [superset formUnionWithCharacterSet:[NSCharacterSet letterCharacterSet]];
            [superset formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            NSCharacterSet* validationSet = [superset invertedSet];
            NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
            if ([components count] > 1) return NO;
        }

    }
    
    // WE DO NOT NEED TO WRITE break; IF WE HAVE WRITTEN return *; BEFORE!!!
    // switch (textField.tag) {}
    
    return YES;
}

#pragma mark - additional methods -

- (void)selectTextForInput:(UITextField *)input atRange:(NSRange)range {
    UITextPosition *start = [input positionFromPosition:[input beginningOfDocument]
                                                 offset:range.location];
    UITextPosition *end = [input positionFromPosition:start
                                               offset:range.length];
    [input setSelectedTextRange:[input textRangeFromPosition:start toPosition:end]];
}

- (void)formatMobileField:(UITextField*)textField {
    if (textField.tag == ARTextFieldTypeMobile && [textField.text length] == 0) {
        textField.text = @"+7 (9  ) ";
        [self selectTextForInput:textField atRange:NSMakeRange(5, 0)];
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
