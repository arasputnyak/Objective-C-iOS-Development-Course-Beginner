//
//  ViewController.m
//  Lesson31Task
//
//  Created by Анастасия Распутняк on 20.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"
#import "ARStudent.h"
#import "ARGroup.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* studentGroups;

@end

@implementation ViewController

static int numberOfGroups = 5;

- (void)loadView {
    
    [super loadView];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.studentGroups = [NSMutableArray array];
    
    for (int i = 0; i < numberOfGroups; i++) {
        NSInteger numberOfStudents = arc4random() % 5 + 4;
        
        ARGroup* group = [[ARGroup alloc] init];
        group.groupName = [NSString stringWithFormat:@"Group #%d", i + 1];
        NSMutableArray* students = [NSMutableArray array];
        
        for (int j = 0; j < numberOfStudents; j++) {
            [students addObject:[ARStudent randomStudent]];
        }
        
        group.groupMembers = students;
        [self.studentGroups addObject:group];
    }
    
    [self.tableView reloadData];
    
    self.navigationItem.title = @"Students";
    
    UIBarButtonItem* editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                               target:self
                                                                               action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    UIBarButtonItem* addSectionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                      target:self
                                                                                      action:@selector(actionAddSection:)];
    self.navigationItem.leftBarButtonItem = addSectionButton;
    
}

#pragma mark - Actions -

- (void)actionEdit:(UIBarButtonItem*)sender {
    
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    
    UIBarButtonSystemItem systemItem = UIBarButtonSystemItemEdit;
    
    if (self.tableView.editing) {
        systemItem = UIBarButtonSystemItemDone;
    }
    
    UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:systemItem
                                                                                target:self
                                                                                action:@selector(actionEdit:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)actionAddSection:(UIBarButtonItem*)sender {
    NSInteger newSectionIndex = [self.studentGroups count];
    ARGroup* newGroup = [[ARGroup alloc] init];
    newGroup.groupName = [NSString stringWithFormat:@"Group #%lu", [self.studentGroups count] + 1];
    
    NSMutableArray* newStudents = [NSMutableArray array];
    for (int i = 0; i < arc4random() % 5 + 4; i++) {
        [newStudents addObject:[ARStudent randomStudent]];
    }
    
    newGroup.groupMembers = newStudents;
    [self.studentGroups addObject:newGroup];
    
    [self.tableView beginUpdates];
    
    NSIndexSet* insertionIndex = [NSIndexSet indexSetWithIndex:newSectionIndex];
    [self.tableView insertSections:insertionIndex withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView endUpdates];
    
    [self ignoreEvents];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.studentGroups count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ARGroup* group = [self.studentGroups objectAtIndex:section];
    return [group groupName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ARGroup* group = [self.studentGroups objectAtIndex:section];
    return [group.groupMembers count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        static NSString* addCellIdentifier = @"addCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addCellIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCellIdentifier];
        }
        
        cell.textLabel.text = @"Add new student";
        cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:19];
        cell.textLabel.textColor = [UIColor colorWithRed:10 / 255.f green:132 / 255.f blue:255 / 255.f alpha:1.f];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
        
    } else {
        static NSString* studentIdentifier = @"studentCell";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:studentIdentifier];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:studentIdentifier];
        }
            
        ARGroup* group = [self.studentGroups objectAtIndex:indexPath.section];
        ARStudent* student = [group.groupMembers objectAtIndex:indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", student.averageMark];
        
        UIColor* markColor = [UIColor redColor];
        if (student.averageMark >= 4.f && student.averageMark <= 5.f) {
            markColor = [UIColor greenColor];
        } else if (student.averageMark >= 3.f && student.averageMark < 4.f) {
            markColor = [UIColor orangeColor];
        }
        
        cell.detailTextLabel.textColor = markColor;
        cell.textLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:18];
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 0;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    ARGroup* group = [self.studentGroups objectAtIndex:sourceIndexPath.section];
    ARStudent* student = [group.groupMembers objectAtIndex:sourceIndexPath.row - 1];
    NSMutableArray* students = [group.groupMembers mutableCopy];
    
    if (sourceIndexPath.section != destinationIndexPath.section) {
        
        ARGroup* newGroup = [self.studentGroups objectAtIndex:destinationIndexPath.section];
        NSMutableArray* newStudents = [newGroup.groupMembers mutableCopy];
        
        [students removeObject:student];
        
        if (destinationIndexPath.row > [newStudents count]) {
            [newStudents addObject:student];
        } else {
            [newStudents insertObject:student atIndex:destinationIndexPath.row - 1];
        }

        group.groupMembers = students;
        newGroup.groupMembers = newStudents;
    } else {
        [students insertObject:student atIndex:destinationIndexPath.row - 1];
        group.groupMembers = students;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ARGroup* group = [self.studentGroups objectAtIndex:indexPath.section];
        NSMutableArray* students = [group.groupMembers mutableCopy];
        [students removeObjectAtIndex:indexPath.row - 1];
        group.groupMembers = students;
        
        [tableView beginUpdates];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        
        [tableView endUpdates];
        [self ignoreEvents];
    
    }
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 0;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCellEditingStyle cellEditingStyle = indexPath.row == 0 ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
    return cellEditingStyle;
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    if (proposedDestinationIndexPath.row == 0) {
        return sourceIndexPath;
    } else {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        ARGroup* group = [self.studentGroups objectAtIndex:indexPath.section];
        
        NSMutableArray* students = nil;
        if (group.groupMembers) {
            students = [group.groupMembers mutableCopy];
        } else {
            students = [NSMutableArray array];
        }
        
        NSInteger newSectionIndex = 0;
        [students insertObject:[ARStudent randomStudent] atIndex:newSectionIndex];
        group.groupMembers = students;
        
        [tableView beginUpdates];
        
        NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newSectionIndex + 1 inSection:indexPath.section];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        
        [self.tableView endUpdates];
        [self ignoreEvents];
        
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

#pragma mark - Additional methods -

- (void)ignoreEvents {
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    });
}


@end
