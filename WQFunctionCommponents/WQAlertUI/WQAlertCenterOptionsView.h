//
//  WQAlertCenterOptionsView.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/5.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAlertCenterOptionsView : UIView
+(instancetype)optionsView;
/** 默认rowHeight 44.0 */
@property (strong ,nonatomic,readonly) UITableView *tableView;
/** 隐藏Cell最后一个分割线 默认YES */
@property (assign  ,nonatomic) BOOL hideLastSepratorLine;
/** 注册cell  默认为UITableViewCell */
- (void)registerCell:(NSString *)clsStr isNib:(BOOL)nib;
/** 选项个数 */
@property (assign  ,nonatomic) NSUInteger optionsCount;
/** 选项数据源 */
@property (copy    ,nonatomic) UITableViewCell * (^cellForRow)(UITableViewCell *cell, NSIndexPath *indexPath);
/** 选项选中 */
@property (copy    ,nonatomic) void (^didSelectRow)(NSIndexPath *indexPath);
@end
