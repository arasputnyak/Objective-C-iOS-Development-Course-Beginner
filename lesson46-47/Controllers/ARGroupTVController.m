//
//  ARGroupTVController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARGroupTVController.h"
#import "../ARUtils.h"
#import "ARFriendsListTVController.h"
#import "ARCommentsTVController.h"
#import "ARVideosListTVController.h"
#import "../ARServerManager.h"
#import "../Cells/ARHeaderCell.h"
#import "../Cells/ARPostCell.h"
#import "../Cells/ARPostInfoCell.h"
#import "../Models/ARGroup.h"

@interface ARGroupTVController ()
@property (strong, nonatomic) ARGroup* currentGroup;
@property (assign, nonatomic) NSInteger maxPostsCount;
@property (strong, nonatomic) NSMutableArray* posts;
@property (assign, nonatomic) BOOL isLoading;
@property (weak, nonatomic) UIView* viewForLoading;
@property (weak, nonatomic) UIActivityIndicatorView* loadingTableIndicator;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

static NSInteger groupId = -58860049;
static NSInteger limitCount = 10;

@implementation ARGroupTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* viewForLoading = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:viewForLoading];
    self.viewForLoading = viewForLoading;
    
    UIActivityIndicatorView* loadingTableIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.viewForLoading addSubview:loadingTableIndicator];
    self.loadingTableIndicator = loadingTableIndicator;
    self.loadingTableIndicator.center = self.view.center;
    self.loadingTableIndicator.hidesWhenStopped = YES;
    self.loadingTableIndicator.color = MAIN_APP_COLOR;
    [self.loadingTableIndicator startAnimating];
    
    self.tableView.tableFooterView.hidden = YES;
    self.isLoading = NO;

    self.maxPostsCount = -1;
    self.posts = [NSMutableArray array];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![ARServerManager sharedManager].currentUser) {
        
        [[ARServerManager sharedManager] authorizeUser:^{
            NSLog(@"AUTHORIZED");
            
            UINavigationController* friendsNavigCcontroller = [[self.tabBarController viewControllers] objectAtIndex:1];
            ARFriendsListTVController* friendsController = (ARFriendsListTVController*)friendsNavigCcontroller.topViewController;
            friendsController.userId = [ARServerManager sharedManager].currentUser.objectId;
            
            [self getGroupHeader];
            [self getGroupWall];
        }];
    }
}

#pragma mark - Actions -

- (void)actionLike:(UIButton*)sender {
    
    ARPostInfoCell* cell = (ARPostInfoCell*)[[sender superview] superview];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    NSLog(@"indpath = %ld, %ld", indexPath.section, indexPath.row);
    
    ARPost* post = [self.posts objectAtIndex:indexPath.section - 2];
    
    [[ARServerManager sharedManager] isPost:post.objectId
                                   onWallOf:self.currentGroup.objectId
                                likedByUser:[ARServerManager sharedManager].currentUser.objectId
                                  onSuccess:^(BOOL liked) {
                                      if (liked) {
                                          
                                          [[ARServerManager sharedManager] deleteLikeFromPost:post.objectId
                                                                                    onSuccess:^(BOOL likeDeleted) {
                                                                                        
                                                                                        if (likeDeleted) {
                                                                                            cell.likesCountLabel.textColor = TEXT_COLOR_1;
                                                                                            post.likesCount -= 1;
                                                                                            cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld", post.likesCount];
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                                                        NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                                                    }];
                                          
                                      } else {
                                          
                                          [[ARServerManager sharedManager] addLikeOnPost:post.objectId
                                                                               onSuccess:^(BOOL likeAdded) {
                                                                                   
                                                                                   if (likeAdded) {
                                                                                       cell.likesCountLabel.textColor = TEXT_COLOR_2;
                                                                                       post.likesCount += 1;
                                                                                       cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld", post.likesCount];
                                                                                   }
                                                                               }
                                                                               onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                                                   NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                                               }];
                                          
                                      }
                                  }
                                  onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                      NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                  }];
    
}

