//
//  ARStudent.h
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 06.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ARStudentGenderFemale,
    ARStudentGenderMale
} ARStudentGender;

@interface ARStudent : NSObject <MKAnnotation>

#pragma mark - MKAnnotation
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) CLLocation* location;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (strong, nonatomic) UIImage* image;

#pragma mark - Student properties
@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) ARStudentGender gender;
@property (strong, nonatomic) NSString* birthDate;

+ (ARStudent*)randomStudent;

@end

NS_ASSUME_NONNULL_END
