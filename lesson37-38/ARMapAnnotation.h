//
//  ARMapAnnotation.h
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 08.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARMapAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) CLLocation* location;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;

@end

NS_ASSUME_NONNULL_END
