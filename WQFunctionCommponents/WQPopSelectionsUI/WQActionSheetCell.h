//
//  WQActionSheetCell.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/19.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQActionSheetCell : UITableViewCell
@property (strong ,nonatomic,readonly) UILabel *contentLabel;
@property (strong ,nonatomic,readonly) UIView *separatorLineView;

@end
