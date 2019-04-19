//
//  ARColor.h
//  Lesson30Task
//
//  Created by Анастасия Распутняк on 18.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARColor : NSObject

@property (strong, nonatomic) NSString* colorName;
@property (strong, nonatomic) UIColor* color;

- (id)initColor;

@end

NS_ASSUME_NONNULL_END
