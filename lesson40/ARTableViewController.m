//
//  ARTableViewController.m
//  Lesson40Task
//
//  Created by Анастасия Распутняк on 12.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARTableViewController.h"
#import "ARStudent.h"

typedef enum {
    ARTextFieldTypeFN,
    ARTextFieldTypeLN,
    ARTextFieldTypeGD
} ARTextFieldType;

@interface ARTableViewController () <UITextFieldDelegate, UITableViewDelegate>
@property (strong, nonatomic) ARStudent* student;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *gradeField;

- (IBAction)actionReset:(UIBarButtonItem *)sender;
@end

@implementation ARTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.student = [[ARStudent alloc] init];
    self.student.firstName = @"";
    self.student.lastName = @"";
    self.student.grade = 0;
    
    [self resetTextFields];
    
    [self.student addObserver:self
                   forKeyPath:@"firstName"
                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.student addObserver:self
                   forKeyPath:@"lastName"
                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.student addObserver:self
                   forKeyPath:@"grade"
                      options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                      context:nil];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    NSString* key = nil;
    NSError* error = nil;
    BOOL validation = nil;
    NSObject* value = nil;
    // NSNumber* numVal = nil;
    
    switch (textField.tag) {
        case ARTextFieldTypeFN:
            key = @"firstName";
            value = textField.text;
            validation = [self.student validateValue:&value
                                              forKey:key
                                               error:&error];
            break;
            
        case ARTextFieldTypeLN:
            key = @"lastName";
            value = textField.text;
            validation = [self.student validateValue:&value
                                              forKey:key
                                               error:&error];
            break;
            
        case ARTextFieldTypeGD:
            key = @"grade";
            value = [NSNumber numberWithInteger:[textField.text integerValue]];
            validation = [self.student validateValue:&value
                                              forKey:key
                                               error:&error];
            break;
            
        default:
            break;
    }
    
    if (!validation) {
        NSLog(@"ne ok!");
        
        textField.text = [NSString stringWithFormat:@"%@", [self.student valueForKey:key]];
        
    } else {
        NSLog(@"ok!");
        
        [self.student setValue:value
                        forKey:key];
    }
    
    
    return YES;
}

#pragma mark - Observing -

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"student changed %@", keyPath);
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - Actions -

- (IBAction)actionReset:(UIBarButtonItem *)sender {
    [self.student resetProperties];
    
    [self resetTextFields];
}

- (void)resetTextFields {
    self.firstNameField.text = self.student.firstName;
    self.lastNameField.text = self.student.lastName;
    self.gradeField.text = [NSString stringWithFormat:@"%d", 0];
}


@end
