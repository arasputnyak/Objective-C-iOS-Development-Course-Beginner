//
//  AppDelegate.m
//  Lesson40Task
//
//  Created by Анастасия Распутняк on 11.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "AppDelegate.h"
#import "ARStudent.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    ARStudent* mainStudent = [[ARStudent alloc] init];
    mainStudent.firstName = @"mainName";
    mainStudent.lastName = @"mainLastName";
    mainStudent.grade = 5;
    
    [mainStudent addObserver:self
                  forKeyPath:@"firstName"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    [mainStudent addObserver:self
                  forKeyPath:@"lastName"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    [mainStudent addObserver:self
                  forKeyPath:@"grade"
                     options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                     context:nil];
    
    ARStudent* student1 = [[ARStudent alloc] init];
    student1.firstName = @"FirstName1";
    student1.lastName = @"LastName1";
    student1.grade = 2;
    
    ARStudent* student2 = [[ARStudent alloc] init];
    student2.firstName = @"FirstName2";
    student2.lastName = @"LastName2";
    student2.grade = 3;
    
    ARStudent* student3 = [[ARStudent alloc] init];
    student3.firstName = @"FirstName3";
    student3.lastName = @"LastName3";
    student3.grade = 4;
    
    ARStudent* student4 = [[ARStudent alloc] init];
    student4.firstName = @"FirstName4";
    student4.lastName = @"LastName4";
    student4.grade = 5;
    
    ARStudent* student5 = [[ARStudent alloc] init];
    student5.firstName = @"FirstName5";
    student5.lastName = @"LastName5";
    student5.grade = 3;
    
    
    student5.bff = student4;
    student4.bff = student3;
    student3.bff = student2;
    student2.bff = student1;
    student1.bff = mainStudent;
    mainStudent.bff = student5;
    
    [student5 setValue:@"LolKek"
            forKeyPath:@"bff.bff.bff.bff.bff.firstName"];
    
    NSLog(@"name = %@", mainStudent.firstName);
    
    
    NSArray* students = @[mainStudent, student1, student2, student3, student4, student5];
    NSArray* names = [students valueForKeyPath:@"firstName"];
    NSLog(@"names = %@", names.description);
    
    NSNumber* minGrade = [students valueForKeyPath:@"@min.grade"];
    NSNumber* maxGrade = [students valueForKeyPath:@"@max.grade"];
    NSNumber* sumGrade = [students valueForKeyPath:@"@sum.grade"];
    NSNumber* avgGrade = [students valueForKeyPath:@"@avg.grade"];
    
    NSLog(@"minGrade = %d", [minGrade intValue]);
    NSLog(@"maxGrade = %d", [maxGrade intValue]);
    NSLog(@"sumGrade = %d", [sumGrade intValue]);
    NSLog(@"avgGrade = %f", [avgGrade floatValue]);
    
    
    return YES;
}


#pragma mark - Observing -

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"student changed %@", keyPath);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
