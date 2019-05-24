//
//  ARDatePickerController.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 22.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ARDatePickerControllerDelegate;

@interface ARDatePickerController : UIViewController

@property (strong, nonatomic) NSDate* date;
@property (weak, nonatomic) id <ARDatePickerControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END


@protocol ARDatePickerControllerDelegate <NSObject>

- (void)dateControllerSendsUpdates:(ARDatePickerController*)datePickerController;

@end
