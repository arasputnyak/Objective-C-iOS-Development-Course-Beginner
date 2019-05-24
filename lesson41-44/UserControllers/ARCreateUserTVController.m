//
//  ARCreateUserTVController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 16.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARCreateUserTVController.h"
#import "ARDataManager.h"
#import "../ARDatePickerController.h"
#import "../Cells/ARPictureCell.h"
#import "../Cells/ARAttributeCell.h"
#import "../Cells/ARItemCell.h"
#import "../Models/ARCourse+CoreDataClass.h"
#import "../UserControllers/ARUsersListTVController.h"

typedef enum {
    ARUserGenderFemale,
    ARUserGenderMale
} ARUserGender;

@interface ARCreateUserTVController () <UITextFieldDelegate, UIPopoverPresentationControllerDelegate, ARDatePickerControllerDelegate>
@property (strong, nonatomic) UIImage* femaleIcon;
@property (strong, nonatomic) UIImage* maleIcon;
@property (strong, nonatomic) UIImageView* userImage;

@property (strong, nonatomic) UITextField* firstNameField;
@property (strong, nonatomic) UITextField* lastNameField;
@property (strong, nonatomic) UITextField* emailField;
@property (strong, nonatomic) UITextField* dateField;
@property (strong, nonatomic) UISegmentedControl* genderControl;
@property (strong, nonatomic) NSArray* textFields;

@property (strong, nonatomic) NSArray* teachingCourses;
@property (strong, nonatomic) NSArray* learningCourses;

- (IBAction)actionCreate:(UIBarButtonItem *)sender;
- (IBAction)actionCancel:(UIBarButtonItem *)sender;
@end

@implementation ARCreateUserTVController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.managedObjectContext = [ARDataManager sharedManager].persistentContainer.viewContext;
    
    if (self.controllerType == ARUserControllerTypeCreate) {
        self.navigationItem.title = @"Create new user";
    } else {
        self.navigationItem.title = @"Edit user";
    }
    
    self.femaleIcon = [UIImage imageNamed:@"female.png"];
    self.maleIcon = [UIImage imageNamed:@"male.png"];
    
    self.teachingCourses = [self.editingUser.teachingCourses allObjects];
    self.learningCourses = [self.editingUser.learningCourses allObjects];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.textFields = @[self.firstNameField, self.lastNameField, self.emailField];
    
}

#pragma mark - Actions -

- (void)actionChangeGender:(UISegmentedControl*)sender {
    
    self.userImage.image = sender.selectedSegmentIndex == ARUserGenderFemale ? self.femaleIcon : self.maleIcon;
    
}

- (void)actionShowDatePicker:(UITextField *)sender {
    [sender resignFirstResponder];
    
    ARDatePickerController* dateController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARDatePickerController"];
    dateController.date = self.editingUser.birthDate;
    dateController.delegate = self;
    
    dateController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:dateController
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController* popController = [dateController popoverPresentationController];
    popController.delegate = self;
    popController.sourceView = sender;
}

