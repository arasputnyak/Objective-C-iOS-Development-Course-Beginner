//
//  ARPostCell.h
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *authorImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorTextLabel;

+ (CGFloat)heightForPostWithPhotos:(NSString*)text;
+ (CGFloat)heightForPostWithoutPhotos:(NSString*)text;
+ (CGFloat)heightForComment:(NSString*)text;

@end

NS_ASSUME_NONNULL_END
