//
//  CommonAlertViewController.h
//  SomeUIKit
//
//  Created by WangQiang on 2016/11/2.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQAlertController;
#import "WQCommonAlertTitleView.h"
#import "WQCommonAlertBottomView.h"
#import <WQBaseUIComponents/WQControllerTransition.h>
#define AlertCenterWidth ([[UIScreen mainScreen] bounds].size.width - 50)
UIKIT_EXTERN  NSString * _Nonnull const WQActionConfirm;
UIKIT_EXTERN  NSString * _Nonnull const WQActionCancel;
typedef void(^BottomAction)( WQAlertController * _Nonnull alertController);

//TODO: 辅助创建中间视图
@interface UIView (WQAlertCenterView)
+(nonnull instancetype)centerViewWithText:(NSString *_Nonnull)text;

+(nonnull instancetype)centerViewWithText:(NSString *_Nonnull)text  edges:(UIEdgeInsets)edges;
+(nonnull instancetype)centerViewWithAttributeText:(NSAttributedString *_Nonnull)attributeText  edges:(UIEdgeInsets)edges;

/** 初始化一个输入框弹出框的中间视图 */
+(nonnull instancetype)centerTextFiledWithTip:(nullable NSString *)tipMessage
                     configurationHandler:(void (^ __nullable)(UITextField * _Nonnull textFiled))handler;
@end


@interface WQAlertController : UIViewController

/**
 构造默认的顶部、底部拦样式的弹出框
 */
+(nonnull instancetype)alertDefaultBottomWithTitle:(nonnull NSString *)title
                                        centerView:(nonnull UIView *)centerView;

+(nonnull instancetype)alertViewWithCenterView:(nonnull UIView *)centerView;

+(nonnull instancetype)alertViewWithCenterView:(nonnull UIView *)centerView
                                    bottomView:(nonnull UIView<WQAlertBottomViewProtocol> *)bottomView;
+(nonnull instancetype)alertViewWithTopView:(nullable UIView *)topView
                                 centerView:(nonnull UIView *)centerView;

/**
 自定义上下视图

 @param centerView 必须要先有尺寸 
 */
+(nonnull instancetype)alertViewWithTopView:(nullable UIView *)topView
                                 centerView:(nonnull UIView *)centerView
                                 bottomView:(nullable UIView <WQAlertBottomViewProtocol>*)bottomView;
//+(nonnull instancetype)alertViewWithTopView:(nullable UIView *)topView
//                                 centerView:(nonnull UIView *)centerView
//                                 bottomView:(nullable UIView <WQAlertBottomViewProtocol>*)bottomView
//                         containerViewWidth:(CGFloat)containerViewWith;
@property (strong ,nonatomic,nullable) UIColor *tintColor;
/**整个视图的圆角*/
@property (assign ,nonatomic) CGFloat containerViewRadius;

@property (nullable,strong ,nonatomic,readonly) UIView *titleView;
@property (strong ,nonatomic,nullable ,readonly) UIView <WQAlertBottomViewProtocol> *bottomView;

@property (strong ,nonatomic,nonnull ,readonly) UIView *topCenterView;

/**当中间点击切换的时候会有多个View*/
@property (strong ,nonatomic,nonnull ,readonly) NSMutableArray *centerViews;

/** 防止同一个类型的控件重复弹出 */
@property (copy    ,nonatomic,nullable) NSString *  preventDuplicateShowmarks;

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

@interface WQAlertController(WQDeprecated)


+(nonnull instancetype)alertWithContent:(nonnull NSString *)content
__deprecated_msg("请使用WQAlertCenterView分类创建centerView");
+(nonnull instancetype)alertWithCenterView:(nonnull UIView *)centerView __deprecated_msg("请使用WQAlertCenterView分类创建centerView");
+(nonnull instancetype)alertWithCenterView:(nonnull UIView *)centerView isNeedBottomView:(BOOL)needBottom __deprecated_msg("请使用WQAlertCenterView分类创建centerView");
+(nullable instancetype)alertWithContent:(nonnull NSString *)content
                                   title:(nullable NSString *)title __deprecated_msg("请使用分类创建centerView和TitleView");

+(nonnull instancetype)alertViewWithIcon:(nonnull NSString *)titleIcon
                              centerView:(nonnull UIView *)centerView __deprecated_msg("请使用分类创建centerView和TitleView");
+(nonnull instancetype)alertViewWithTitle:(nonnull NSString *)title
                               centerView:(nonnull UIView *)centerView __deprecated_msg("请使用分类创建centerView和TitleView");

+(nonnull instancetype)alert:(nullable NSString *)title
                   titleIcon:(nullable NSString *)titleIcon
                     content:(nonnull NSString *)content
                     confirm:( nullable NSString *)confirmTitle
                      cancel:(nullable NSString *)cancelTitle __deprecated_msg("请使用分类创建centerView和TitleView以及bottomView");

/**
 创建弹出框
 
 @param title       弹出框的标题
 @param titleIcon   弹出框的图标
 @param centerView  自定义的View
 @param confirmTitle 确定按钮标题
 @param cancelTitle 取消按钮标题
 */
+(nonnull instancetype)alertViewWithTitle:(nullable NSString *)title
                                titleIcon:(nullable NSString *)titleIcon
                               centerView:(nonnull UIView *)centerView
                             confirmTitle:( nullable NSString *)confirmTitle
                              cancelTitle:(nullable NSString *)cancelTitle __deprecated_msg("请使用分类创建centerView和TitleView以及bottomView");
@end
