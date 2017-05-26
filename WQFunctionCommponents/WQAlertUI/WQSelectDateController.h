//
//  WQSelectDateController.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WQSelectDateController;

typedef NS_ENUM(NSInteger,WQCustomDateMode) {
    WQCustomDateNone,//非自定义日期控件
    WQCustomDateYearAndMonth,
};
typedef void(^_Nullable ConfirmDate)(WQSelectDateController * _Nonnull dateController,NSDate * _Nonnull date);
typedef void(^_Nullable ChangeDate)( NSDate * _Nullable date);
typedef void(^_Nullable CancelDate)(WQSelectDateController * _Nonnull dateController);

@interface WQSelectDateController : UIViewController
@property (assign ,nonatomic,readonly) UIAlertControllerStyle alertControllerStyle;
/** 允许最大的选择日期 */
@property (strong ,nonatomic,nullable) NSDate *maximumDate;
/** 允许最小的选择日期 */
@property (nullable, nonatomic, strong) NSDate *minimumDate;
/** 外部设置 选中当前日期 设定此项之前 需先设置maximumDate和 minimumDate*/
@property (strong ,nonatomic,nullable) NSDate *date;

@property (strong ,nonatomic,readonly,nullable) UIDatePicker *datePicker;
+(nonnull instancetype)dateWithTitle:(nullable NSString *)title
                          alertStyle:(UIAlertControllerStyle)alertStyle
                       dateDidChange:(ChangeDate)didChange
                     confirmSelected:(ConfirmDate)confirmDate
                      cancelSelected:(CancelDate)cancelDate;

/** 自定义日期选择控件 */
@property (strong ,nonatomic,readonly,nullable) UIPickerView   *customDatePicker;
+(nonnull instancetype)customDateWithTitle:(nullable NSString *)title
                          alertStyle:(UIAlertControllerStyle)alertStyle
                       dateDidChange:(ChangeDate)didChange
                     confirmSelected:(ConfirmDate)confirmDate
                      cancelSelected:(CancelDate)cancelDate;
/** 自定义日期控件对应的时间单元的单位 */
@property (nullable,strong ,nonatomic) NSArray *units;

@property (assign ,nonatomic) BOOL enableTapGR;
-(void)showInController:(nullable UIViewController *)viewController;
@end
