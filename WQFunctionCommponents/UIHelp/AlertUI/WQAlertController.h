//
//  CommonAlertViewController.h
//  SomeUIKit
//
//  Created by WangQiang on 2016/11/2.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQAlertController;
#import "WQAlertTitleViewProtocol.h"
#import "WQAlertBottomViewProtocol.h"

#import "WQControllerTransition.h"
#define AlertCenterWidth ([[UIScreen mainScreen] bounds].size.width - 50)
UIKIT_EXTERN  NSString * _Nonnull const WQActionConfirm;
UIKIT_EXTERN  NSString * _Nonnull const WQActionCancel;
typedef void(^BottomAction)( WQAlertController * _Nonnull alertController);
@interface WQAlertController : UIViewController
/**初始化一个输入框弹出框的中间视图*/
+(nonnull UIView *)centerTextFiledWithTip:(nullable NSString *)tipMessage
                     configurationHandler:(void (^ __nullable)(UITextField * _Nonnull textFiled))handler;

+(nonnull instancetype)alertWithContent:(nonnull NSString *)content;
+(nonnull instancetype)alertWithCenterView:(nonnull UIView *)centerView;
+(nonnull instancetype)alertWithCenterView:(nonnull UIView *)centerView isNeedBottomView:(BOOL)needBottom;
+(nullable instancetype)alertWithContent:(nonnull NSString *)content
                                   title:(nullable NSString *)title;

+(nonnull instancetype)alertViewWithIcon:(nonnull NSString *)titleIcon
                              centerView:(nonnull UIView *)centerView;
+(nonnull instancetype)alertViewWithTitle:(nonnull NSString *)title
                               centerView:(nonnull UIView *)centerView;
/**
 创建弹出框

 @param title       弹出框的标题
 @param titleIcon   弹出框的图标
 @param centerView  自定义的View
 @param confirmitle 确定按钮标题
 @param cancelTitle 取消按钮标题
 */
+(nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                titleIcon:(nullable NSString *)titleIcon
                               centerView:(nonnull UIView *)centerView
                             confirmTitle:( nullable NSString *)confirmitle
                              cancelTitle:(nullable NSString *)cancelTitle;

/**自定义上下视图*/
+(nonnull instancetype)alertViewWithTopView:(nullable UIView<WQAlertTitleViewProtocol> *)topView
                                 centerView:(nonnull UIView *)centerView
                                 bottomView:(nullable UIView <WQAlertBottomViewProtocol>*)bottomView;
///**中间视图的四周边距*/
//@property (assign ,nonatomic) UIEdgeInsets contentEdgeInsets;
@property (strong ,nonatomic,nullable) UIColor *tintColor;
/**整个视图的圆角*/
@property (assign ,nonatomic) CGFloat containerViewRadius;

@property (nullable,strong ,nonatomic,readonly) UIView<WQAlertTitleViewProtocol> *titleView;
@property (strong ,nonatomic,nullable ,readonly) UIView <WQAlertBottomViewProtocol> *bottomView;

@property (strong ,nonatomic,nonnull ,readonly) UIView *topCenterView;
/**当中间点击切换的时候会有多个View*/
@property (strong ,nonatomic,nonnull ,readonly) NSMutableArray *centerViews;


-(void)addActionType:(nonnull NSString *const)type action:(nonnull BottomAction)action;

/**
 中途添加中间视图

 @param centerView 需要添加的中间视图
 */
-(void)pushCenterView:(nonnull UIView *)centerView animate:(BOOL)animate;
/**
 弹出中间视图
 */
-(void)popCenterViewAnimate:(BOOL)animate;

/**
 弹框
 */
-(void)showInViewController:(nullable UIViewController *)inViewController;
/**
 弹框

 @param inViewController 在哪个控制器中显示
 @param showSubViewType 子视图出现方式
 @param animationTye 子视图动画方式
 */
-(void)showInViewController:(nullable UIViewController *)inViewController
     subViewFrameChangeType:(ShowOneSubViewType)showSubViewType
   subViewShowAnimationType:(AnimationType)animationTye;
@end
