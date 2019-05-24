//
//  ARCreateCourseTVController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 22.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARCreateCourseTVController.h"
#import "ARBranchesController.h"
#import "../ARDataManager.h"
#import "../Cells/ARAttributeCell.h"
#import "../Cells/ARPictureCell.h"
#import "../Cells/ARItemCell.h"
#import "../Models/ARUser+CoreDataClass.h"
#import "../UserControllers/ARUsersListTVController.h"

typedef enum {
    ARBranchTypeProgramming,
    ARBranchTypeArchitecture,
    ARBranchTypeMedicine,
    ARBranchTypePsychology,
    ARBranchTypeChemistry
} ARBranchType;

@interface ARCreateCourseTVController () <UITextFieldDelegate, UIPopoverPresentationControllerDelegate,
                                          ARBranchesControllerDelegate, ARUsersListTVControllerDelegate>

@property (strong, nonatomic) UIImageView* courseIcon;

@property (strong, nonatomic) UITextField* nameField;

@property (strong, nonatomic) NSArray* branches;
@property (strong, nonatomic) UILabel* branchLabel;

@property (strong, nonatomic) ARUser* teacher;
@property (strong, nonatomic) UILabel* teacherLabel;

@property (strong, nonatomic) NSArray* students;


- (IBAction)actionCreate:(UIBarButtonItem *)sender;
- (IBAction)actionCancel:(UIBarButtonItem *)sender;
@end

@implementation ARCreateCourseTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.managedObjectContext = [ARDataManager sharedManager].persistentContainer.viewContext;
    
    self.branches = @[@"Programming", @"Architecture", @"Medicine", @"Psychology", @"Chemistry"];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.controllerType == ARCourseControllerTypeCreate) {
        self.navigationItem.title = @"Create new course";
        if (!self.branchLabel) {
            self.branchLabel = [[UILabel alloc] init];
            self.branchLabel.text = [self.branches objectAtIndex:0];  // default
        }
    } else {
        self.navigationItem.title = @"Edit course";
        if (!self.teacher && !self.students) {
            self.teacher = self.editingCourse.teacher;
            self.students = [self.editingCourse.students allObjects];
            
            self.branchLabel = [[UILabel alloc] init];
            self.branchLabel.text = self.editingCourse.branch;
        }
    }
}

#pragma mark - Actions -

