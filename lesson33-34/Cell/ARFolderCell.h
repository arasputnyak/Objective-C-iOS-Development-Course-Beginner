//
//  ARFolderCell.h
//  Lesson33Task
//
//  Created by Анастасия Распутняк on 23.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARFolderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *folderName;
@property (weak, nonatomic) IBOutlet UILabel *quantityOfFiles;
@property (weak, nonatomic) IBOutlet UILabel *sizeOfFolder;


@end

NS_ASSUME_NONNULL_END
