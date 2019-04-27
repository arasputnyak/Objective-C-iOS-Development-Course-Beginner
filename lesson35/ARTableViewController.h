//
//  ARTableViewController.h
//  Lesson35Task
//
//  Created by Анастасия Распутняк on 24.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *sortControl;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)actionControlChanged:(UISegmentedControl *)sender;

@end

NS_ASSUME_NONNULL_END
