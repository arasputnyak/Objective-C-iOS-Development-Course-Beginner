//
//  ARTableViewController.m
//  Lesson33Task
//
//  Created by Анастасия Распутняк on 22.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARTableViewController.h"
#import "Cell/ARFolderCell.h"
#import "Cell/ARFileCell.h"

@interface ARTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* folders;
@property (strong, nonatomic) NSMutableArray* files;
@end

@implementation ARTableViewController

- (id)initWithFolderPath:(NSString*)path {
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self) {
        self.path = path;
    }
    
    return self;
    
}

- (void)setPath:(NSString *)path {
    _path = path;
    
    NSDictionary* contents = [self devideContentAtPath:path];
    self.folders = [contents objectForKey:@"folders"];
    self.files = [contents objectForKey:@"files"];
    
    [self.folders sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [self.files sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [self.tableView reloadData];
    self.navigationItem.title = [self.path lastPathComponent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.path) {
        self.path = @"/Users/nastushka/Downloads";
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.tableView reloadData];
    
    if ([self.navigationController.viewControllers count] > 2) {
        UIBarButtonItem* backToRoot = [[UIBarButtonItem alloc] initWithTitle:@"Downloads"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(actionBackToRoot:)];
        self.navigationItem.rightBarButtonItem = backToRoot;
    };
    
}

#pragma mark - Actions -

- (void)actionBackToRoot:(UIBarButtonItem*)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark - UITableViewDataSource -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;  // folders/files
    
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return @"Folders";
    } else {
        return @"Files";
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.folders count] + 1;
    } else {
        return [self.files count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* folderIdentifier = @"folderCell";
    static NSString* fileIdentifier = @"fileCell";
    static NSString* addIdentifier = @"add";
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:addIdentifier];
            }

            cell.textLabel.text = @"Add new folder";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:10 / 255.f green:132 / 255.f blue:255 / 255.f alpha:1.f];

            return cell;

        } else {
            
            ARFolderCell* cell = [tableView dequeueReusableCellWithIdentifier:folderIdentifier];
            
            NSString* pathToFolder = [self.path stringByAppendingPathComponent:[self.folders objectAtIndex:indexPath.row - 1]];
        
            cell.folderName.text = [self.folders objectAtIndex:indexPath.row - 1];
            
            NSDictionary* content = [self devideContentAtPath:pathToFolder];
            NSInteger count = [[content objectForKey:@"folders"] count] + [[content objectForKey:@"files"] count];
            cell.quantityOfFiles.text = [NSString stringWithFormat:@"%lu", count];
            cell.sizeOfFolder.text = [self fileSizeFromValue:[self sizeOfFolderAtPath:pathToFolder]];
            
            return cell;
        }
        
    } else {
        if (indexPath.row == 0) {
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:addIdentifier];

            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:addIdentifier];
            }

            cell.textLabel.text = @"Add new file";
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:10 / 255.f green:132 / 255.f blue:255 / 255.f alpha:1.f];

            return cell;

        } else {
            
            ARFileCell* cell = [tableView dequeueReusableCellWithIdentifier:fileIdentifier];
            
            NSString* pathToFile = [self.path stringByAppendingPathComponent:[self.files objectAtIndex:indexPath.row - 1]];
            NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:pathToFile
                                                                                            error:nil];
            
            cell.fileName.text = [self.files objectAtIndex:indexPath.row - 1];
            cell.creationDate.text = [self formatStringFromDate:[fileAttributes fileCreationDate]];
            cell.sizeOfFile.text = [self fileSizeFromValue:[fileAttributes fileSize]];
            
            return cell;
        }
        
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row != 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            [self deleteItemFromArray:self.folders
                          atIndexPath:indexPath];
        } else {
            [self deleteItemFromArray:self.files
                          atIndexPath:indexPath];
        }
    }
}

#pragma mark - UITableViewDelegate -

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0 || indexPath.row == 0);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [self alertForAddingNewItem:@"folder" inSection:0];

        } else {
            NSString* folderPath = [self.path stringByAppendingPathComponent:[self.folders objectAtIndex:indexPath.row - 1]];
            
            ARTableViewController* newViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ARTableViewController"];
            newViewController.path = folderPath;
            
            [self.navigationController pushViewController:newViewController
                                                 animated:YES];
        }
        
    } else if (indexPath.row == 0) {
        
        [self alertForAddingNewItem:@"file" inSection:1];

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row != 0) {
        return 60.f;
    } else {
        return 44.f;
    }
    
}

#pragma mark - Additional methods -

- (BOOL)isDirectoryWithName:(NSString*)fileName andPath:(NSString*)filePath {
    BOOL isDirectory = NO;
    
    [[NSFileManager defaultManager] fileExistsAtPath:[filePath stringByAppendingPathComponent:fileName]
                                         isDirectory:&isDirectory];
    
    return isDirectory;
}

