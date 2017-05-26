//
//  WQAlertTitleViewProtocol.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#ifndef WQAlertTitleViewProtocol_h
#define WQAlertTitleViewProtocol_h
@protocol WQAlertTitleViewProtocol <NSObject>
@property (nullable,copy ,nonatomic) NSString *title;
@property (nullable,strong ,nonatomic) UIImage *titleIcon;
-(CGFloat)heightForView;
+(nonnull instancetype)titleViewWithTitle:(nullable NSString *)title icon:(nullable UIImage *)titleIcon;
@optional
/**文字属性*/
@property (nullable,strong ,nonatomic) NSDictionary * titleAttribute;
-(nonnull instancetype)initWithTitle:(nullable NSString *)title icon:(nullable UIImage *)titleIcon;
@end

#endif /* WQAlertTitleViewProtocol_h */
