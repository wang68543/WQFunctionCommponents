//
//  SelectTimeView.h
//  YunShouHu
//
//  Created by WangQiang on 16/4/20.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQSelecOptionsView;
typedef NS_ENUM(NSInteger,ShowPostion) {
    ShowPostionDefault,
    ShowPostionUp,
    ShowPostionDown,
};
@interface WQSelecOptionsView : UIView
@property (strong ,nonatomic) NSArray <NSString *>*datas;
/**
 *  显示在某一个控件的底部
 *
 *  @param rect 区域
 */
-(void)showWithRect:(CGRect)rect;

-(void)showWithRect:(CGRect)rect position:(ShowPostion)position;
/**
 *  根据相关联的View进行显示(默认控件等宽、颜色相同)
 */
-(void)showWithView:(UIView *)view;
-(void)hide;
-(void)hideWithCompeletion:(void(^)())compeletion;
@property (assign ,nonatomic,readonly,getter=isShowing) BOOL showing;
/**
 *  tableView的cell高度
 */
@property (assign ,nonatomic) CGFloat cellHeight;
/**
 *  文字的颜色
 */
@property (strong ,nonatomic) UIColor *textColor;
/**
 *  tableView距离顶部的最小距离
 */
@property (assign ,nonatomic) CGFloat topInset;
/**
 *  tableView距离底部的最小距离
 */
@property (assign ,nonatomic) CGFloat bottomInset;

/**
 tableView的边框的颜色
 */
@property (strong ,nonatomic) UIColor *tableViewBorder;

/**
 当前正显示在控件的标题在数据源中的数据(然后展示的时候排除)
 */
@property (copy ,nonatomic) NSString *expectData;


/**选项的字体*/
@property (strong ,nonatomic) UIFont *labelFont;
/**文字排列方向(控件自身长度过长的时候才起作用)*/
@property (assign ,nonatomic) NSTextAlignment textAlignment;

/**
 初始的时候需要选中的字符串
 */
@property (copy ,nonatomic) NSString *selectedData;
/**
 *  回调选中的路径
 */
@property (copy ,nonatomic) void (^didSelectedCompeletionIndexPath)(BOOL success,NSIndexPath * indexPath);
/**
 *  设置tableView的背景颜色
 */
-(void)setTableViewBackGround:(UIColor *)backColor;
/**
 *  初始的时候选中某行
 */
//-(void)setSelectedData:(NSString *)data;
@end
