//
//  WQCommonAlertTitleView.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "WQAlertTitleViewProtocol.h"
////<WQAlertTitleViewProtocol>

#define kAlertTitleViewH 49.0
@interface WQCommonAlertTitleView : UIView
@property (copy ,nonatomic,nullable) NSString *title;
@property (strong ,nonatomic,nullable) UIImage *titleIcon;
@property (nullable,strong ,nonatomic) NSDictionary * titleAttribute;
+(nonnull instancetype)commonTitle:(nonnull NSString *)title;
+(nonnull instancetype)commonTitle:(nonnull NSString *)title icon:(nullable UIImage *)titleIcon;

-(nonnull instancetype)initWithTitle:(nullable NSString *)title icon:(nullable UIImage *)titleIcon;
@end
