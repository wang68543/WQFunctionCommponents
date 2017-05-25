//
//  ShareActionCell.m
//  AirMonitor
//
//  Created by WangQiang on 16/5/22.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQShareActionCell.h"
@interface WQShareActionCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end
@implementation WQShareActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setItem:(WQShareActionItem *)item{
    _item = item;
    self.iconView.image  = [UIImage imageNamed:_item.icon];
}
@end
