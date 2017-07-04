//
//  WQCustomSelectDateView.h
//  WQFunctionDemo
//
//  Created by WangQiang on 2017/6/10.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WQCustomDateMode) {
    WQCustomDateNone,//非自定义日期控件
    WQCustomDateYearAndMonth,
    WQCustomDateDoubleHourAndMinutes,//双时间与秒
};
@class WQCustomSelectDateView;
@protocol WQCustomSelectDateViewDelegate  <NSObject>
@optional
-(void)customDateView:(WQCustomSelectDateView *)dateView didChangeDate:(NSDate *)date;
-(void)customDateView:(WQCustomSelectDateView *)dateView didChangeSecondDate:(NSDate *)secondDate;
@end
@interface WQCustomSelectDateView : UIView

@property (assign ,nonatomic) WQCustomDateMode customDateMode;

@property (weak ,nonatomic) id<WQCustomSelectDateViewDelegate> delegate;
@property (strong ,nonatomic) NSArray *customUnits;
/** 允许最大的选择日期 */
@property (strong ,nonatomic) NSDate *maximumDate;
/** 允许最小的选择日期 */
@property (nonatomic, strong) NSDate *minimumDate;

@property (strong ,nonatomic) NSDate *date;

@property (strong ,nonatomic,readonly) UILabel *startTip;
@property (strong ,nonatomic,readonly) UILabel *endTip;
@property (strong ,nonatomic,readonly) UIView *midLineView;
@property (strong ,nonatomic) NSDate *secondDate;


@end
