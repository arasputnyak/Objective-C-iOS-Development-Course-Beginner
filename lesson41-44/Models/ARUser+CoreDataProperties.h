//
//  ARUser+CoreDataProperties.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 21.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

#import "ARUser+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ARUser (CoreDataProperties)

+ (NSFetchRequest<ARUser *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *email;
@property (nullable, nonatomic, copy) NSString *firstName;
@property (nullable, nonatomic, copy) NSString *lastName;
@property (nonatomic) BOOL gender;
@property (nullable, nonatomic, copy) NSDate *birthDate;
@property (nullable, nonatomic, retain) NSSet<ARCourse *> *learningCourses;
@property (nullable, nonatomic, retain) NSSet<ARCourse *> *teachingCourses;

@end

@interface ARUser (CoreDataGeneratedAccessors)

- (void)addLearningCoursesObject:(ARCourse *)value;
- (void)removeLearningCoursesObject:(ARCourse *)value;
- (void)addLearningCourses:(NSSet<ARCourse *> *)values;
- (void)removeLearningCourses:(NSSet<ARCourse *> *)values;

- (void)addTeachingCoursesObject:(ARCourse *)value;
- (void)removeTeachingCoursesObject:(ARCourse *)value;
- (void)addTeachingCourses:(NSSet<ARCourse *> *)values;
- (void)removeTeachingCourses:(NSSet<ARCourse *> *)values;

@end

NS_ASSUME_NONNULL_END
