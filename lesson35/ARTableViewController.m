//
//  ARTableViewController.m
//  Lesson35Task
//
//  Created by Анастасия Распутняк on 24.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARTableViewController.h"
#import "ARStudent.h"
#import "ARSection.h"

typedef enum {
    ARConrolValueMonth,
    ARConrolValueFirstName,
    ARConrolValueLastName
} ARConrolValue;

@interface ARTableViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (strong, nonatomic) NSMutableArray* students;
@property (strong, nonatomic) NSArray* sections;
@property (strong, nonatomic) NSDictionary* months;
@end

@implementation ARTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.months = @{@"1":@"January",
                    @"2":@"February",
                    @"3":@"March",
                    @"4":@"April",
                    @"5":@"May",
                    @"6":@"June",
                    @"7":@"July",
                    @"8":@"August",
                    @"9":@"September",
                   @"10":@"October",
                   @"11":@"November",
                   @"12":@"December"
                    };
    
    self.students = [NSMutableArray array];
    for (int i = 0; i < 100; i++) {
        [self.students addObject:[ARStudent randomStudent]];
    }
    
    [self sortStudentsByMonth:self.students];
    
    self.sections = [self generateSectionsFromArray:self.students byProperty:ARConrolValueMonth withFilter:self.searchBar.text];
    for (ARSection* section in self.sections) {
        [self sortStudentsByProperties:section.sectionMembers firstNameFirst:NO];
    }
}

#pragma mark - Actions -

- (IBAction)actionControlChanged:(UISegmentedControl *)sender {
    
    [self reloadDataWithControl:sender.selectedSegmentIndex
                       andArray:self.students];
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sections count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    ARSection* sect = [self.sections objectAtIndex:section];

    return sect.sectionName;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray* titles = [NSMutableArray array];
    
    if (self.sortControl.selectedSegmentIndex == ARConrolValueMonth) {
        for (ARSection* section in self.sections) {
            [titles addObject:[section.sectionName substringToIndex:1]];
        }
    } else {
        for (ARSection* section in self.sections) {
            [titles addObject:section.sectionName];
        }
    }
    
    return titles;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    ARSection* sect = [self.sections objectAtIndex:section];
    return [sect.sectionMembers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:identifier];
    }
    
    ARSection* sect = [self.sections objectAtIndex:indexPath.section];
    ARStudent* student = [sect.sectionMembers objectAtIndex:indexPath.row];
    
    NSInteger searchTextLength = [self.searchBar.text length];
    NSString* studentFullName = [NSString stringWithFormat:@"%@ %@", student.firstName, student.lastName];
    NSMutableAttributedString* stringNameAttr = [[NSMutableAttributedString alloc] initWithString:studentFullName];
    
    if (searchTextLength > 0) {
        NSString* searchText = self.searchBar.text;
        NSRange highLightAt = [studentFullName rangeOfString:searchText];
        NSRange space = [studentFullName rangeOfString:@" "];
        if (highLightAt.location == 0 || highLightAt.location == space.location + 1) {
            
            [stringNameAttr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:highLightAt];
            cell.textLabel.attributedText = stringNameAttr;
        }
    } else {
        cell.textLabel.attributedText = stringNameAttr;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString* dateString = [formatter stringFromDate:student.birthDate];
    
    cell.detailTextLabel.text = dateString;
    
    return cell;
}

#pragma mark - UISearchBarDelegate -

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES
                           animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO
                           animated:YES];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar setText:@""];
    [searchBar endEditing:YES];
    
    [self reloadDataWithControl:self.sortControl.selectedSegmentIndex
                       andArray:self.students];
    
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self reloadDataWithControl:self.sortControl.selectedSegmentIndex
                       andArray:self.students];
    
    [self.tableView reloadData];
}

#pragma mark - Additional methods -

- (NSInteger)getMonthFromDate:(NSDate*)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                                                   fromDate:date];
    
    return [components month];
}

