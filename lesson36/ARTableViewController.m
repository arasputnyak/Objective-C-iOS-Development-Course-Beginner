//
//  ARTableViewController.m
//  Lesson36Task
//
//  Created by Анастасия Распутняк on 28.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARTableViewController.h"
#import "ARExplanationController.h"
#import "ARDatePickerController.h"
#import "AREducationController.h"

@interface ARTableViewController () <UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITableViewDelegate,
                                     ARDatePickerControllerDelegate, AREducationControllerDelegate>
@property (strong, nonatomic) ARDatePickerController* dateController;
@property (strong, nonatomic) NSIndexPath* chosenEducation;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;
@property (weak, nonatomic) IBOutlet UITextField *birthDateField;
@property (weak, nonatomic) IBOutlet UITextField *educationField;

- (IBAction)actionShowInfo:(UIBarButtonItem *)sender;
- (IBAction)actionShowDatePicker:(UITextField *)sender;
- (IBAction)actionSave:(UIButton *)sender;
- (IBAction)actionLoad:(UIButton *)sender;
@end

static NSString* kFirstNameField        = @"firstName";
static NSString* kLastNameField         = @"lastName";
static NSString* kGenderField           = @"gender";
static NSString* kBirthDateField        = @"birthDate";
static NSString* kEducationField        = @"education";

@implementation ARTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delaysContentTouches = NO;
}

#pragma mark - Actions -

- (IBAction)actionShowInfo:(UIBarButtonItem *)sender {
    
    ARExplanationController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARExplanationController"];
    
    infoController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:infoController
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController *popController = [infoController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.barButtonItem = sender;
    popController.delegate = self;
    
}

- (IBAction)actionShowDatePicker:(UITextField *)sender {
    [sender resignFirstResponder];
    
    if (!self.dateController) {
        self.dateController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARDatePickerController"];
        self.dateController.delegate = self;
    }
    
    self.dateController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:self.dateController
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController* popController = [self.dateController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.delegate = self;
    
    popController.sourceView = sender;
}

- (IBAction)actionSave:(UIButton *)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:self.firstNameField.text forKey:kFirstNameField];
    [userDefaults setObject:self.lastNameField.text forKey:kLastNameField];
    [userDefaults setBool:self.genderControl.selectedSegmentIndex forKey:kGenderField];
    [userDefaults setObject:self.birthDateField.text forKey:kBirthDateField];
    [userDefaults setObject:self.educationField.text forKey:kEducationField];
}

- (IBAction)actionLoad:(UIButton *)sender {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.firstNameField.text = [userDefaults objectForKey:kFirstNameField];
    self.lastNameField.text = [userDefaults objectForKey:kLastNameField];
    self.genderControl.selectedSegmentIndex = [userDefaults boolForKey:kGenderField];
    self.birthDateField.text = [userDefaults objectForKey:kBirthDateField];
    self.educationField.text = [userDefaults objectForKey:kEducationField];
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 5) {
        return 70;
    } else {
        return 60;
    }
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([textField isEqual:self.firstNameField] || [textField isEqual:self.lastNameField]) {
        NSCharacterSet* validationSet = [[NSCharacterSet letterCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        
        if ([components count] > 1) return NO;
        
        if ([[textField.text stringByAppendingString:string] length] > 30) return NO;
    }
    
    if ([textField isEqual:self.birthDateField]) return NO;
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.educationField]) {
        UINavigationController* educController = [self.storyboard instantiateViewControllerWithIdentifier:@"EducNavigationController"];
        AREducationController* ec = (AREducationController*)educController.topViewController;
        if (self.chosenEducation) {
            ec.chosenEducation = self.chosenEducation;
        }
        ec.delegate = self;
        
        educController.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:educController
                           animated:YES
                         completion:nil];
        
        UIPopoverPresentationController* popController = [educController popoverPresentationController];
        popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
        popController.delegate = self;
        
        popController.sourceView = textField;
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.firstNameField]) {
        [self.lastNameField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
}

#pragma mark - ARDatePickerControllerDelegate -

- (void)dateControllerendsUpdates:(ARDatePickerController*)datePickerController {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    self.birthDateField.text = [dateFormatter stringFromDate:datePickerController.date];
    
}

#pragma mark - AREducationControllerDelegate -

- (void)updateEducation:(AREducationController*)educController {
    self.educationField.text = educController.educationType;
    self.chosenEducation = educController.chosenEducation;
}


@end
