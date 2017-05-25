//
//  APPHELP.h
//  Guardian
//
//  Created by WangQiang on 16/8/29.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface WQAPPHELP : NSObject
+ (instancetype)sharedAPP;
/**
 *  打开网页
 *
 *  @param nav   在哪个导航控制器里面打开
 *  @param url   网址
 *  @param title 导航标题
 */
+(void)openBroserWithRoute:(UINavigationController *)nav
                       url:(NSString *)url title:(NSString *)title ;
/**
 *  拨打电话
 */
+(void)callNumber:(NSString *)phoneNumber;
/** 获取View所在的控制器 */
-(UIViewController*)viewController:(UIView *)view;
/**
 获取当前正在显示的控制器
 */
+ (UIViewController*)visibleViewController;
/**
 获取正在显示的导航控制器
 */
+(UINavigationController *)currentNavgationController;
/** 用运行时给某个对象赋值 */
+(void)setPropertyValue:(id)instance values:(NSDictionary *)values;
/** push到指定的控制器 */
+ (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav;

/** 查找一个View中所有的输入框 */
+(NSArray<UIView<UITextInput> *> *)deepInputTextViews:(UIView *)view;
@end
