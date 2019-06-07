//
//  ARVideoController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 06.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARVideoController.h"
#import <WebKit/WebKit.h>

@interface ARVideoController () <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *videoWebView;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoViewsLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingVideoIndicator;
@end

@implementation ARVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.videoWebView.navigationDelegate = self;
    
    self.videoNameLabel.text = self.currentVideo.name;
    self.videoViewsLabel.text = [NSString stringWithFormat:@"%ld views", self.currentVideo.views];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.currentVideo.videoURL];
    
    [self.videoWebView loadRequest:request];
}

#pragma mark - WKNavigationDelegate -

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

    [self.loadingVideoIndicator startAnimating];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self.loadingVideoIndicator stopAnimating];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    [self.loadingVideoIndicator stopAnimating];
    
}


@end
