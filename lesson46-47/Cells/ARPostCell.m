//
//  ARPostCell.m
//  Lesson46Task
//
//  Created by Анастасия Распутняк on 30.05.2019.
//  Copyright © 2019 Anastasiya Rasputnyak. All rights reserved.
//

#import "ARPostCell.h"

@implementation ARPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightForText:(NSString*)text {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat offset = 15.f;
    
    UIFont* font = [UIFont systemFontOfSize:17.f];
    
    NSMutableParagraphStyle* paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentLeft;
    
    NSDictionary* attributes = @{NSFontAttributeName : font,
                                 NSParagraphStyleAttributeName : paragraph
                                 };
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width - 2 * offset, CGFLOAT_MAX)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:attributes
                                     context:nil];
    
    return CGRectGetHeight(rect);
}

+ (CGFloat)heightForPostWithPhotos:(NSString*)text {
    
    return [ARPostCell heightForText:text] + 240.f;
    
}

+ (CGFloat)heightForPostWithoutPhotos:(NSString*)text {
    
    return [ARPostCell heightForText:text] + 80.f;
    
}

+ (CGFloat)heightForComment:(NSString*)text {
    
    return [ARPostCell heightForText:text] + 60.f;
    
}
@end
