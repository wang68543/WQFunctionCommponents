//
//  SelectedTimeViewCell.m
//  YunShouHu
//
//  Created by WangQiang on 16/5/6.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQSelectOptionsCell.h"

@implementation WQSelectOptionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
@end
