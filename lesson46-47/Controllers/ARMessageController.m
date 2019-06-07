//
//  ARMessageController.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 31.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARMessageController.h"
#import "../ARUtils.h"
#import "../ARServerManager.h"

typedef enum {
    ARMessageStateClear,
    ARMessageStateTexted
} ARMessageState;

@interface ARMessageController () <UITextViewDelegate>
@property (assign, nonatomic) ARMessageState messageState;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *userMessageTextView;
- (IBAction)actionSend:(UIButton *)sender;
@end

@implementation ARMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.messageState = ARMessageStateClear;
    
    self.navigationItem.title = @"Message To";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UIColor* mainColor = MAIN_APP_COLOR;
    self.userMessageTextView.layer.borderColor = mainColor.CGColor;
    self.userMessageTextView.layer.borderWidth = 2.f;
    self.userMessageTextView.layer.cornerRadius = 15.f;
    self.userMessageTextView.delegate = self;
    
    if (self.user) {
        self.userNameLabel.text = self.user.name;
        
        NSData *data = [NSData dataWithContentsOfURL:self.user.largeImageURL];
        self.userImageView.image = [UIImage imageWithData:data];
        self.userImageView.layer.masksToBounds = YES;
        self.userImageView.layer.cornerRadius = CGRectGetWidth(self.userImageView.frame) / 2;
    }
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidBeginEditing:(UITextView *)textView; {
    
    if (self.messageState == ARMessageStateClear) {
        textView.text = @" ";
        textView.textColor = [UIColor blackColor];
        textView.font = [UIFont systemFontOfSize:17.f];
        
        self.messageState = ARMessageStateTexted;
    }
    
}

#pragma mark - Actions -

- (IBAction)actionSend:(UIButton *)sender {
    
    [[ARServerManager sharedManager] sendMessage:self.userMessageTextView.text
                                      toUserById:self.user.objectId
                                       onSuccess:^(BOOL sended) {
                                           
                                           if (sended) {
                                               
                                               self.userMessageTextView.text = @" Write your message..";
                                               self.userMessageTextView.textColor = [UIColor lightGrayColor];
                                               self.userMessageTextView.font = [UIFont italicSystemFontOfSize:17.f];
                                               
                                               self.messageState = ARMessageStateClear;
                                               
                                           } else {
                                               
                                               NSLog(@"server send error response!");
                                           }
                                       }
                                       onFailure:^(NSError * _Nonnull error, NSInteger statusCode) {
                                           NSLog(@"error = %@\nstatus = %ld", [error localizedDescription], (long)statusCode);
                                       }];
}


@end