- (NSArray*)generateSectionsFromArray:(NSArray*)array byProperty:(NSInteger)property withFilter:(NSString*)filter  {
    NSMutableArray* sectionsArray = [NSMutableArray array];
    
    if (property == ARConrolValueMonth) {
        NSInteger currentMonth = 0;
        
        for (ARStudent* student in array) {
            if ([filter length] > 0 &&
                [student.firstName rangeOfString:filter].location != 0 &&
                [student.lastName rangeOfString:filter].location != 0) {
                    continue;
                }
            
            ARSection* section = nil;
            
            NSDateComponents* components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                                                           fromDate:student.birthDate];
            NSInteger birthMonth = [components month];
            
            if (currentMonth != birthMonth) {
                currentMonth = birthMonth;
                
                section = [[ARSection alloc] init];
                
                NSString* stringMoth = [NSString stringWithFormat:@"%ld", (long)birthMonth];
                
                section.sectionName = [self.months objectForKey:stringMoth];
                
                section.sectionMembers = [NSMutableArray array];
                [sectionsArray addObject:section];
            } else {
                section = [sectionsArray lastObject];
            }
            
            [section.sectionMembers addObject:student];
        }
    } else {
        NSString* currentLetter = nil;
        
        for (ARStudent* student in array) {
            if ([filter length] > 0 &&
                [student.firstName rangeOfString:filter].location != 0 &&
                [student.lastName rangeOfString:filter].location != 0) {
                    continue;
                }
            
            ARSection* section = nil;
            
            NSString* firstLetter = property == ARConrolValueFirstName ? [student.firstName substringToIndex:1] : [student.lastName substringToIndex:1];
            
            if (![currentLetter isEqualToString:firstLetter]) {
                currentLetter = firstLetter;
                
                section = [[ARSection alloc] init];
                section.sectionName = firstLetter;
                section.sectionMembers = [NSMutableArray array];
                
                [sectionsArray addObject:section];
            } else {
                section = [sectionsArray lastObject];
            }
            
            [section.sectionMembers addObject:student];
        }
    }
    
    return sectionsArray;
}

- (void)sortStudentsByProperties:(NSMutableArray*)students firstNameFirst:(BOOL)f {
    NSSortDescriptor* descrFN = [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                                            ascending:YES];
    NSSortDescriptor* descrLN = [[NSSortDescriptor alloc] initWithKey:@"lastName"
                                                            ascending:YES];
    NSSortDescriptor* descrDt = [[NSSortDescriptor alloc] initWithKey:@"birthDate"
                                                            ascending:YES];
    if (f) {
        [students sortUsingDescriptors:@[descrFN, descrLN, descrDt]];
    } else {
        [students sortUsingDescriptors:@[descrLN, descrFN, descrDt]];
    }
}

- (void)sortStudentsByMonth:(NSMutableArray*)students {
    [students sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSInteger first = [self getMonthFromDate:[(ARStudent*)obj1 birthDate]];
        NSInteger second = [self getMonthFromDate:[(ARStudent*)obj2 birthDate]];
        
        return first > second;
    }];
}

- (void)reloadDataWithControl:(NSInteger)controlIndex andArray:(NSMutableArray*)array {
    switch (controlIndex) {
        case ARConrolValueMonth:
            [self sortStudentsByMonth:array];
            self.sections = [self generateSectionsFromArray:array
                                                 byProperty:ARConrolValueMonth
                                                 withFilter:self.searchBar.text];
            for (ARSection* section in self.sections) {
                [self sortStudentsByProperties:section.sectionMembers firstNameFirst:NO];
            }
            break;
            
        case ARConrolValueFirstName:
            [self sortStudentsByProperties:array firstNameFirst:YES];
            self.sections = [self generateSectionsFromArray:array
                                                 byProperty:ARConrolValueFirstName
                                                 withFilter:self.searchBar.text];
            break;
            
        case ARConrolValueLastName:
            [self sortStudentsByProperties:array firstNameFirst:NO];
            self.sections = [self generateSectionsFromArray:array
                                                 byProperty:ARConrolValueLastName
                                                 withFilter:self.searchBar.text];
            break;
            
        default:
            break;
    }
}


@end
