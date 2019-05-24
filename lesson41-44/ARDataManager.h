//
//  ARDataManager.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 18.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

+ (ARDataManager*)sharedManager;

@end

NS_ASSUME_NONNULL_END
