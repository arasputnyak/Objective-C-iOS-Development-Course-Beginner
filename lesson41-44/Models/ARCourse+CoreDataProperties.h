//
//  ARCourse+CoreDataProperties.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 21.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//
//

#import "ARCourse+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ARCourse (CoreDataProperties)

+ (NSFetchRequest<ARCourse *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *branch;
@property (nullable, nonatomic, copy) NSString *courseName;
@property (nullable, nonatomic, retain) NSSet<ARUser *> *students;
@property (nullable, nonatomic, retain) ARUser *teacher;

@end

@interface ARCourse (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(ARUser *)value;
- (void)removeStudentsObject:(ARUser *)value;
- (void)addStudents:(NSSet<ARUser *> *)values;
- (void)removeStudents:(NSSet<ARUser *> *)values;

@end

NS_ASSUME_NONNULL_END
