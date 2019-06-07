//
//  ARAuthorizationController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARAuthorizationController.h"
#import "../ARUtils.h"
#import <WebKit/WebKit.h>
#import "../ARAccessToken.h"

@interface ARAuthorizationController () <WKNavigationDelegate>
@property (strong, nonatomic) ASAuthorizationBlock completionBlock;
@property (weak, nonatomic) UIActivityIndicatorView* loadingAuthorizationIndicator;
@property (weak, nonatomic) WKWebView* webView;
@end

@implementation ARAuthorizationController

- (id)initWithCompletionBlock:(ASAuthorizationBlock)completion {
    self = [super init];
    
    if (self) {
        self.completionBlock = completion;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CGRect rect = self.view.bounds;
    WKWebView* webView = [[WKWebView alloc] initWithFrame:rect];
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIActivityIndicatorView* loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.webView addSubview:loadingIndicator];
    self.loadingAuthorizationIndicator = loadingIndicator;
    self.loadingAuthorizationIndicator.center = self.view.center;
    self.loadingAuthorizationIndicator.hidesWhenStopped = YES;
    self.loadingAuthorizationIndicator.color = MAIN_APP_COLOR;
    
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                target:self
                                                                                action:@selector(actionCancel:)];
    cancelItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    self.navigationItem.title = @"Authorization";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor = MAIN_APP_COLOR;
    
    NSString* stringURL = @"https://oauth.vk.com/authorize?"
                           "client_id=7002415&"
                           "display=mobile&"
                           "redirect_uri=https://oauth.vk.com/blank.html&"
                           "scope=73750&response_type=token&"
                           "v=5.95&"
                           "revoke=1";
    
    NSURL* url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
}

- (void)dealloc {
    self.webView.navigationDelegate = nil;
}

- (void)actionCancel:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
    
}

#pragma mark - WKNavigationDelegate -

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString* request = navigationAction.request.URL.absoluteString;
    
    if ([request rangeOfString:@"access_token"].location != NSNotFound) {
        
        NSString* query = [[request componentsSeparatedByString:@"#"] lastObject];
        NSArray* pairs = [query componentsSeparatedByString:@"&"];
        
        ARAccessToken* accessToken = [[ARAccessToken alloc] init];
        for (NSString* pairString in pairs) {
            NSArray* pair = [pairString componentsSeparatedByString:@"="];
            
            if ([[pair firstObject] isEqualToString:@"access_token"]) {
                accessToken.token = [pair lastObject];
            } else if ([[pair firstObject] isEqualToString:@"expires_in"]) {
                accessToken.expirationDate = [NSDate dateWithTimeIntervalSinceNow:[[pair lastObject] integerValue]];
            } else if ([[pair firstObject] isEqualToString:@"user_id"]) {
                accessToken.userId = [[pair lastObject] integerValue];
            }
        }
        
        if (self.completionBlock) {
            self.completionBlock(accessToken);
        }
        
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    } else {
        
        decisionHandler(WKNavigationActionPolicyAllow);
        
    }
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self.loadingAuthorizationIndicator startAnimating];
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self.loadingAuthorizationIndicator stopAnimating];
    
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    [self.loadingAuthorizationIndicator stopAnimating];
    
}


@end
