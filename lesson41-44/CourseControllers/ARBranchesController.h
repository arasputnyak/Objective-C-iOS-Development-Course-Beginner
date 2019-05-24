//
//  ARBranchesController.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 23.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ARBranchesControllerDelegate;

@interface ARBranchesController : UITableViewController

@property (strong, nonatomic) NSArray* branches;
@property (strong, nonatomic) NSString* chosenBranch;
@property (weak, nonatomic) id <ARBranchesControllerDelegate> delegate;

@end


@protocol ARBranchesControllerDelegate <NSObject>

- (void)updateBranch:(ARBranchesController*)branchController;

@end

NS_ASSUME_NONNULL_END
