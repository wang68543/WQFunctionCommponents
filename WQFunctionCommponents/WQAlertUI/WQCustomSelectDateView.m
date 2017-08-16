//
//  WQCustomSelectDateView.m
//  WQFunctionDemo
//
//  Created by WangQiang on 2017/6/10.
//  Copyright © 2017年 WQMapKit. All rights reserved.
//

#import "WQCustomSelectDateView.h"

static NSInteger const kUnits = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute;

@interface WQCustomSelectDateView()<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>

@property (strong ,nonatomic) UIPickerView *customDatePicker;

/** 对应date属性的Compments */
@property (strong ,nonatomic) NSDateComponents *dateCompments;
/** 用于控制自定义日期控件的选择区间 */
@property (strong ,nonatomic) NSDateComponents *maxDateCompments;
@property (strong ,nonatomic) NSDateComponents *minDateCompments;


@property (strong ,nonatomic) NSCalendar *currentClendar;


@property (strong ,nonatomic) UIView *doubleDateTipView;

@end
@implementation WQCustomSelectDateView
-(NSCalendar *)currentClendar{
    if(!_currentClendar){
        _currentClendar = [NSCalendar currentCalendar];
    }
    return _currentClendar;
}
@synthesize maximumDate = _maximumDate;
@synthesize minimumDate = _minimumDate;
-(void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    _maxDateCompments = [self.currentClendar components:kUnits fromDate:maximumDate];
    [self.customDatePicker reloadAllComponents];
    
}
-(void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    _minDateCompments = [self.currentClendar components:kUnits fromDate:_minimumDate];
    [self.customDatePicker reloadAllComponents];
    
}
-(NSDateComponents *)minDateCompments{
    if(!_minDateCompments){
        _minDateCompments  = [[NSDateComponents alloc] init];
        _minDateCompments.year = 1900;
        _minDateCompments.month = 1;
        _minDateCompments.day = 1;
        _minDateCompments.hour = 0;
        _minDateCompments.minute = 0;
        _minDateCompments.second = 0;
    }
    return _minDateCompments;
}
-(NSDateComponents *)maxDateCompments{
    if(!_maxDateCompments){
        _maxDateCompments  = [[NSDateComponents alloc] init];
        _maxDateCompments.year =  self.dateCompments.year + 100;
        _maxDateCompments.month = 1;
        _maxDateCompments.day = 1;
        _maxDateCompments.hour = 0;
        _maxDateCompments.minute = 0;
        _maxDateCompments.second = 0;
    }
    return _maxDateCompments;
}
-(NSDateComponents *)dateCompments{
    if(!_dateCompments){
        _dateCompments = [self.currentClendar components:kUnits fromDate:[NSDate date]];
    }
    return _dateCompments;
}

