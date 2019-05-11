//
//  ARTableViewController.m
//  Lesson39Task
//
//  Created by Анастасия Распутняк on 11.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARTableViewController.h"
#import "ARViewController.h"

typedef enum {
    ARContentTypeTicket,
    ARContentTypeCertificate,
    ARContentTypeDiplom,
    ARContentTypeInst,
    ARContentTypeTwitt,
    ARContentTypeVk
} ARContentType;

@interface ARTableViewController () <UITableViewDelegate>

@end

static NSString* ticket = @"ticket";
static NSString* certificate = @"certificate";
static NSString* diplom = @"diplom";
static NSString* instagram = @"https://instagram.com/***/";
static NSString* twitter = @"https://twitter.com/***";
static NSString* vkontakte = @"https://vk.com/***";

@implementation ARTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    
    UITableViewCell* currentCell = [tableView cellForRowAtIndexPath:indexPath];
    ARViewController* webController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    NSURL *url = nil;
    
    if (indexPath.section == 0) {
        webController.section = ARSectionModePdfFile;
        NSString* filePath = nil;
        
        switch (currentCell.tag) {
            case ARContentTypeTicket:
                filePath = [[NSBundle mainBundle] pathForResource:ticket
                                                           ofType:@"pdf"];
                break;
                
            case ARContentTypeCertificate:
                filePath = [[NSBundle mainBundle] pathForResource:certificate
                                                           ofType:@"pdf"];
                break;
                
            case ARContentTypeDiplom:
                filePath = [[NSBundle mainBundle] pathForResource:diplom
                                                           ofType:@"pdf"];
                break;
                
            default:
                break;
        }
        
        url = [NSURL fileURLWithPath:filePath];
        
    } else {
        
        webController.section = ARSectionModeWebPage;
        switch (currentCell.tag) {
            case ARContentTypeInst:
                url = [NSURL URLWithString:instagram];
                break;
                
            case ARContentTypeTwitt:
                url = [NSURL URLWithString:twitter];
                break;
                
            case ARContentTypeVk:
                url = [NSURL URLWithString:vkontakte];
                break;
                
            default:
                break;
        }
    }
    
    if (url) {
        webController.url = url;
        
        [self.navigationController pushViewController:webController
                                             animated:YES];
    }
}


@end
