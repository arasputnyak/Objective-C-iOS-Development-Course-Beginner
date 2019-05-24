//
//  ARBranchesController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 23.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARBranchesController.h"

@interface ARBranchesController ()
@property (strong, nonatomic) NSIndexPath* chosenIndex;
@end

@implementation ARBranchesController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSInteger index = [self.branches indexOfObject:self.chosenBranch];
    self.chosenIndex = [NSIndexPath indexPathForRow:index
                                          inSection:0];
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:self.chosenIndex];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

#pragma mark - Actions -

- (void)actionDone:(UIBarButtonItem *)sender {
    
    [self.delegate updateBranch:self];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Branch";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.branches count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"branch";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
    }
    cell.textLabel.text = [self.branches objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.chosenIndex) {
        UITableViewCell* lastCell = [tableView cellForRowAtIndexPath:self.chosenIndex];
        lastCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];
    currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.chosenBranch = currentCell.textLabel.text;
    self.chosenIndex = indexPath;
    
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//    [headerView setBackgroundColor:[UIColor colorWithRed:247/255.0f green:247/255.0f blue:247/255.0f alpha:1.0f]];
//    return headerView;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


@end
