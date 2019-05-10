//
//  UIView+MKAnnotationView.h
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 08.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (MKAnnotationView)

- (MKAnnotationView*)superAnnotationView;

@end

NS_ASSUME_NONNULL_END
