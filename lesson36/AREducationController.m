//
//  AREducationController.m
//  Lesson36Task
//
//  Created by Анастасия Распутняк on 29.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "AREducationController.h"

typedef enum {
    AREducationTypeBasic,
    AREducationTypeSecondary,
    AREducationTypeSpecialist,
    AREducationTypeBachelor,
    AREducationTypeMaster
} AREducationType;

@interface AREducationController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *basicLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialistLabel;
@property (weak, nonatomic) IBOutlet UILabel *bachelorLabel;
@property (weak, nonatomic) IBOutlet UILabel *masterLabel;

- (IBAction)actionDone:(UIBarButtonItem *)sender;
@end

@implementation AREducationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.preferredContentSize = CGSizeMake(340, 250);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.chosenEducation];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.chosenEducation) {
        UITableViewCell* lastCell = [tableView cellForRowAtIndexPath:self.chosenEducation];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];
    switch (currentCell.tag) {
        case AREducationTypeBasic:
            self.educationType = self.basicLabel.text;
            break;
            
        case AREducationTypeSecondary:
            self.educationType = self.secondaryLabel.text;
            break;
            
        case AREducationTypeSpecialist:
            self.educationType = self.specialistLabel.text;
            break;
            
        case AREducationTypeBachelor:
            self.educationType = self.bachelorLabel.text;
            break;
            
        case AREducationTypeMaster:
            self.educationType = self.masterLabel.text;
            break;
            
        default:
            break;
    }
    
    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.chosenEducation = indexPath;
    [self.delegate updateEducation:self];

}

#pragma mark - Actions -

- (IBAction)actionDone:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
