//
//  ARCommentsTVController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARCommentsTVController.h"
#import "../ARUtils.h"
#import "../Cells/ARPostCell.h"
#import "../Cells/ARPostInfoCell.h"
#import "../Models/ARComment.h"
#import "../ARServerManager.h"

@interface ARCommentsTVController ()
@property (strong, nonatomic) NSMutableArray* comments;
@end

@implementation ARCommentsTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.comments = [NSMutableArray array];
    
    UIBarButtonItem* addComment = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                                target:self
                                                                                action:@selector(actionAddComment:)];
    self.navigationItem.rightBarButtonItem = addComment;
    
    [self getCommentsFromServer];
}

#pragma mark - API -

- (void)getCommentsFromServer {
    
    [[ARServerManager sharedManager] getCommentsForPost:self.currentPost.objectId
                                               onWallOf:self.wallOwnerId
                                              onSuccess:^(NSArray * _Nonnull comments) {
                                                  self.comments = [comments mutableCopy];
                                                  [self.tableView reloadData];
                                              }
                                              onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                  NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                              }];
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.comments count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* postId = @"postCell";
    static NSString* postInfoId = @"postInfoCell";
    static NSString* commentId = @"commentCell";
    
    if (indexPath.row == 0) {
        ARPostCell* cell = [tableView dequeueReusableCellWithIdentifier:postId forIndexPath:indexPath];
        
        NSData *data = [NSData dataWithContentsOfURL:self.currentPost.fromObject.imageURL];
        cell.authorImageView.image = [UIImage imageWithData:data];
        cell.authorImageView.layer.masksToBounds = YES;
        cell.authorImageView.layer.cornerRadius = CGRectGetWidth(cell.authorImageView.frame) / 2;
        
        cell.authorNameLabel.text = self.currentPost.fromObject.name;
        cell.authorDateLabel.text = dateToString(self.currentPost.date);
        cell.authorTextLabel.text = self.currentPost.postText;
        
        return cell;
        
    } else if (indexPath.row == 1) {
        ARPostInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:postInfoId forIndexPath:indexPath];
        
        cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld", self.currentPost.likesCount];
        cell.commentsCountLabel.text = [NSString stringWithFormat:@"%ld", self.currentPost.commentsCount];
        
        if (self.currentPost.liked) cell.likesCountLabel.textColor = TEXT_COLOR_2;
        
        [cell.likeButton addTarget:self
                            action:@selector(actionLike:)
                  forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    } else {
        ARPostCell* cell = [tableView dequeueReusableCellWithIdentifier:commentId];
        ARComment* comment = [self.comments objectAtIndex:indexPath.row - 2];
        
        NSData *data = [NSData dataWithContentsOfURL:comment.fromObject.imageURL];
        cell.authorImageView.image = [UIImage imageWithData:data];
        cell.authorImageView.layer.masksToBounds = YES;
        cell.authorImageView.layer.cornerRadius = CGRectGetWidth(cell.authorImageView.frame) / 2;
        
        cell.authorNameLabel.text = comment.fromObject.name;
        cell.authorDateLabel.text = dateToString(comment.date);
        cell.authorTextLabel.text = comment.commentText;
        
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return [ARPostCell heightForPostWithoutPhotos:self.currentPost.postText];
        
    } else if (indexPath.row == 1) {
        
        return 50;
        
    } else {
        
        ARComment* comment = [self.comments objectAtIndex:indexPath.row - 2];
        return [ARPostCell heightForComment:comment.commentText];
    }
    
}

- (void)actionLike:(UIButton*)sender {
    
    ARPostInfoCell* cell = (ARPostInfoCell*)[[sender superview] superview];
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    [[ARServerManager sharedManager] isPost:self.currentPost.objectId
                                   onWallOf:self.wallOwnerId
                                likedByUser:[ARServerManager sharedManager].currentUser.objectId
                                  onSuccess:^(BOOL liked) {
                                      if (liked) {
                                          
                                          [[ARServerManager sharedManager] deleteLikeFromPost:self.currentPost.objectId
                                                                                    onSuccess:^(BOOL likeDeleted) {
                                                                                        
                                                                                        if (likeDeleted) {
                                                                                            cell.likesCountLabel.textColor = TEXT_COLOR_1;
                                                                                            self.currentPost.likesCount -= 1;
                                                                                            cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld", self.currentPost.likesCount];
                                                                                        }
                                                                                        
                                                                                    }
                                                                                    onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                                                                        NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                                                                    }];
                                          
                                      } else {
                                          
                                          [[ARServerManager sharedManager] addLikeOnPost:self.currentPost.objectId
                                                                               onSuccess:^(BOOL likeAdded) {
                                                                                   
                                                                                   if (likeAdded) {
                                                                                       cell.likesCountLabel.textColor = TEXT_COLOR_2;
                                                                                       self.currentPost.likesCount += 1;
                                                                                       cell.likesCountLabel.text = [NSString stringWithFormat:@"%ld", self.currentPost.likesCount];
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

- (void)actionAddComment:(UIBarButtonItem*)sender {
    
    UIAlertController* addCommentAlert = [UIAlertController alertControllerWithTitle:@"Add new comment"
                                                                             message:@"comment text:"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [[ARServerManager sharedManager] addComment:addCommentAlert.textFields[0].text
                                                                                             forPost:self.currentPost.objectId
                                                                                            onWallOf:self.wallOwnerId
                                                                                           onSuccess:^(BOOL commentAdded, ARComment* newComment) {
                                                                                               
                                                                                               if (commentAdded) {
                                                                                                   
                                                                                                   [self.comments addObject:newComment];
                                                                                                   
                                                                                                   [self.tableView beginUpdates];
                                                                                                   
                                                                                                   [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.comments count] + 1
                                                                                                                                                               inSection:0]]
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
    
    [addCommentAlert addAction:actionOK];
    [addCommentAlert addAction:actionCancel];
    
    [addCommentAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"...";
    }];
    [self presentViewController:addCommentAlert animated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}


@end
