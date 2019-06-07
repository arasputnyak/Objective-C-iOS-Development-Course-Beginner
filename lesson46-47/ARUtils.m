//
//  ARUtils.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 31.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARUtils.h"

NSString* dateToString(NSDate* date) {
    static NSDateFormatter* formatter = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"hh:mm dd.MM.YYYY"];
    }
    
    return [formatter stringFromDate:date];
    
}