- (IBAction)actionCreate:(UIBarButtonItem *)sender {
    
    if (!self.editingUser) {
        self.editingUser = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ARUser class])
                                                         inManagedObjectContext:self.managedObjectContext];
    }
    
    self.editingUser.firstName = self.firstNameField.text;
    self.editingUser.lastName = self.lastNameField.text;
    self.editingUser.gender = self.genderControl.selectedSegmentIndex;
    self.editingUser.birthDate = [self convertStringToDate:self.dateField.text];
    self.editingUser.email = self.emailField.text;
    
    __block NSError* error = nil;
    if (![self.managedObjectContext save:&error]) {
        
        NSArray* detailedErrors = [error.userInfo objectForKey:@"NSDetailedErrors"];
        NSString* domains = @"";
        
        for (NSError* detailedError in detailedErrors) {
            
            domains = [domains stringByAppendingFormat:@"%@ \n", detailedError.domain];
            
        }
        
        NSLog(@"errors occured = %@", domains);
        
        // [self showErrorAlert:domains];
        UIAlertController* errorSavingAlert = [UIAlertController alertControllerWithTitle:@"Error creating new user"
                                                                                  message:domains
                                                                           preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             // error.userInfo = nil; - readonly
                                                         }];
        
        [errorSavingAlert addAction:actionOK];
        [self presentViewController:errorSavingAlert animated:YES completion:nil];
        
    } else {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (IBAction)actionCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.controllerType == ARUserControllerTypeCreate) {
        return 1;
    } else {
        return 1 + ([self.teachingCourses count] > 0) + ([self.learningCourses count] > 0);
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section; {
    
    if (section == 0) {
        return @"User";
    } else if (section == 1 && [self.teachingCourses count] > 0) {
        return @"Teaching courses";
    } else {
        return @"Learning courses";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 6;
    } else if (section == 1 && [self.teachingCourses count] > 0) {
        return [self.teachingCourses count];
    } else {
        return [self.learningCourses count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* pictureId = @"picture";
    static NSString* attributeId = @"attribute";
    static NSString* courseId = @"course";
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            ARPictureCell* cell = [tableView dequeueReusableCellWithIdentifier:pictureId];
            cell.pictureView.image = self.editingUser.gender == ARUserGenderMale ? self.maleIcon : self.femaleIcon;
            self.userImage = cell.pictureView;
            
            return cell;
        } else {
            ARAttributeCell* cell = [tableView dequeueReusableCellWithIdentifier:attributeId];
            cell.attributeField.delegate = self;
            
            switch (indexPath.row) {
                case 1:
                    cell.attributeLabel.text = @"First Name";
                    cell.attributeField.placeholder = @"first name";
                    cell.attributeField.text = self.editingUser.firstName;
                    cell.attributeField.returnKeyType = UIReturnKeyNext;
                    self.firstNameField = cell.attributeField;
                    break;
                    
                case 2:
                    cell.attributeLabel.text = @"Last Name";
                    cell.attributeField.placeholder = @"last name";
                    cell.attributeField.text = self.editingUser.lastName;
                    cell.attributeField.returnKeyType = UIReturnKeyNext;
                    self.lastNameField = cell.attributeField;
                    break;
                    
                case 3:
                    cell.attributeLabel.text = @"Gender";
                    break;
                    
                case 4:
                    cell.attributeLabel.text = @"Date of birth";
                    cell.attributeField.placeholder = @"date of birth";
                    cell.attributeField.text = [self convertDateToString:self.editingUser.birthDate];
                    [cell.attributeField addTarget:self
                                            action:@selector(actionShowDatePicker:)
                                  forControlEvents:UIControlEventEditingDidBegin];
                    self.dateField = cell.attributeField;
                    break;
                    
                case 5:
                    cell.attributeLabel.text = @"E-mail";
                    cell.attributeField.placeholder = @"e-mail";
                    cell.attributeField.text = self.editingUser.email;
                    cell.attributeField.returnKeyType = UIReturnKeyDone;
                    self.emailField = cell.attributeField;
                    break;
                    
                default:
                    break;
            }
            
            if (indexPath.row == 3) {
                UISegmentedControl* genderControl = [[UISegmentedControl alloc] initWithItems:@[@"Female", @"Male"]];
                genderControl.selectedSegmentIndex = self.editingUser.gender == ARUserGenderMale ? ARUserGenderMale : ARUserGenderFemale;
                [genderControl addTarget:self
                                  action:@selector(actionChangeGender:)
                        forControlEvents:UIControlEventValueChanged];
                [self replaceView:cell.attributeField withView:genderControl inSuperview:cell.contentView];
                self.genderControl = genderControl;
            }
            
            return cell;
        }
        
    } else {
        ARItemCell* cell = [tableView dequeueReusableCellWithIdentifier:courseId];
        ARCourse* course = nil;
        
        if (indexPath.section == 1 && [self.teachingCourses count] > 0) {
            course = [self.teachingCourses objectAtIndex:indexPath.row];
        } else {
            course = [self.learningCourses objectAtIndex:indexPath.row];
        }
        
        cell.nameLabel.text = course.courseName;
        cell.detailLabel.text = course.branch;
        
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) return 170;
    
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    NSInteger index = [self.textFields indexOfObject:textField];

    if (index == [self.textFields count] - 1) {
        [textField resignFirstResponder];
    } else {
        [[self.textFields objectAtIndex:index + 1] becomeFirstResponder];
    }
    
    return YES;
}

#pragma mark - ARDatePickerControllerDelegate -

- (void)dateControllerSendsUpdates:(ARDatePickerController*)datePickerController {
    
    self.dateField.text = [self convertDateToString:datePickerController.date];
}

#pragma mark - Additional methods -

-(void) replaceView:(UIView*)oldSubView withView:(UIView*)newSubView inSuperview:(UIView*)superview {
    newSubView.frame = oldSubView.frame;
    
    [oldSubView removeFromSuperview];
    [superview addSubview:newSubView];
}

- (NSString*)convertDateToString:(NSDate*)date {
    if (!date) return nil;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (NSDate*)convertStringToDate:(NSString*)string {
    if (!string) return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return [dateFormatter dateFromString:string];
}

/*
- (void)showErrorAlert:(NSString*)message {
    UIAlertController* errorSavingAlert = [UIAlertController alertControllerWithTitle:@"Error creating new user"
                                                                              message:message
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:nil];
    
    [errorSavingAlert addAction:actionOK];
    [self presentViewController:errorSavingAlert animated:YES completion:nil];
}
 */


@end
