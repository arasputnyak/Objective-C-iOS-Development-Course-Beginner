//
//  ARTableViewController.h
//  Lesson33Task
//
//  Created by Анастасия Распутняк on 22.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARTableViewController : UITableViewController

@property (strong, nonatomic) NSString* path;

- (id)initWithFolderPath:(NSString*)path;

@end

NS_ASSUME_NONNULL_END
