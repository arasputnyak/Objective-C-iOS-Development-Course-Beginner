//
//  ARAttributeCell.h
//  Lesson41Task
//
//  Created by Анастасия Распутняк on 21.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ARAttributeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *attributeLabel;
@property (weak, nonatomic) IBOutlet UITextField *attributeField;

@end

NS_ASSUME_NONNULL_END
