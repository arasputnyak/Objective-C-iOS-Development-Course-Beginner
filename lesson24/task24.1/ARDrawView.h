//
//  ARDrawView.h
//  Lesson24Task1
//
//  Created by Анастасия Распутняк on 09.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARDrawView : UIView

@property (strong, nonatomic) UIColor* drawColor;
@property (assign, nonatomic) CGFloat drawSize;
@property (strong, nonatomic) NSMutableDictionary* drawPoints;

@end

NS_ASSUME_NONNULL_END
