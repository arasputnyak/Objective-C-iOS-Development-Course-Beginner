//
//  ARItemsListController.m
//  Lesson45Task
//
//  Created by Анастасия Распутняк on 29.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARItemsListController.h"
#import "ARUserInfoTVController.h"
#import "ARServerManager.h"
#import "ARItemCell.h"
#import "ARUser.h"
#import "ARCommunity.h"

@interface ARItemsListController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (strong, nonatomic) NSMutableArray* itemsToShow;
@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@end

static NSInteger limitCount = 5;

@implementation ARItemsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView.hidden = YES;
    self.isLoading = false;
    
    self.itemsToShow = [NSMutableArray array];
    
    if (self.controllerType == ARControllerTypeFriends) {
        [self getFriendsFromServer];
    } else if (self.controllerType == ARControllerTypeFollowers) {
        self.navigationItem.title = @"Followers";
        [self getFollowersFromServer];
    } else {
        self.navigationItem.title = @"Subscriptions";
        [self getSubscriptionsFromServer];
    }
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing.."];
    [self.refreshControl addTarget:self
                            action:@selector(actionRefresh:)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

#pragma mark - Actions -

- (void)actionRefresh:(UIRefreshControl*)sender {
    
    [sender beginRefreshing];
    [self.itemsToShow removeAllObjects];
    
    if (self.controllerType == ARControllerTypeFriends) {
        [self getFriendsFromServer];
    } else if (self.controllerType == ARControllerTypeFollowers) {
        [self getFollowersFromServer];
    } else {
        [self getSubscriptionsFromServer];
    }
    
    [self.tableView reloadData];
    [sender endRefreshing];
}

#pragma mark - API -

- (void)getFriendsFromServer {
    
    [[ARServerManager sharedManager] getFriendsWithOffset:[self.itemsToShow count]
                                                    count:limitCount
                                                onSuccess:^(NSArray * _Nonnull friends) {
                                                    [self successMethod:friends];
                                                }
                                                onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                    NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                }];
}

- (void)getFollowersFromServer {
    
    [[ARServerManager sharedManager] getUserFollowersById:self.userId
                                               withOffset:[self.itemsToShow count]
                                                 andCount:limitCount
                                                onSuccess:^(NSArray * _Nonnull followers) {
                                                    [self successMethod:followers];
                                                }
                                                onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                    NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                }];
}

- (void)getSubscriptionsFromServer {
    
    [[ARServerManager sharedManager] getUserSubscriptionsById:self.userId
                                                   withOffset:[self.itemsToShow count]
                                                     andCount:limitCount
                                                    onSuccess:^(NSArray * _Nonnull subscriptions) {
                                                        [self successMethod:subscriptions];
                                                    }
                                                    onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                        NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                    }];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.itemsToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"item";
    
    ARItemCell* cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    NSObject* item = [self.itemsToShow objectAtIndex:indexPath.row];
    UIImage* image = nil;
    if ([item isKindOfClass:[ARUser class]]) {
        
        ARUser* friend = (ARUser*)item;
        cell.itemNameLabel.text = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        NSData *data = [NSData dataWithContentsOfURL:friend.imageURL];
        image = [UIImage imageWithData:data];
        cell.onlineView.backgroundColor = friend.online ? [UIColor greenColor] : [UIColor clearColor];
        
    } else if ([item isKindOfClass:[ARCommunity class]]) {
        
        ARCommunity* community = (ARCommunity*)item;
        cell.itemNameLabel.text = community.name;
        NSData *data = [NSData dataWithContentsOfURL:community.imageURL];
        image = [UIImage imageWithData:data];
        cell.onlineView.backgroundColor = [UIColor clearColor];
        
    }
    
    cell.itemImageView.image = image;
    cell.itemImageView.layer.masksToBounds = YES;
    cell.itemImageView.layer.cornerRadius = 25.f;
    cell.onlineView.layer.masksToBounds = YES;
    cell.onlineView.layer.cornerRadius = 5.f;
    
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
    
    NSObject* item = [self.itemsToShow objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[ARUser class]]) {
        ARUser* currentUser = (ARUser*)item;
        
        ARUserInfoTVController* infoController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARUserInfoTVController"];
        infoController.userId = currentUser.userId;
        [self.navigationController pushViewController:infoController
                                             animated:YES];
        
    }
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat maxOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maxOffset - offset < 0) {
        [self loadMore];
    }
}

#pragma mark - Additional methods -

- (void)loadMore {
    if (!self.isLoading) {
        self.isLoading = YES;
        [self.loadingIndicator startAnimating];
        self.tableView.tableFooterView.hidden = NO;
        
        if (self.controllerType == ARControllerTypeFriends) {
            [self getFriendsFromServer];
        } else if (self.controllerType == ARControllerTypeFollowers) {
            [self getFollowersFromServer];
        } else {
            [self getSubscriptionsFromServer];
        }
        
    }
}

- (void)successMethod:(NSArray*)items {
    if (self.isLoading) {
        self.isLoading = NO;
        [self.loadingIndicator stopAnimating];
    }
    
    [self.itemsToShow addObjectsFromArray:items];
    [self.tableView reloadData];
}


@end
