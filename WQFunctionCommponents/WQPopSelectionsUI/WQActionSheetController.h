//
//  WQActionSheetController.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/19.
//  Copyright © 2017年 WangQiang. All rights reserved.
//  可自定义sectionHeader cell高度以及tableViewHeaderView

#import <UIKit/UIKit.h>
@class WQActionSheetController;
@protocol WQActionSheetDelegate <NSObject>

/**
 选中选项的时候回调

 @param index 选中的索引 从0开始 从上到下依次递增
 */
-(void)actionSheetController:(WQActionSheetController *)actionSheetController didSelectIndex:(NSInteger)index;
@end

@interface WQActionSheetController : UITableViewController
/** 正常的选项 */
@property (strong ,nonatomic) NSArray<NSString *> *optionas;
/** 最底部的标题 */
@property (copy ,nonatomic) NSString *bottomTitles;

/** 取消选项的字体颜色 */
@property (strong ,nonatomic) UIColor *cancelColor;
/** 正常选项的字体颜色 */
@property (strong ,nonatomic) UIColor *optionalColor;


/** 自定义头部视图 */
@property (strong ,nonatomic) UIView *headerView;

@property (weak ,nonatomic) id<WQActionSheetDelegate> delegate;
- (void)presentedInViewController:(UIViewController *)inViewController;
@end
