//
//  ARStudentInfoTVController.m
//  Lesson37Task
//
//  Created by Анастасия Распутняк on 08.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARStudentInfoTVController.h"

@interface ARStudentInfoTVController ()

@end

@implementation ARStudentInfoTVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(340, 240);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.delegate insertStudentInfo:self];
}


@end