@synthesize date = _date;
-(void)setDate:(NSDate *)date{
    _date = date;
    _dateCompments = [self.currentClendar components:kUnits fromDate:date];
    switch (_customDateMode) {
        case WQCustomDateYearAndMonth:
        {
          
            NSDate * minDate = [self.currentClendar dateFromComponents:self.minDateCompments];
            NSDate *maxDate = [self.currentClendar dateFromComponents:self.maxDateCompments];
            if([date compare:minDate] == NSOrderedAscending){
                //不处理 按照默认的
            }else if([date compare:maxDate] == NSOrderedDescending){
                [_customDatePicker selectRow:self.maxDateCompments.year-self.minDateCompments.year inComponent:0 animated:NO];
                [_customDatePicker selectRow:0 inComponent:1 animated:NO];
                //解决 当设置的日期与最大的日期相等的时候 月份显示多了
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.customDatePicker reloadComponent:1];
                });
            }else{
                [_customDatePicker selectRow:_dateCompments.year-self.minDateCompments.year inComponent:0 animated:NO];
                [_customDatePicker selectRow:_dateCompments.month-1 inComponent:1 animated:NO];
                //解决 当设置的日期与最大的日期相等的时候 月份显示多了
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.customDatePicker reloadComponent:1];
                });
            }
        }
            break;
          case WQCustomDateDoubleHourAndMinutes:
        {
            [_customDatePicker selectRow:_dateCompments.hour inComponent:0 animated:NO];
            [_customDatePicker selectRow:_dateCompments.minute inComponent:1 animated:NO];
        }
            break;
        default:
            break;
    }
    
}
-(NSDate *)date{
    NSDateComponents *cmps = [[NSDateComponents alloc] init];
    switch (_customDateMode) {
        case WQCustomDateYearAndMonth:
        {
            NSInteger yearRow = [self.customDatePicker selectedRowInComponent:0];
            cmps.year = self.minDateCompments.year + yearRow;
            NSInteger monthRow = [self.customDatePicker selectedRowInComponent:1];
            if(monthRow == 0 ){
                cmps.month = self.minDateCompments.month + monthRow;
            }else{
                cmps.month =  monthRow+1;
            }
            cmps.day = 1;
            cmps.hour = 0;
            cmps.minute = 0;
            cmps.second = 0;
        }
            break;
        case WQCustomDateDoubleHourAndMinutes:
        {
            cmps.year = 0;
            cmps.month = 0;
            cmps.day = 0;
            cmps.second = 0;
            
            //第一个的时间
            cmps.hour = [self.customDatePicker selectedRowInComponent:0];
            cmps.minute = [self.customDatePicker selectedRowInComponent:1];
            
        }
            break;
        default:
            break;
    }
    
    return [self.currentClendar dateFromComponents:cmps];
    
}
-(void)setCustomDateMode:(WQCustomDateMode)customDateMode{
    _customDateMode = customDateMode;
    switch (_customDateMode) {
        case WQCustomDateDoubleHourAndMinutes:
            [self addSubview:self.doubleDateTipView];
            _midLineView = [[UIView alloc] init];
            _midLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            [self addSubview:_midLineView];
            break;
        case WQCustomDateYearAndMonth:
            [_doubleDateTipView removeFromSuperview];
            break;
        default:
            break;
    }
    [self.customDatePicker reloadAllComponents];
}
-(UIView *)doubleDateTipView{
    if(!_doubleDateTipView){
        _doubleDateTipView = [[UIView alloc] init];
        UILabel *startTip = [[UILabel alloc] init];
        startTip.textAlignment = NSTextAlignmentCenter;
        _startTip = startTip;
        startTip.text = NSLocalizedString(@"起始时间", nil);
        startTip.font = [UIFont systemFontOfSize:15.0];
        [_doubleDateTipView addSubview:startTip];
        
        UILabel *endTip = [[UILabel alloc] init];
        endTip.textAlignment = NSTextAlignmentCenter;
        endTip.text = NSLocalizedString(@"结束时间", nil);
        endTip.font = [UIFont systemFontOfSize:15.0];
        _endTip = endTip;
        [_doubleDateTipView addSubview:endTip];
    }
    return _doubleDateTipView;
}
-(instancetype)init{
    if(self = [super init]){
        _customDateMode = WQCustomDateNone;
        _customDatePicker = [[UIPickerView alloc] init];
        _customDatePicker.dataSource = self;
        _customDatePicker.delegate = self;
        
        [self addSubview:_customDatePicker];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfW = self.frame.size.width;
    CGFloat selfH =  self.frame.size.height;
    if(_customDateMode == WQCustomDateDoubleHourAndMinutes){
        CGFloat tipH = 38.0;
        self.doubleDateTipView.frame = CGRectMake(0.0, 0.0, selfW, tipH);
        _startTip.frame = CGRectMake(0, 0, selfW*0.5, tipH);
        _endTip.frame = CGRectMake(CGRectGetMaxX(_startTip.frame), 0.0, selfW*0.5, tipH);
        _customDatePicker.frame = CGRectMake(0, tipH - 8.0,selfW ,selfH-tipH);
        _midLineView.frame = CGRectMake(selfW *0.5 - 0.5, 0.0, 1.0, selfH);
    }else{
        _doubleDateTipView.frame = CGRectZero;
      _customDatePicker.frame = CGRectMake(0, 0,selfW ,selfH);
    }
    
}
// MARK: -- UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(_customDateMode == WQCustomDateYearAndMonth){
        return 2;
    }else if(_customDateMode == WQCustomDateDoubleHourAndMinutes){
        return 4;
    }else{
        return 0;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSInteger rows = 0;
    
    switch (_customDateMode) {
        case WQCustomDateYearAndMonth:
            if(0 == component){
                rows =  self.maxDateCompments.year - self.minDateCompments.year+1;
            }else{
                NSInteger selectedRow = [pickerView selectedRowInComponent:0];
                NSInteger rowNumbers = [pickerView numberOfRowsInComponent:0];
                if(selectedRow == 0){
                    rows = 12 - self.minDateCompments.month + 1;
                }else if(selectedRow == rowNumbers -1){
                    rows = self.maxDateCompments.month;
                }else{
                    rows =  12;
                }
            }
            break;
        case WQCustomDateDoubleHourAndMinutes:
            if(0 == component || 2 == component){
                rows =  24;
            }else {// 1 3
                rows = 60;
            }
            break;
        default:
            break;
    }
    
    return rows;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *contentLabel;
    if(!view){
        contentLabel = [[UILabel alloc] init];
        contentLabel.adjustsFontSizeToFitWidth = YES;
        contentLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        contentLabel = (UILabel *)view;
    }
    NSString *unit = @"";
    if(component<self.customUnits.count){
        unit = self.customUnits[component];
    }
    
    NSString *showTitle = @"";
    
    switch (_customDateMode) {
        case WQCustomDateYearAndMonth:
            if(component == 0){
                showTitle = [NSString stringWithFormat:@"%ld%@",(long)(self.minDateCompments.year + row),unit];
            }else{
                NSInteger selectedRow = [pickerView selectedRowInComponent:0];
                NSInteger month;
                if(selectedRow == 0){
                    month = self.minDateCompments.month + row;
                }else {
                    month = row + 1;
                }
                showTitle = [NSString stringWithFormat:@"%ld%@",(long)month,unit];
            }
            
            break;
        case WQCustomDateDoubleHourAndMinutes:
            showTitle = [NSString stringWithFormat:@"%02ld%@",(long)row,unit];
            break;
        default:
            break;
    }
    contentLabel.text = showTitle;
    
    
    return contentLabel;
}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
//    NSString *unit = @"";
//    if(component<self.customUnits.count){
//        unit = self.customUnits[component];
//    }
//    
//    NSString *showTitle = @"";
//    
//    switch (_customDateMode) {
//        case WQCustomDateYearAndMonth:
//            if(component == 0){
//                showTitle = [NSString stringWithFormat:@"%ld%@",self.minDateCompments.year + row,unit];
//            }else{
//                NSInteger selectedRow = [pickerView selectedRowInComponent:0];
//                NSInteger month;
//                if(selectedRow == 0){
//                    month = self.minDateCompments.month + row;
//                }else {
//                    month = row + 1;
//                }
//                showTitle = [NSString stringWithFormat:@"%ld%@",month,unit];
//            }
//
//            break;
//        case WQCustomDateDoubleHourAndMinutes:
//            showTitle = [NSString stringWithFormat:@"%02ld%@",(long)row,unit];
//            break;
//        default:
//            break;
//    }
//       return showTitle;
//}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return pickerView.frame.size.height/4.0;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat rowWidth = 0.0 ;
    CGFloat pickerW = pickerView.frame.size.width;
    
    switch (_customDateMode) {
        case WQCustomDateYearAndMonth:
            if(0 == component){
                rowWidth = pickerW *0.6;
            }else{
                rowWidth = pickerW *0.4;
            }
            break;
         case WQCustomDateDoubleHourAndMinutes:
            
            if(0 == component || 2 == component){
                rowWidth = pickerW * 0.2;
            }else{
                rowWidth = pickerW * 0.3;
            }
            break;
        default:
            break;
    }
    return rowWidth;
}
// MARK: -- UIPickerViewDataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (_customDateMode) {
        case WQCustomDateYearAndMonth:
            if(component == 0){
                [pickerView reloadComponent:1];
            }
            break;
        case WQCustomDateDoubleHourAndMinutes:
            //不需要刷新
            break;
        default:
            break;
    }
    if([self.delegate respondsToSelector:@selector(customDateView:didChangeDate:)]){
        [self.delegate customDateView:self didChangeDate:self.date];
    }
    if(_customDateMode == WQCustomDateDoubleHourAndMinutes && [self.delegate respondsToSelector:@selector(customDateView:didChangeSecondDate:)]){
        [self.delegate customDateView:self didChangeSecondDate:self.secondDate];
    }
}

