//
//  ARDatePickerController.h
//  Lesson36Task
//
//  Created by Анастасия Распутняк on 29.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ARDatePickerControllerDelegate;

@interface ARDatePickerController : UIViewController

@property (strong, nonatomic) NSDate* date;
@property (weak, nonatomic) id <ARDatePickerControllerDelegate> delegate;

@end


@protocol ARDatePickerControllerDelegate <NSObject>

- (void)dateControllerendsUpdates:(ARDatePickerController*)datePickerController;

@end

NS_ASSUME_NONNULL_END
