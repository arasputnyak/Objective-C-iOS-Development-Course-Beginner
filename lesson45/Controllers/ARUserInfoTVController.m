//
//  ARUserInfoTVController.m
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 28.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUserInfoTVController.h"
#import "ARServerManager.h"
#import "ARItemsListController.h"

@interface ARUserInfoTVController ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UITextView *userAboutTextView;

@end

@implementation ARUserInfoTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"User Info";
    [self getUserInfoFromServer];
}

#pragma mark - API -

- (void)getUserInfoFromServer {
    
    [[ARServerManager sharedManager] getUserInfoById:self.userId
                                           onSuccess:^(ARUser * _Nonnull user) {
                                               self.userNameLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
                                               self.userLocationLabel.text = [NSString stringWithFormat:@"%@, %@",
                                                                              user.country == nil ? @"/country/" : user.country,
                                                                              user.city == nil ? @"/city/" : user.city];
                                               self.userAboutTextView.text = user.status == nil ? @"/status/" : user.status;
                                               
                                               NSData *data = [NSData dataWithContentsOfURL:user.largeImageURL];
                                               UIImage *image = [UIImage imageWithData:data];
                                               self.userImageView.image = image;
                                               self.userImageView.layer.masksToBounds = YES;
                                               self.userImageView.layer.cornerRadius = 75.f;
                                           }
                                           onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                               NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                           }];
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 3 || indexPath.row == 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    
    if (indexPath.row == 3) {
        
        ARItemsListController* subscriptionsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARItemsListController"];
        subscriptionsController.controllerType = ARControllerTypeSubscriptions;
        subscriptionsController.userId = self.userId;
        [self.navigationController pushViewController:subscriptionsController
                                             animated:YES];
        
        
    } else if (indexPath.row == 4) {
        
        ARItemsListController* followersController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARItemsListController"];
        followersController.controllerType = ARControllerTypeFollowers;
        followersController.userId = self.userId;
        [self.navigationController pushViewController:followersController
                                             animated:YES];
    }
    
    
}


@end
