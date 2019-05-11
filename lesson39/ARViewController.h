//
//  ARViewController.h
//  Lesson39Task
//
//  Created by Анастасия Распутняк on 11.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ARSectionModePdfFile,
    ARSectionModeWebPage
} ARSectionMode;

@interface ARViewController : UIViewController

@property (strong, nonatomic) NSURL* url;
@property (assign, nonatomic) ARSectionMode section;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

NS_ASSUME_NONNULL_END
