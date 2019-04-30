//
//  AREducationController.h
//  Lesson36Task
//
//  Created by Анастасия Распутняк on 29.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AREducationControllerDelegate;

@interface AREducationController : UITableViewController

@property (strong, nonatomic) NSString* educationType;
@property (strong, nonatomic) NSIndexPath* chosenEducation;
@property (weak, nonatomic) id <AREducationControllerDelegate> delegate;

@end


@protocol AREducationControllerDelegate <NSObject>

- (void)updateEducation:(AREducationController*)educController;

@end

NS_ASSUME_NONNULL_END