- (NSString*)fileSizeFromValue:(unsigned long long)size {
    static NSString* units[] = {@"B", @"kB", @"mB", @"gB", @"tB"};
    static int unitCount = 5;
    
    int index = 0;
    double fileSize = (double)size;
    
    while (fileSize > 1024 && index < unitCount) {
        fileSize /= 1024;
        index++;
    }
    
    return [NSString stringWithFormat:@"%.2f %@", fileSize, units[index]];
}

- (NSString*)formatStringFromDate:(NSDate*)date {
    static NSDateFormatter* dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    }
    
    return [dateFormatter stringFromDate:date];
}

- (unsigned long long)sizeOfFiles:(NSMutableArray*)files atPath:(NSString*)path {
    unsigned long long size = 0;
    for (NSString* file in files) {
        NSDictionary* fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file]
                                                                                        error:nil];
        size += [fileAttributes fileSize];
    }
    
    return size;
}

- (unsigned long long)sizeOfFolderAtPath:(NSString*)path {
    unsigned long long size = 0;
    
    NSDictionary* contents = [self devideContentAtPath:path];
    
    NSMutableArray* folders = [contents objectForKey:@"folders"];
    NSMutableArray* files = [contents objectForKey:@"files"];
    
    unsigned long long filesSize = [self sizeOfFiles:files
                                              atPath:path];
    
    if ([folders count] > 0) {
        for (NSString* folder in folders) {
            size += [self sizeOfFolderAtPath:[path stringByAppendingPathComponent:folder]] + filesSize;
        }
    } else {
        return filesSize;
    }
    
    return size;
}

- (NSDictionary*)devideContentAtPath:(NSString*)path {NSError* error = nil;
    NSArray* contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path
                                                                           error:&error];
    if (error) NSLog(@"Error: %@", [error localizedDescription]);
    
    NSMutableArray* folders = [NSMutableArray array];
    NSMutableArray* files = [NSMutableArray array];
    
    for (NSString* content in contents) {
        if (![self isHidden:content]) {
            if ([self isDirectoryWithName:content andPath:path]) {
                [folders addObject:content];
            } else {
                [files addObject:content];
            }
        }
    }
    
    NSDictionary* dictContent = @{@"folders": folders,
                                    @"files": files};
    
    return dictContent;
}

- (void)alertForAddingNewItem:(NSString*)item inSection:(NSInteger)section {
    __block NSString* itemName = @"";
    
    UIAlertController* addFolderAlert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Add new %@", item]
                                                                            message:[NSString stringWithFormat:@"Enter %@ name", item]
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* actionOK = [UIAlertAction actionWithTitle:@"Ok"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         itemName = addFolderAlert.textFields[0].text;
                                                         
                                                         if (section == 0) {
                                                             [self addNewFolder:itemName];
                                                         } else {
                                                             [self addNewFile:itemName];
                                                         }
                                                         
                                                         
                                                     }];
    
    UIAlertAction* actionCancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [addFolderAlert addAction:actionOK];
    [addFolderAlert addAction:actionCancel];
    
    [addFolderAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = [NSString stringWithFormat:@"%@ name", [item capitalizedString]];
    }];
    [self presentViewController:addFolderAlert animated:YES completion:nil];
}

- (void)addNewFolder:(NSString*)folderName {
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:folderName]]) {
        
        // update files ~
        if ([[NSFileManager defaultManager] createDirectoryAtPath:[self.path stringByAppendingPathComponent:folderName]
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil]) {
            
            // update model
            [self.folders addObject:folderName];
            [self.folders sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSInteger index = [self.folders indexOfObject:folderName];
            
            // update table
            [self.tableView beginUpdates];
            
            NSInteger newSectionIndex = index + 1;
            NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newSectionIndex inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.tableView endUpdates];
        }
    }
}

- (void)addNewFile:(NSString*)fileName {
    NSString* fileNameExt = [fileName stringByAppendingString:@".txt"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.path stringByAppendingPathComponent:fileNameExt]]) {
        
        // update files ~
        if ([[NSFileManager defaultManager] createFileAtPath:[self.path stringByAppendingPathComponent:fileNameExt]
                                                    contents:nil
                                                  attributes:nil]) {
            
            // update model
            [self.files addObject:fileNameExt];
            [self.files sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSInteger index = [self.files indexOfObject:fileNameExt];
            
            // update table
            [self.tableView beginUpdates];
            
            NSInteger newSectionIndex = index + 1;
            NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:newSectionIndex inSection:1];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            [self.tableView endUpdates];
        }
    }
}

- (void)deleteItemFromArray:(NSMutableArray*)items atIndexPath:(NSIndexPath*)indexPath {
    NSString* itemName = [items objectAtIndex:indexPath.row - 1];
    NSString* itemPath = [self.path stringByAppendingPathComponent:itemName];
    
    // update files ~
    if ([[NSFileManager defaultManager] removeItemAtPath:itemPath
                                                   error:nil]) {
        
        // update model
        [items removeObject:itemName];
        
        // update table
        [self.tableView beginUpdates];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationRight];
        
        [self.tableView endUpdates];
    }
}

- (BOOL)isHidden:(NSString*)item {
    if ([item characterAtIndex:0] == '.') {
        return YES;
    } else {
        return NO;
    }
}


@end
