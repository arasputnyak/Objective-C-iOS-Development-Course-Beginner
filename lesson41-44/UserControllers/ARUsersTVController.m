//
//  ARUsersTVController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 16.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUsersTVController.h"
#import "ARCreateUserTVController.h"
#import "../Models/ARUser+CoreDataClass.h"

@interface ARUsersTVController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UIPopoverPresentationControllerDelegate>
- (IBAction)actionAddUser:(UIBarButtonItem *)sender;
@end

@implementation ARUsersTVController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions -

- (IBAction)actionAddUser:(UIBarButtonItem *)sender {
    
    [self presentPopoverWithType:ARUserControllerTypeCreate
                         andUser:nil
                        bySender:sender];
}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    ARUser *user = (ARUser*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self presentPopoverWithType:ARUserControllerTypeEdit
                         andUser:user
                        bySender:nil];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

#pragma mark - Fetched results controller

@synthesize fetchedResultsController = _fetchedResultsController;

- (NSFetchedResultsController<ARObject *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    
    NSFetchRequest<ARUser *> *fetchRequest = ARUser.fetchRequest;
    
    [fetchRequest setFetchBatchSize:10];
    
    NSSortDescriptor* lastNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName"
                                                                       ascending:YES];
    NSSortDescriptor* firstNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                                                        ascending:YES];
    
    [fetchRequest setSortDescriptors:@[lastNameDescriptor, firstNameDescriptor]];
    
    NSFetchedResultsController<ARObject*>* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                         managedObjectContext:self.managedObjectContext
                                                                                                           sectionNameKeyPath:nil
                                                                                                                    cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    NSLog(@"count.users = %lu", [_fetchedResultsController.fetchedObjects count]);
    return _fetchedResultsController;
}

#pragma mark - Additional methods -

- (void)configureCell:(UITableViewCell *)cell withObject:(nonnull ARObject *)object {
    ARUser* user = (ARUser*)object;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
}

- (void)presentPopoverWithType:(ARUserControllerType)type andUser:(ARUser*)user bySender:(UIBarButtonItem*)sender {
    
    UINavigationController* createNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateUserNavigController"];
    ARCreateUserTVController* createController = (ARCreateUserTVController*)createNavigationController.topViewController;
    createController.controllerType = type;
    createController.editingUser = user;
    
    createNavigationController.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:createNavigationController
                       animated:YES
                     completion:nil];
    
    UIPopoverPresentationController* popController = [createNavigationController popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    popController.barButtonItem = sender;
    popController.delegate = self;
}


@end
