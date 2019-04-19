//
//  ARStudent.h
//  Lesson30Task1
//
//  Created by Анастасия Распутняк on 18.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    ARStudentMarkTypeBest,
    ARStudentMarkTypeGood,
    ARStudentMarkTypeBad,
    ARStudentMarkTypeWorst
} ARStudentMarkType;

NS_ASSUME_NONNULL_BEGIN

@interface ARStudent : NSObject

@property (strong, nonatomic) NSString* firstName;
@property (strong, nonatomic) NSString* lastName;
@property (assign, nonatomic) CGFloat averageMark;
@property (assign, nonatomic) ARStudentMarkType rate;

- (id)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName andAverageMark:(CGFloat)averageMark;

@end

NS_ASSUME_NONNULL_END
