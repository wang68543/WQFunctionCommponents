//
//  WQActionSheetCell.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/19.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQActionSheetCell.h"

@implementation WQActionSheetCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *contentLabel = [[UILabel alloc] init];
        contentLabel.font = [UIFont systemFontOfSize:18.0];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel = contentLabel;
        [self.contentView addSubview:contentLabel];
        
        UIView *separatorLineView = [[UIView alloc] init];
        separatorLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _separatorLineView = separatorLineView;
        [self.contentView addSubview:separatorLineView];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(!self.separatorLineView.isHidden){
        CGFloat cellW = CGRectGetWidth(self.frame);
        CGFloat cellH = CGRectGetHeight(self.frame);
        self.contentLabel.frame = CGRectMake(0, 0, cellW, cellH - 1.0);
        self.separatorLineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), cellW, 1.0);
    }else{
        self.contentLabel.frame = self.bounds;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
