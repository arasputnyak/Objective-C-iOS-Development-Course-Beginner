//
//  ARStudent.m
//  Lesson40Task
//
//  Created by Анастасия Распутняк on 12.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARStudent.h"

@implementation ARStudent

- (void)resetProperties {
    [self willChangeValueForKey:@"firstName"];
    _firstName = @"";
    [self didChangeValueForKey:@"firstName"];
    
    
    [self willChangeValueForKey:@"lastName"];
    _lastName = @"";
    [self didChangeValueForKey:@"lastName"];
    
    [self willChangeValueForKey:@"grade"];
    _grade = 0;
    [self didChangeValueForKey:@"grade"];
}

- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKey:(NSString *)inKey error:(out NSError * _Nullable __autoreleasing *)outError {
    if ([inKey isEqualToString:@"firstName"] || [inKey isEqualToString:@"lastName"]) {
        
        if (![*ioValue isKindOfClass:[NSString class]]) {
            
            *outError = [[NSError alloc] initWithDomain:@"Not NSString."
                                                   code:000
                                               userInfo:nil];
            return NO;
            
        } else {
            NSString* name = *ioValue;
            
            NSCharacterSet* validationSet = [[NSCharacterSet letterCharacterSet] invertedSet];
            NSArray* components = [name componentsSeparatedByCharactersInSet:validationSet];
            
            if ([components count] > 1) {
                
                *outError = [[NSError alloc] initWithDomain:@"Contains invalid characters."
                                                       code:111
                                                   userInfo:nil];
                return NO;
            }
        }
    } else {
        if (![*ioValue isKindOfClass:[NSNumber class]]) {
            
            *outError = [[NSError alloc] initWithDomain:@"Not a number."
                                                   code:333
                                               userInfo:nil];
            return NO;
        } else {
            if ([*ioValue integerValue] == 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

//- (BOOL)validateValue:(inout id  _Nullable __autoreleasing *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError * _Nullable __autoreleasing *)outError {
//
//}

@end
