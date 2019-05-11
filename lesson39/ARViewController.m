//
//  ARViewController.m
//  Lesson39Task
//
//  Created by Анастасия Распутняк on 11.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARViewController.h"

@interface ARViewController () <WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButtonItem;
- (IBAction)actionReload:(UIBarButtonItem *)sender;
- (IBAction)actionBack:(UIBarButtonItem *)sender;
- (IBAction)actionForward:(UIBarButtonItem *)sender;
@end

@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView.navigationDelegate = self;
    if (self.url) {
        NSURLRequest *request=[NSURLRequest requestWithURL:self.url];
        [self.webView loadRequest:request];
    }
}

#pragma mark - Actions -


- (IBAction)actionBack:(UIBarButtonItem *)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (IBAction)actionForward:(UIBarButtonItem *)sender {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (IBAction)actionReload:(UIBarButtonItem *)sender {
    if (self.section == ARSectionModePdfFile) {
        [self.webView reload];
    } else {
        [[UIApplication sharedApplication] openURL:self.url
                                           options:@{}
                                 completionHandler:nil];
    }
}

#pragma mark - WKNavigationDelegate -

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indicatorView startAnimating];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [self.indicatorView stopAnimating];
    
    self.backButtonItem.enabled = [self.webView canGoBack];
    self.forwardButtonItem.enabled = [self.webView canGoForward];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.indicatorView stopAnimating];
}


@end
