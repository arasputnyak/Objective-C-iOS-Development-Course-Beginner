//
//  ARTableViewController.m
//  Lesson29Task
//
//  Created by Анастасия Распутняк on 17.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARTableViewController.h"

typedef enum {
    ARTextFieldTypeFirstName,
    ARTextFieldTypeLastName,
    ARTextFieldTypeAge,
    ARTextFieldTypeLogin,
    ARTextFieldTypePassword
} ARTextFieldType;

@interface ARTableViewController ()
@property (strong, nonatomic) NSArray* keys;
@end

static NSString* kFirstNameField        = @"firstName";
static NSString* kLastNameField         = @"lastName";
static NSString* kAgeField              = @"age";
static NSString* kLoginField            = @"login";
static NSString* kPasswordField         = @"password";
static NSString* kLanguageControl       = @"language";
static NSString* kNotificationsSwitch   = @"notifications";
static NSString* kVolumeSliderValue     = @"volumeValue";
static NSString* kVolumeSliderStatus    = @"volumeStatus";

@implementation ARTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.keys = @[kFirstNameField, kLastNameField, kAgeField, kLoginField, kPasswordField];
    
    for (UITextField* textField in self.textFields) {
        textField.delegate = self;
    }
    
    [self loadData];
}

#pragma mark - actions -

- (IBAction)actionControl:(UISegmentedControl *)sender {
    [self saveData];
}

- (IBAction)actionSwitch:(UISwitch *)sender {
    if (sender.isOn) {
        self.volumeSlider.enabled = YES;
    } else {
        self.volumeSlider.enabled = NO;
    }
    
    [self saveData];
}

- (IBAction)actionSlider:(UISlider *)sender {
    [self saveData];
}

- (IBAction)actionTextFieldChanged:(UITextField *)sender {
    [self saveData];
}

#pragma mark - save and load -

- (void)saveData {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < [self.textFields count]; i++) {
        UITextField* tf = [self.textFields objectAtIndex:i];
        [userDefaults setObject:tf.text forKey:[self.keys objectAtIndex:i]];
    }
    
    [userDefaults setInteger:self.languageControl.selectedSegmentIndex forKey:kLanguageControl];
    [userDefaults setBool:self.notificationsSwitch.isOn forKey:kNotificationsSwitch];
    [userDefaults setDouble:self.volumeSlider.value forKey:kVolumeSliderValue];
    [userDefaults setBool:self.volumeSlider.isEnabled forKey:kVolumeSliderStatus];
}

- (void)loadData {
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    for (int i = 0; i < [self.textFields count]; i++) {
        UITextField* tf = [self.textFields objectAtIndex:i];
        tf.text = [userDefaults objectForKey:[self.keys objectAtIndex:i]];
    }
    
    self.languageControl.selectedSegmentIndex = [userDefaults integerForKey:kLanguageControl];
    self.notificationsSwitch.on = [userDefaults boolForKey:kNotificationsSwitch];
    self.volumeSlider.value = [userDefaults doubleForKey:kVolumeSliderValue];
    self.volumeSlider.enabled = [userDefaults boolForKey:kVolumeSliderStatus];
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField.tag == ARTextFieldTypeFirstName || textField.tag == ARTextFieldTypeLastName) {
        NSCharacterSet* validationSet = [[NSCharacterSet letterCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        
        if ([components count] > 1) return NO;
    }
    
    if (textField.tag == ARTextFieldTypeAge) {
        NSString* result = [textField.text stringByAppendingString:string];
        if ([result length] > 2) {
            return NO;
        }
        
        NSCharacterSet* validationSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSArray* components = [string componentsSeparatedByCharactersInSet:validationSet];
        if ([components count] > 1) return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger current = [self.textFields indexOfObject:textField];
    
    if (!(textField.tag == ARTextFieldTypePassword)) {
        UITextField* next = [self.textFields objectAtIndex:current + 1];
        [next becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - lock orientation -

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(NSUInteger)navigationControllerSupportedInterfaceOrientations:(UINavigationController *)navigationController {
    return UIInterfaceOrientationMaskPortrait;
}

@end
