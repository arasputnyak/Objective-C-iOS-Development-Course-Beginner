//
//  ARFriendsListTVController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARFriendsListTVController.h"
#import "../ARServerManager.h"
#import "../Cells/ARFriendCell.h"
#import "ARMessageController.h"

@interface ARFriendsListTVController ()
@property (assign, nonatomic) NSInteger maxFriendsCount;
@property (strong, nonatomic) NSMutableArray* friends;
@property (assign, nonatomic) BOOL isLoading;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

static NSInteger limitCount = 10;

@implementation ARFriendsListTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView.hidden = YES;
    self.isLoading = NO;
    
    self.maxFriendsCount = -1;
    self.friends = [NSMutableArray array];
}

#pragma mark - API -

- (void)getFriendsFromServer {
    
    [[ARServerManager sharedManager] getUsersFriendsById:self.userId
                                              withOffset:[self.friends count]
                                                   count:limitCount
                                               onSuccess:^(NSInteger maxFriends, NSArray * _Nonnull friends) {
                                                   if (self.isLoading) {
                                                       self.isLoading = NO;
                                                       [self.loadingIndicator stopAnimating];
                                                       self.tableView.tableFooterView.hidden = YES;
                                                   }
                                                   
                                                   if (self.maxFriendsCount < 0) self.maxFriendsCount = maxFriends;
                                                   [self.friends addObjectsFromArray:friends];
                                                   [self.tableView reloadData];
                                               }
                                               onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                   NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                               }];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"friendCell";
    
    ARFriendCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    ARUser* friend = [self.friends objectAtIndex:indexPath.row];
    
    cell.userNameLabel.text = friend.name;
    
    NSData *data = [NSData dataWithContentsOfURL:friend.imageURL];
    cell.userImageView.image = [UIImage imageWithData:data];
    cell.userImageView.layer.masksToBounds = YES;
    cell.userImageView.layer.cornerRadius = CGRectGetWidth(cell.userImageView.frame) / 2;
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
    
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    
    ARMessageController* messageController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARMessageController"];
    messageController.user = [self.friends objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:messageController
                                         animated:YES];
    
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // runs first time without scrolling!..
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat maxOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maxOffset - offset < 0 && self.userId && [self.friends count] < self.maxFriendsCount) {
        [self loadMore];
    }
}

#pragma mark - Additional methods -

- (void)loadMore {
    if (!self.isLoading) {
        self.isLoading = YES;
        [self.loadingIndicator startAnimating];
        self.tableView.tableFooterView.hidden = NO;
        [self getFriendsFromServer];
    }
}


@end
