//
//  ARCourse+CoreDataProperties.m
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 21.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

#import "ARCourse+CoreDataProperties.h"

@implementation ARCourse (CoreDataProperties)

+ (NSFetchRequest<ARCourse *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ARCourse"];
}

@dynamic branch;
@dynamic courseName;
@dynamic students;
@dynamic teacher;

@end
