//
//  ARVideoCell.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 04.06.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARVideoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoViewsLabel;

@end

NS_ASSUME_NONNULL_END
