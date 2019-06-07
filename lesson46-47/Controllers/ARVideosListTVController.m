//
//  ARVideosListTVController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARVideosListTVController.h"
#import "../ARServerManager.h"
#import "../Cells/ARVideoCell.h"
#import "ARVideoController.h"

@interface ARVideosListTVController ()
@property (assign, nonatomic) NSInteger maxVideosCount;
@property (strong, nonatomic) NSMutableArray* videos;
@property (assign, nonatomic) BOOL isLoading;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@end

static NSInteger limitCount = 10;

@implementation ARVideosListTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Videos";
    
    self.tableView.tableFooterView.hidden = YES;
    self.isLoading = NO;
    
    self.videos = [NSMutableArray array];
    self.maxVideosCount = -1;
}

- (void)getVideosFromServer {
    
    [[ARServerManager sharedManager] getVideosById:self.groupId
                                        withOffset:[self.videos count]
                                             count:limitCount
                                         onSuccess:^(NSInteger maxVideos, NSArray * _Nonnull videos) {
                                             if (self.isLoading) {
                                                 self.isLoading = NO;
                                                 [self.loadingIndicator stopAnimating];
                                                 self.tableView.tableFooterView.hidden = YES;
                                             }
                                             
                                             if (self.maxVideosCount < 0) self.maxVideosCount = maxVideos;
                                             [self.videos addObjectsFromArray:videos];
                                             [self.tableView reloadData];
                                             
                                         }
                                         onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                             NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                         }];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.videos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* videoId = @"videoCell";
    
    ARVideoCell* cell = [tableView dequeueReusableCellWithIdentifier:videoId];
    
    ARVideo* video = [self.videos objectAtIndex:indexPath.row];
    
    cell.videoNameLabel.text = video.name;
    cell.videoViewsLabel.text = [NSString stringWithFormat:@"%ld views", video.views];
    NSData *data = [NSData dataWithContentsOfURL:video.largeImageURL];
    cell.videoImageView.image = [UIImage imageWithData:data];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - UITableViewDelegate -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath
                                  animated:YES];
    
    ARVideoController* videoController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARVideoController"];
    videoController.currentVideo = [self.videos objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:videoController
                                         animated:YES];
    
}

#pragma mark - UIScrollViewDelegate -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat maxOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maxOffset - offset < 0 && self.groupId && [self.videos count] < self.maxVideosCount) {
        [self loadMore];
    }
}

#pragma mark - Additional methods -

- (void)loadMore {
    if (!self.isLoading) {
        self.isLoading = YES;
        [self.loadingIndicator startAnimating];
        self.tableView.tableFooterView.hidden = NO;
        [self getVideosFromServer];
    }
}


@end