- (IBAction)actionCreate:(UIBarButtonItem *)sender {
    
    if (!self.editingCourse) {
        self.editingCourse = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([ARCourse class])
                                                         inManagedObjectContext:self.managedObjectContext];
    }
    
    self.editingCourse.courseName = self.nameField.text;
    self.editingCourse.branch = self.branchLabel.text;
    self.editingCourse.teacher = self.teacher;
    self.editingCourse.students = [NSSet setWithArray:self.students];
    
    __block NSError* error = nil;
    if (![self.managedObjectContext save:&error]) {
        
        NSArray* detailedErrors = [error.userInfo objectForKey:@"NSDetailedErrors"];
        NSString* domains = @"";
        
        for (NSError* detailedError in detailedErrors) {
            
            domains = [domains stringByAppendingFormat:@"%@ \n", detailedError.domain];
            
        }
        
        NSLog(@"errors occured = %@", domains);
        
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
    
    return 2;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section; {
    
    if (section == 0) {
        return @"Course";
    } else {
        return @"Students";
    }
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    
    if (section == 1) return @" ";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    } else {
        NSInteger rows = [self.students count] + 1;
        NSLog(@"rows = %ld", (long)rows);
        return [self.students count] + 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* pictureId = @"picture";
    static NSString* attributeId = @"attribute";
    static NSString* studentId = @"student";
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            ARPictureCell* cell = [tableView dequeueReusableCellWithIdentifier:pictureId forIndexPath:indexPath];
            self.courseIcon = cell.pictureView;
            [self changeCourseIcon:self.courseIcon];
            return cell;
            
        } else if (indexPath.row == 1) {
            
            ARAttributeCell* cell = [tableView dequeueReusableCellWithIdentifier:attributeId forIndexPath:indexPath];
            cell.attributeLabel.text = @"Course Name";
            cell.attributeField.placeholder = @"course name";
            cell.attributeField.text = self.editingCourse.courseName;
            cell.attributeField.returnKeyType = UIReturnKeyDone;
            cell.attributeField.delegate = self;
            self.nameField = cell.attributeField;
            
            return cell;
        } else {
            
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"pickId"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:@"pickId"];
            }
            
            if (indexPath.row == 2) {
                cell.textLabel.text = @"Branch";
                cell.detailTextLabel.text = self.editingCourse ? self.editingCourse.branch : self.branchLabel.text;
                self.branchLabel = cell.detailTextLabel;
        
            } else {
                cell.textLabel.text = @"Teacher";
                cell.detailTextLabel.text = self.teacher ? [NSString stringWithFormat:@"%@ %@", self.teacher.firstName, self.teacher.lastName] : nil;
                self.teacherLabel = cell.detailTextLabel;
            }
            
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        
    } else {
        
        if (indexPath.row == 0) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"button"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"button"];
            }
            cell.textLabel.text = @"Add students";
            cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:19];
            cell.textLabel.textColor = [UIColor colorWithRed:10 / 255.f green:132 / 255.f blue:255 / 255.f alpha:1.f];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            
            return cell;
        } else {
            ARItemCell* cell = [tableView dequeueReusableCellWithIdentifier:studentId forIndexPath:indexPath];
            ARUser* student = [self.students objectAtIndex:indexPath.row - 1];
            
            cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
            cell.detailLabel.text = [self convertDateToString:student.birthDate];
            
            return cell;
        }
    }
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return !(indexPath.section == 0 && indexPath.row < 2);
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            
            ARBranchesController* branchController = [[ARBranchesController alloc] init];
            branchController.branches = self.branches;
            branchController.delegate = self;
            branchController.chosenBranch = self.branchLabel.text;
            UINavigationController* branchNavigController = [[UINavigationController alloc] initWithRootViewController:branchController];
            
            branchNavigController.modalPresentationStyle = UIModalPresentationPopover;
            [self presentViewController:branchNavigController
                               animated:YES
                             completion:nil];
            
            UIPopoverPresentationController* popController = [branchNavigController popoverPresentationController];
            popController.delegate = self;
            popController.sourceView = self.branchLabel;
            
        } else if (indexPath.row == 3) {
            [self ignoreEvents];
            [self pushControllerWithType:ARListControllerTypeSingle];
        }
    } else {
        if (indexPath.row == 0) {
            [self ignoreEvents];
            [self pushControllerWithType:ARListControllerTypeMultiple];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) return 170;
    if (indexPath.section > 0 && indexPath.row == 0) return 44;
    
    return 60;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - ARBranchesControllerDelegate -

- (void)updateBranch:(ARBranchesController*)branchController {
    
    self.branchLabel.text = branchController.chosenBranch;
    [self changeCourseIcon:self.courseIcon];
    
}

#pragma mark - ARUsersListTVControllerDelegate -

- (void)updateUsers:(ARUsersListTVController*)listController {
    if (listController.controllerType == ARListControllerTypeSingle) {
        
        if ([listController.chosenUsers count] > 0) {
            
            ARUser* teacher = [listController.chosenUsers firstObject];
            self.teacherLabel.text = [NSString stringWithFormat:@"%@ %@", teacher.firstName, teacher.lastName];
            self.teacher = teacher;
            
        } else {
            self.teacherLabel.text = nil;
            self.teacher = nil;
        }
        
    } else {
        
        self.students = listController.chosenUsers;
        [self.tableView reloadData];
    }
    
}

#pragma mark - Additional methods -

- (NSString*)convertDateToString:(NSDate*)date {
    if (!date) return nil;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    return [dateFormatter stringFromDate:date];
}

- (void)pushControllerWithType:(ARListControllerType)type {
    
    ARUsersListTVController* usersListController = [[ARUsersListTVController alloc] init];
    usersListController.controllerType = type;
    
    if (type == ARListControllerTypeSingle) {
        if (self.teacher) usersListController.chosenUsers = [NSMutableArray arrayWithObject:self.teacher];
    } else {
        if (self.students) usersListController.chosenUsers = [self.students mutableCopy];
    }
    
    usersListController.delegate = self;
    [self.navigationController pushViewController:usersListController
                                         animated:YES];
}

- (void)changeCourseIcon:(UIImageView*)iconView {
    if (!self.courseIcon) {
        self.courseIcon = [[UIImageView alloc] init];
    }
    
    switch ([self.branches indexOfObject:self.branchLabel.text]) {
        case ARBranchTypeProgramming:
            iconView.image = [UIImage imageNamed:@"prog.jpg"];
            break;
            
        case ARBranchTypeArchitecture:
            iconView.image = [UIImage imageNamed:@"arch.png"];
            break;
            
        case ARBranchTypeMedicine:
            iconView.image = [UIImage imageNamed:@"med.png"];
            break;
            
        case ARBranchTypePsychology:
            iconView.image = [UIImage imageNamed:@"psycho.png"];
            break;
            
        case ARBranchTypeChemistry:
            iconView.image = [UIImage imageNamed:@"chem.png"];
            break;
            
        default:
            break;
    }
}

- (void)ignoreEvents {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}

@end
