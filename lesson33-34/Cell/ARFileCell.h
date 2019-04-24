//
//  ARFileCell.h
//  Lesson33Task
//
//  Created by Анастасия Распутняк on 23.04.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARFileCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;
@property (weak, nonatomic) IBOutlet UILabel *sizeOfFile;

@end

NS_ASSUME_NONNULL_END
