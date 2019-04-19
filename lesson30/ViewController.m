//
//  ViewController.m
//  Lesson30Task1
//
//  Created by Анастасия Распутняк on 18.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ViewController.h"
#import "ARStudent.h"
#import "ARColor.h"

@interface ViewController ()
@property (strong, nonatomic) NSArray* sections;

@property (strong, nonatomic) NSMutableArray* bestStudents;
@property (strong, nonatomic) NSMutableArray* goodStudents;
@property (strong, nonatomic) NSMutableArray* badStudents;
@property (strong, nonatomic) NSMutableArray* worstStudents;

@property (strong, nonatomic) NSArray* allStudents;
@property (strong, nonatomic) NSMutableArray* colors;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    srand48(time(0));
    self.sections = @[@"Best students", @"Good students", @"Bad students", @"Worst students"];
    self.bestStudents = [[NSMutableArray alloc] init];
    self.goodStudents = [[NSMutableArray alloc] init];
    self.badStudents = [[NSMutableArray alloc] init];
    self.worstStudents = [[NSMutableArray alloc] init];
    self.colors = [[NSMutableArray alloc] init];
    
    NSArray* names = @[@"Khloe", @"Kourtney", @"Kim", @"Kendall", @"Kylie", @"Gigi", @"Bella"];
    NSArray* lastNames = @[@"Kardashian", @"Jenner", @"Hadid", @"West"];
    
    for (int i = 0; i < 30; i++) {
        NSString* someName = [names objectAtIndex:arc4random() % [names count]];
        NSString* someLastName = [lastNames objectAtIndex:arc4random() % [lastNames count]];
        CGFloat r = drand48() * 3 + 2;
        CGFloat someMark = ceilf(r * 10) / 10; // - rounded-up
        
        ARStudent* someStudent = [[ARStudent alloc] initWithFirstName:someName
                                                             lastName:someLastName
                                                       andAverageMark:someMark];
        
        switch (someStudent.rate) {
            case ARStudentMarkTypeBest:
                [self.bestStudents addObject:someStudent];
                break;
                
            case ARStudentMarkTypeGood:
                [self.goodStudents addObject:someStudent];
                break;
                
            case ARStudentMarkTypeBad:
                [self.badStudents addObject:someStudent];
                break;
                
            case ARStudentMarkTypeWorst:
                [self.worstStudents addObject:someStudent];
                break;
                
            default:
                break;
        }
    }
    
    NSComparisonResult (^comparisonBlock)(id  _Nonnull, id  _Nonnull) = ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        ARStudent* student1 = (ARStudent*)obj1;
        ARStudent* student2 = (ARStudent*)obj2;
        
        if (student1.averageMark > student2.averageMark) {
            return  NSOrderedAscending;
        } else if (student1.averageMark < student2.averageMark) {
            return NSOrderedDescending;
        } else {
            return [student1.lastName compare:student2.lastName];
        }
        
        return  NSOrderedSame;
    };
    
    [self.bestStudents sortUsingComparator:comparisonBlock];
    [self.goodStudents sortUsingComparator:comparisonBlock];
    [self.badStudents sortUsingComparator:comparisonBlock];
    [self.worstStudents sortUsingComparator:comparisonBlock];
    
    self.allStudents = @[self.bestStudents, self.goodStudents, self.badStudents, self.worstStudents];
    
    for (int i = 0; i < 30; i++) {
        [self.colors addObject:[[ARColor alloc] initColor]];
    }
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count] + 1;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == tableView.numberOfSections - 1) return @"Colors";
    return  [self.sections objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case ARStudentMarkTypeBest:
            return [self.bestStudents count];
            
        case ARStudentMarkTypeGood:
            return [self.goodStudents count];
            
        case ARStudentMarkTypeBad:
            return [self.badStudents count];
            
        case ARStudentMarkTypeWorst:
            return [self.worstStudents count];
            
        default:
            break;
    }
    
    return [self.colors count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* studentIdentifier = @"student";
    static NSString* colorIdentifier = @"color";
    
    NSString* identifier = indexPath.section == tableView.numberOfSections - 1 ? colorIdentifier : studentIdentifier;
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }

    if ([identifier isEqualToString:studentIdentifier]) {
        ARStudent* student = [[self.allStudents objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
        if (student.rate == ARStudentMarkTypeBad || student.rate == ARStudentMarkTypeWorst) cell.textLabel.textColor = [UIColor redColor];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.1f", student.averageMark];
    } else {
        ARColor* colorObject = [self.colors objectAtIndex:indexPath.row];
        cell.textLabel.text = colorObject.colorName;
        cell.backgroundColor = colorObject.color;
    }
    
    return cell;
}



@end
