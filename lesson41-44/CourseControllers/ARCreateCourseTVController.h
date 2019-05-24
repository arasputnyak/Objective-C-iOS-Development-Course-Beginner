//
//  ARCreateCourseTVController.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 22.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../Models/ARCourse+CoreDataClass.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    ARCourseControllerTypeCreate,
    ARCourseControllerTypeEdit
} ARCourseControllerType;

@interface ARCreateCourseTVController : UITableViewController

@property (assign, nonatomic) ARCourseControllerType controllerType;
@property (strong, nonatomic) ARCourse* editingCourse;
@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

NS_ASSUME_NONNULL_END