- (void)actionComment:(UIButton*)sender {
    
    ARPostInfoCell* cell = (ARPostInfoCell*)[[sender superview] superview];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    ARCommentsTVController* commentsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARCommentsTVController"];
    commentsController.currentPost = [self.posts objectAtIndex:indexPath.section - 2];
    commentsController.wallOwnerId = self.currentGroup.objectId;
    [self.navigationController pushViewController:commentsController
                                         animated:YES];
}

- (void)actionGetVideos:(UIButton*)sender {
    
    ARVideosListTVController* videosController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARVideosListTVController"];
    videosController.groupId = self.currentGroup.objectId;
    [self.navigationController pushViewController:videosController
                                         animated:YES];
}


#pragma mark - API -

- (void)getGroupHeader {
    
    [[ARServerManager sharedManager] getGroupInfoById:groupId
                                            onSuccess:^(ARGroup * _Nonnull group) {
                                                
                                                self.currentGroup = group;
                                                [self.tableView reloadData];
                                                
                                            } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                            }];
    
}

- (void)getGroupWall {
    
    [[ARServerManager sharedManager] getGroupWallById:groupId
                                            withCount:limitCount
                                            andOffset:[self.posts count]
                                            onSuccess:^(NSInteger maxPosts, NSArray * _Nonnull posts) {
                                                if (self.isLoading) {
                                                    self.isLoading = NO;
                                                    [self.loadingIndicator stopAnimating];
                                                    self.tableView.tableFooterView.hidden = YES;
                                                }

                                                if (self.maxPostsCount < 0) self.maxPostsCount = maxPosts;

                                                [self.posts addObjectsFromArray:posts];
                                                [self.tableView reloadData];
                                                
                                                if (self.loadingTableIndicator) {
                                                    
                                                    [self.loadingTableIndicator stopAnimating];
                                                    [self.loadingTableIndicator removeFromSuperview];
                                                    [self.viewForLoading removeFromSuperview];
                                                    
                                                }
                                                
                                            } onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                            }];
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.currentGroup) return [self.posts count] + 2;
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.currentGroup) {
        if (section == 0 || section == 1) return 1;
        return 2;
    }
    
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* headerId = @"groupHeader";
    static NSString* writePostId = @"writeCell";
    static NSString* postId = @"postCell";
    static NSString* postInfoId = @"postInfoCell";
    
    if (indexPath.section == 0) {
        
        ARHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:headerId forIndexPath:indexPath];
        
        if (self.currentGroup) {
            cell.nameLabel.text = self.currentGroup.name;
            
            [cell.photosButton setTitle:self.currentGroup.photosCount forState:UIControlStateNormal];
            [cell.videosButton setTitle:self.currentGroup.videosCount forState:UIControlStateNormal];
            
            [cell.videosButton addTarget:self
                                  action:@selector(actionGetVideos:)
                        forControlEvents:UIControlEventTouchUpInside];
            
            NSData *data = [NSData dataWithContentsOfURL:self.currentGroup.largeImageURL];
            cell.coverImageView.image = [UIImage imageWithData:data];
            cell.coverImageView.layer.masksToBounds = YES;
            cell.coverImageView.layer.cornerRadius = CGRectGetWidth(cell.coverImageView.frame) / 2;
        }
        
        return cell;
        
    } else if (indexPath.section == 1) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:writePostId];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:writePostId];
        }
        
        cell.textLabel.text = @"Make a post";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    } else {
        
        ARPost* post = [self.posts objectAtIndex:indexPath.section - 2];
        
        if (indexPath.row == 0) {
            
            ARPostCell* cell = [tableView dequeueReusableCellWithIdentifier:postId forIndexPath:indexPath];
            [[cell.contentView viewWithTag:1000] removeFromSuperview];
            
            NSData *data = [NSData dataWithContentsOfURL:post.fromObject.imageURL];
            cell.authorImageView.image = [UIImage imageWithData:data];
            cell.authorImageView.layer.masksToBounds = YES;
            cell.authorImageView.layer.cornerRadius = CGRectGetWidth(cell.authorImageView.frame) / 2;
            
            cell.authorNameLabel.text = post.fromObject.name;
            cell.authorDateLabel.text = dateToString(post.date);
            cell.authorTextLabel.text = post.postText;
            
            if ([post.postPhotos count] > 0) {
                
                int offset = 15.f;
                CGFloat scrollHeight = 150.f;
                CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
                CGRect rect = CGRectMake(offset, [ARPostCell heightForPostWithoutPhotos:post.postText], screenWidth - 2 * offset, scrollHeight);
                UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:rect];
                scrollView.backgroundColor = [UIColor whiteColor];
                
                int x = 0;
                for (NSURL* imageURL in post.postPhotos) {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, scrollHeight, scrollHeight)];
                    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
                    [scrollView addSubview:imageView];
                    x = x + scrollHeight + 10.f;
                }
                
                scrollView.contentSize = CGSizeMake(x, scrollHeight);
                scrollView.tag = 1000;
                [cell.contentView addSubview:scrollView];
                
            }

            return cell;
        
        } else {
            
            ARPostInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:postInfoId];
            cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld", post.likesCount];
            cell.commentsCountLabel.text = [NSString stringWithFormat:@"%ld", post.commentsCount];
            
            if (post.liked) cell.likesCountLabel.textColor = TEXT_COLOR_2;
            
            [cell.likeButton addTarget:self
                                action:@selector(actionLike:)
                      forControlEvents:UIControlEventTouchUpInside];
            
            [cell.commentButton addTarget:self
                                   action:@selector(actionComment:)
                         forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return 140;
    
    if (indexPath.section == 1) return 44;
    
    if (indexPath.row != 0) return 50;
    
    ARPost* post = [self.posts objectAtIndex:indexPath.section - 2];
    
    if ([post.postPhotos count] > 0) return [ARPostCell heightForPostWithPhotos:post.postText];
    return [ARPostCell heightForPostWithoutPhotos:post.postText];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (indexPath.section == 1) {
        
        UIAlertController* addPostAlert = [UIAlertController alertControllerWithTitle:@"Add new post"
                                                                                 message:@"post text:"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             
                                                             [[ARServerManager sharedManager] addPost:addPostAlert.textFields[0].text
                                                                                             onWallOf:self.currentGroup.objectId
                                                                                            onSuccess:^(BOOL postAdded, ARPost* newPost) {
                                                                                                
                                                                                                if (postAdded) {
                                                                                                    
                                                                                                    [self.posts insertObject:newPost atIndex:0];
                                                                                                    
                                                                                                    [tableView beginUpdates];
                                                                                                    
                                                                                                    [tableView insertSections:[NSIndexSet indexSetWithIndex:2]
                                                                                                             withRowAnimation:UITableViewRowAnimationLeft];
                                                                                                    
                                                                                                    [self.tableView endUpdates];
                                                                                                }
                                                                                            }
                                                                                            onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                                                                NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                                                            }];
                                                             
                                                             
                                                         }];
        
        UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        [addPostAlert addAction:actionOK];
        [addPostAlert addAction:actionCancel];
        
        [addPostAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"...";
        }];
        [self presentViewController:addPostAlert animated:YES completion:nil];
    }
    
    if (indexPath.section > 1 && indexPath.row == 0) {
        
        ARCommentsTVController* commentsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARCommentsTVController"];
        commentsController.currentPost = [self.posts objectAtIndex:indexPath.section - 2];
        commentsController.wallOwnerId = self.currentGroup.objectId;
        [self.navigationController pushViewController:commentsController
                                             animated:YES];
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) return NO;
    
    return indexPath.row == 0;
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat maxOffset = scrollView.contentSize.height - scrollView.frame.size.height;

    if (maxOffset - offset < 0 && [self.posts count] < self.maxPostsCount && self.maxPostsCount > 0) {
        [self loadMore];
    }
}

#pragma mark - Additional methods -

- (void)loadMore {
    if (!self.isLoading) {
        self.isLoading = YES;
        [self.loadingIndicator startAnimating];
        self.tableView.tableFooterView.hidden = NO;
        [self getGroupWall];
    }
}


@end