#pragma mark -- 第二个日期
@synthesize secondDate = _secondDate;

-(void)setSecondDate:(NSDate *)secondDate{
    _secondDate = secondDate;
    NSDateComponents *cmps = [self.currentClendar components:kUnits fromDate:secondDate];
    switch (_customDateMode) {
        case WQCustomDateDoubleHourAndMinutes:
        [_customDatePicker selectRow:cmps.hour inComponent:2 animated:NO];
        [_customDatePicker selectRow:cmps.minute inComponent:3 animated:NO];
        
            break;
        case WQCustomDateYearAndMonth:
        default:
            break;
    }
    
}
-(NSDate *)secondDate{
    NSDateComponents *cmps = [[NSDateComponents alloc] init];
    switch (_customDateMode) {
       
       
        case WQCustomDateDoubleHourAndMinutes:
        
            cmps.year = 0;
            cmps.month = 0;
            cmps.day = 0;
            cmps.second = 0;
            
            //第一个的时间
            cmps.hour = [self.customDatePicker selectedRowInComponent:2];
            cmps.minute = [self.customDatePicker selectedRowInComponent:3];
            
        
            break;
        case WQCustomDateYearAndMonth:
        default:
            break;
    }
    
    return [self.currentClendar dateFromComponents:cmps];
    
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return NO;
}
@end
