//
//  ARStudent.m
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 06.05.2019.
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

static long long year = 31536000;

static double latitude = 59.8f;
static double longitude = 30.2f;

+ (ARStudent*)randomStudent {
    ARStudent* student = [[ARStudent alloc] init];
    
    int nameIndex = arc4random() % namesCount;
    student.firstName = firstNames[nameIndex];
    student.gender = nameIndex < 11 ? ARStudentGenderFemale : ARStudentGenderMale;
    
    student.lastName = lastNames[arc4random() % namesCount];
    
    long long timeInSeconds = arc4random() % (5 * year) + 2 * year;   // 1994-1998~
    NSDate* date = [NSDate dateWithTimeIntervalSinceReferenceDate:-timeInSeconds];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* dateString = [formatter stringFromDate:date];
    student.birthDate = dateString;
    
    // protocol    
    student.title = @"Show Info";
    student.subtitle = @"Click info button to see user info";
    
    double latDelta = (double)(arc4random() % 200) / 1000;
    double longDelta = (double)(arc4random() % 400) / 1000;
    student.coordinate = CLLocationCoordinate2DMake(latitude + latDelta, longitude + longDelta);
    student.location = [[CLLocation alloc] initWithLatitude:student.coordinate.latitude
                                                      longitude:student.coordinate.longitude];
    
    UIImage* femaleImage = [UIImage imageNamed:@"female.png"];
    UIImage* maleImage = [UIImage imageNamed:@"male.png"];
    
    CGSize size = CGSizeMake(40, 55);
    femaleImage = [ARStudent resizeImage:femaleImage toSize:size];
    maleImage = [ARStudent resizeImage:maleImage toSize:size];
    
    student.image = student.gender == ARStudentGenderFemale ? femaleImage : maleImage;
    
    return student;
}

+ (UIImage*)resizeImage:(UIImage*)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
