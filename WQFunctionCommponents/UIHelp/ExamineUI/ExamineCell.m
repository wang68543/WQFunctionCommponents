//
//  ExamineCell.m
//  Guardian
//
//  Created by WangQiang on 16/8/9.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "ExamineCell.h"
@interface ExamineCell()
@property (weak ,nonatomic)IBOutlet UIImageView *selectedIcon;

@end
@implementation ExamineCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if(selected){
        self.selectedIcon.image = [UIImage imageNamed:@"check_icon"];
    }else{
        self.selectedIcon.image = [UIImage imageNamed:@"cus_check_off"];
    }
}

@end
