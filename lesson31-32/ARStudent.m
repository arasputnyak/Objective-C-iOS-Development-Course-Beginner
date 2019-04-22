//
//  ARStudent.m
//  Lesson31Task
//
//  Created by Анастасия Распутняк on 21.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARStudent.h"

@implementation ARStudent

static NSString* firstNames[] = {@"Helen", @"Jasmine", @"Phoebe", @"Aysha", @"Madeleine",
                                 @"Christina", @"Melissa", @"Marie", @"Tamara", @"Freya",
                                 @"Evangeline", @"Ismail", @"Amir", @"Herbert", @"Nicolas",
                                 @"Alvin", @"Rufus", @"Lara", @"Willie", @"Umar"};

static NSString* lastNames[] = {@"Campos", @"Long", @"Strickland", @"Reynolds", @"Carpenter",
                                @"Sherman", @"Watkins", @"Stone", @"Newton", @"O'Reilly",
                                @"Thorne", @"Zimmerman", @"Holland", @"Mccarthy", @"Ferguson",
                                @"Hawkins", @"Mcdonald", @"Watson", @"Richardson", @"Howells"};

static int namesCount = 20;

+ (ARStudent*)randomStudent {
    ARStudent* student = [[ARStudent alloc] init];
    
    student.firstName = firstNames[arc4random() % namesCount];
    student.lastName = lastNames[arc4random() % namesCount];
    CGFloat random = (CGFloat)(arc4random() % 301 + 200) / 100.f;
    student.averageMark = ceilf(random * 10) / 10;
    
    return student;
}


@end
