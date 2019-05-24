//
//  ARUsersListTVController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 23.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUsersListTVController.h"
#import "../Models/ARUser+CoreDataClass.h"

@interface ARUsersListTVController ()
@property (strong, nonatomic) NSMutableArray* chosenIndexes;
@end

@implementation ARUsersListTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(actionDone:)];
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.chosenUsers) {
        for (ARUser* user in self.chosenUsers) {
            NSIndexPath* userIndexPath = [self.fetchedResultsController indexPathForObject:user];
            
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:userIndexPath];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            self.chosenIndexes = [NSMutableArray array];
            [self.chosenIndexes addObject:userIndexPath];
        }
    } else {
        self.chosenUsers = [NSMutableArray array];
        self.chosenIndexes = [NSMutableArray array];
    }
}

#pragma mark - Actions -

- (void)actionDone:(UIBarButtonItem*)sender {
    
    NSLog(@"done");
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate updateUsers:self];
    
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.controllerType == ARListControllerTypeSingle) {
        if ([self.chosenIndexes count] > 0) {
            NSLog(@"last chosen unchecked");
            NSIndexPath* lastIndexPath = [self.chosenIndexes firstObject];
            UITableViewCell* lastCell = [tableView cellForRowAtIndexPath:lastIndexPath];
            lastCell.accessoryType = UITableViewCellAccessoryNone;
            
            [self.chosenUsers removeObject:[self.fetchedResultsController objectAtIndexPath:lastIndexPath]];
            [self.chosenIndexes removeObject:lastIndexPath];
            
            if ([lastIndexPath isEqual:indexPath]) return;
        }
    }
    
    UITableViewCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];
    if (currentCell.accessoryType == UITableViewCellAccessoryNone) {
        
        currentCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.chosenUsers addObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.chosenIndexes addObject:indexPath];
        
    } else {
        
        currentCell.accessoryType = UITableViewCellAccessoryNone;
        [self.chosenUsers removeObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        [self.chosenIndexes removeObject:indexPath];
    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

#pragma mark - Additional methods -

- (void)configureCell:(UITableViewCell *)cell withObject:(nonnull ARObject *)object {
    
    ARUser* user = (ARUser*)object;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
}


@end
