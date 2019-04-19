//
//  ARStudent.m
//  Lesson30Task1
//
//  Created by Анастасия Распутняк on 18.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARStudent.h"

@implementation ARStudent

- (id)initWithFirstName:(NSString*)firstName lastName:(NSString*)lastName andAverageMark:(CGFloat)averageMark {
    self = [super init];
    
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.averageMark = averageMark;
        
        if (averageMark == 5.f) {
            self.rate = ARStudentMarkTypeBest;
        } else if (averageMark >= 4.f && averageMark < 5.f) {
            self.rate = ARStudentMarkTypeGood;
        } else if (averageMark >= 3.f && averageMark < 4.f) {
            self.rate = ARStudentMarkTypeBad;
        } else {
            self.rate = ARStudentMarkTypeWorst;
        }
    }
    
    return self;
}

@end
