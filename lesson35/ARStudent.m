//
//  ARStudent.m
//  Lesson35Task
//
//  Created by Анастасия Распутняк on 24.04.2019.
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
    
    long long year = 31536000;
    long long timeInSeconds = arc4random() % (5 * year) + 2 * year;   // 1994-1998~
    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:-timeInSeconds];
    student.birthDate = date;
    
    return student;
}


@end
