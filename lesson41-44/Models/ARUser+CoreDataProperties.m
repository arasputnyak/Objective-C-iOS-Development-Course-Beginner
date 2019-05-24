//
//  ARUser+CoreDataProperties.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 21.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

#import "ARUser+CoreDataProperties.h"

@implementation ARUser (CoreDataProperties)

+ (NSFetchRequest<ARUser *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ARUser"];
}

@dynamic email;
@dynamic firstName;
@dynamic lastName;
@dynamic gender;
@dynamic birthDate;
@dynamic learningCourses;
@dynamic teachingCourses;

@end
