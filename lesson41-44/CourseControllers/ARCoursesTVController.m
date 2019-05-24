//
//  ARCoursesTVController.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 18.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARCoursesTVController.h"
#import "ARCreateCourseTVController.h"
#import "../Models/ARCourse+CoreDataClass.h"

@interface ARCoursesTVController () <UIPopoverPresentationControllerDelegate>
- (IBAction)actionAddCourse:(UIBarButtonItem *)sender;
@end

@implementation ARCoursesTVController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

#pragma mark - Actions -

- (IBAction)actionAddCourse:(UIBarButtonItem *)sender {
    
    [self presentPopoverWithType:ARCourseControllerTypeCreate
                       andCourse:nil
                        bySender:sender];

}

#pragma mark - UITableViewDelegate -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    ARCourse *course = (ARCourse*)[self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self presentPopoverWithType:ARCourseControllerTypeEdit
                         andCourse:course
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
    
    NSFetchRequest<ARCourse *> *fetchRequest = ARCourse.fetchRequest;
    
    [fetchRequest setFetchBatchSize:10];
    
    NSSortDescriptor* branchDescriptor = [[NSSortDescriptor alloc] initWithKey:@"branch"
                                                                     ascending:YES];
    NSSortDescriptor* courseNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"courseName"
                                                                         ascending:YES];
    
    [fetchRequest setSortDescriptors:@[branchDescriptor, courseNameDescriptor]];
    
    NSFetchedResultsController<ARObject*>* aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                           managedObjectContext:self.managedObjectContext
                                                                                                             sectionNameKeyPath:@"branch"
                                                                                                                      cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    NSLog(@"count.courses = %lu", [_fetchedResultsController.fetchedObjects count]);
    return _fetchedResultsController;
}

#pragma mark - Additional methods -

- (void)configureCell:(UITableViewCell *)cell withObject:(nonnull ARObject *)object {
    ARCourse* course = (ARCourse*)object;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = course.courseName;
}

- (void)presentPopoverWithType:(ARCourseControllerType)type andCourse:(ARCourse*)course bySender:(UIBarButtonItem*)sender{
    UINavigationController* createNavigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateCourseNavigController"];
    ARCreateCourseTVController* createController = (ARCreateCourseTVController*)createNavigationController.topViewController;
    createController.controllerType = type;
    createController.editingCourse = course;
    
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
