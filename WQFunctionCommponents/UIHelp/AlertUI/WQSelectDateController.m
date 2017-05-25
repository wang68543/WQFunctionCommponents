//
//  WQSelectDateController.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQSelectDateController.h"
#import "WQCommonAlertTitleView.h"
#import "WQCommonAlertBottomView.h"
#import "WQControllerTransition.h"
#import "WQAPPHELP.h"
static CGFloat const DatePickerHeight = 190;

static CGFloat const ToolBarHeight = 44.0;

static CGFloat const BottomViewHeight = 49.0;

static CGFloat const TitleViewHeight = 49.0;

static NSInteger const kUnits = NSCalendarUnitYear|NSCalendarUnitMonth;

#define CenterAlertWidth ([UIScreen mainScreen].bounds.size.width - 40)

@interface WQSelectDateController ()<WQAlertBottomViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (copy ,nonatomic) ChangeDate dateChange;
@property (copy ,nonatomic) ConfirmDate dateConfirm;
@property (copy ,nonatomic) CancelDate dateCancel;

@property (strong ,nonatomic) UIView *containerView;


@property (strong ,nonatomic) WQCommonAlertTitleView *titleView;

@property (strong ,nonatomic) WQCommonAlertBottomView *bottomView;

@property (strong ,nonatomic) WQControllerTransition *bottomTranstion;

@property (strong ,nonatomic) UITapGestureRecognizer *tapGR;

@property (strong ,nonatomic) UIToolbar *toolbar;
@property (assign ,nonatomic,readonly) WQCustomDateMode customDateStyle;
/** 对应date属性的Compments */
@property (strong ,nonatomic) NSDateComponents *dateCompments;
/** 用于控制自定义日期控件的选择区间 */
@property (strong ,nonatomic) NSDateComponents *maxDateCompments;
@property (strong ,nonatomic) NSDateComponents *minDateCompments;

@property (strong ,nonatomic) NSCalendar *currentClendar;
@end

@implementation WQSelectDateController
+(instancetype)customDateWithTitle:(NSString *)title alertStyle:(UIAlertControllerStyle)alertStyle dateDidChange:(ChangeDate)didChange confirmSelected:(ConfirmDate)confirmDate cancelSelected:(CancelDate)cancelDate{
    return [[self alloc] initCustomWithTitle:title alertStyle:alertStyle dateDidChange:didChange confirmSelected:confirmDate cancelSelected:cancelDate];
}
+(instancetype)dateWithTitle:(NSString *)title alertStyle:(UIAlertControllerStyle)alertStyle dateDidChange:(ChangeDate)didChange confirmSelected:(ConfirmDate)confirmDate cancelSelected:(CancelDate)cancelDate{
    return [[self alloc] initWithTitle:title alertStyle:alertStyle dateDidChange:didChange confirmSelected:confirmDate cancelSelected:cancelDate];
}

-(instancetype)initWithTitle:(NSString *)title alertStyle:(UIAlertControllerStyle)alertStyle dateDidChange:(ChangeDate)didChange confirmSelected:(ConfirmDate)confirmDate cancelSelected:(CancelDate)cancelDate{
    if(self = [super init]){
        _customDateStyle = WQCustomDateNone;
        
        _datePicker = [[UIDatePicker alloc] init];
        if(didChange){
            [_datePicker addTarget:self action:@selector(datePickerDidChange:) forControlEvents:UIControlEventValueChanged];
        }
      
        [self defaultCommonWithTitle:title alertStyle:alertStyle dateDidChange:didChange confirmSelected:confirmDate cancelSelected:cancelDate];
          [self.containerView addSubview:_datePicker];
    }
    return self;
}
- (instancetype)initCustomWithTitle:(NSString *)title alertStyle:(UIAlertControllerStyle)alertStyle dateDidChange:(ChangeDate)didChange confirmSelected:(ConfirmDate)confirmDate cancelSelected:(CancelDate)cancelDate{
    if(self = [super init]){
        _customDateStyle = WQCustomDateYearAndMonth;
        _customDatePicker = [[UIPickerView alloc] init];
        _customDatePicker.delegate = self;
        _customDatePicker.dataSource = self;
      
        
        [self defaultCommonWithTitle:title alertStyle:alertStyle dateDidChange:didChange confirmSelected:confirmDate cancelSelected:cancelDate];
          [self.containerView addSubview:_customDatePicker];
    }
    return self;
}

-(void)defaultCommonWithTitle:(NSString *)title alertStyle:(UIAlertControllerStyle)alertStyle dateDidChange:(ChangeDate)didChange confirmSelected:(ConfirmDate)confirmDate cancelSelected:(CancelDate)cancelDate{

        _alertControllerStyle = alertStyle;
        _dateChange = [didChange copy];
        _dateConfirm = [confirmDate copy];
        _dateCancel = [cancelDate copy];
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.containerView];
        if(alertStyle == UIAlertControllerStyleAlert){
            [self configCenterAlertViewWithTitle:title];
        }else{
            [self configBottomSheetViewWithTitle:title];
        }
        self.enableTapGR = YES;
   
}
-(UITapGestureRecognizer *)tapGR{
    if(!_tapGR){
        _tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackground:)];
    }
    return _tapGR;
}
-(void)tapBackground:(UITapGestureRecognizer *)tapGR{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
-(void)setEnableTapGR:(BOOL)enableTapGR{
    _enableTapGR = enableTapGR;
    if(enableTapGR){
        [self.view addGestureRecognizer:self.tapGR];
    }else{
        [self.view removeGestureRecognizer:_tapGR];
    }
}
-(void)setMaximumDate:(NSDate *)maximumDate{
    if(self.customDateStyle == WQCustomDateNone){
        _datePicker.maximumDate = maximumDate;
    }else{
        _maximumDate = maximumDate;
        _maxDateCompments = [self.currentClendar components:kUnits fromDate:maximumDate];
        [self.customDatePicker reloadAllComponents];
    }
}
-(void)setMinimumDate:(NSDate *)minimumDate{
    if(self.customDateStyle == WQCustomDateNone){
        _datePicker.minimumDate = minimumDate;
    }else{
        _minimumDate = minimumDate;
        _minDateCompments = [self.currentClendar components:kUnits fromDate:_minimumDate];
        [self.customDatePicker reloadAllComponents];
    }
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
    if(self.customDateStyle == WQCustomDateNone){
        _datePicker.date = date;
    }else{
        _dateCompments = [self.currentClendar components:kUnits fromDate:date];
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
}
-(NSDate *)date{
    if(self.customDateStyle == WQCustomDateNone){
        return self.datePicker.date;
    }else{
        NSDateComponents *cmps = [[NSDateComponents alloc] init];
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
        return [self.currentClendar dateFromComponents:cmps];
    }
}
-(UIToolbar *)toolbar{
    if(!_toolbar){
        _toolbar = [[UIToolbar alloc] init];
    }
    return _toolbar;
}
- (void)configCenterAlertViewWithTitle:(NSString *)alertTitle{
    CGFloat offsetY = 0;
    if(alertTitle){
        _titleView = [WQCommonAlertTitleView titleViewWithTitle:alertTitle icon:nil];
        _titleView.frame = CGRectMake(0, 0, CenterAlertWidth, TitleViewHeight);
        offsetY += TitleViewHeight;
        [_containerView addSubview:_titleView];
    }
    if(_customDatePicker != WQCustomDateNone){
       _customDatePicker.frame = CGRectMake(0, offsetY, CenterAlertWidth, DatePickerHeight);
        offsetY += DatePickerHeight;
    }else{
     _datePicker.frame = CGRectMake(0, offsetY, CenterAlertWidth, DatePickerHeight);
        offsetY += DatePickerHeight;
    }
    
    _bottomView = [WQCommonAlertBottomView bottomViewWithConfirmTitle:@"确定" cancelTitle:@"取消"];
    _bottomView.delegate = self;
    _bottomView.frame = CGRectMake(0, offsetY, CenterAlertWidth, BottomViewHeight);
    [_containerView addSubview:_bottomView];
    
    _containerView.frame = CGRectMake(0, 0, CenterAlertWidth, CGRectGetMaxY(_bottomView.frame));
    
}
-(void)configBottomSheetViewWithTitle:(NSString *)title{
    NSMutableArray *toolBarItems = [NSMutableArray array];
    UIBarButtonItem *confirmItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(bottomViewDidClickConfirmAction)];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(bottomViewDidClickCancelAction)];
//    UIBarButtonItem *fixItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [toolBarItems addObject:fixItem0];
    [toolBarItems addObject:cancelItem];
    UIBarButtonItem *fixItem1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBarItems addObject:fixItem1];
    if(title){
        
        UIBarButtonItem *titleItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
        [titleItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor blackColor]} forState:UIControlStateNormal];
        [toolBarItems addObject:titleItem];
        UIBarButtonItem *fixItem2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [toolBarItems addObject:fixItem2];
    }
    [toolBarItems addObject:confirmItem];
//    UIBarButtonItem *fixItem3 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    [toolBarItems addObject:fixItem3];
    [self.containerView addSubview:self.toolbar];
    self.toolbar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ToolBarHeight);
    self.toolbar.items = toolBarItems;
    CGFloat offsetY = CGRectGetMaxY(self.toolbar.frame);
    if(_customDatePicker != WQCustomDateNone){
        _customDatePicker.frame = CGRectMake(0, offsetY, [UIScreen mainScreen].bounds.size.width, DatePickerHeight);
        offsetY += DatePickerHeight;
    }else{
        _datePicker.frame = CGRectMake(0, offsetY, [UIScreen mainScreen].bounds.size.width, DatePickerHeight);
        offsetY += DatePickerHeight;
    }
    _containerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, offsetY);
}

- (void)datePickerDidChange:(UIDatePicker *)datePicker{
    _dateChange?_dateChange(datePicker.date):nil;
}
-(NSCalendar *)currentClendar{
    if(!_currentClendar){
        _currentClendar = [NSCalendar currentCalendar];
    }
    return _currentClendar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
// MARK: -- UIPickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if(_customDateStyle == WQCustomDateYearAndMonth){
       return 2;
    }else{
       return 0;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(0 == component){
       return  self.maxDateCompments.year - self.minDateCompments.year+1;
    }else if(1 == component){
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSInteger rowNumbers = [pickerView numberOfRowsInComponent:0];
        if(selectedRow == 0){
            return 12 - self.minDateCompments.month + 1;
        }else if(selectedRow == rowNumbers -1){
            return self.maxDateCompments.month;
        }else{
           return  12;
        }
    }
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *unit = @"";
    if(component<self.units.count){
        unit = self.units[component];
    }
    if(component == 0){
        return [NSString stringWithFormat:@"%ld%@",self.minDateCompments.year + row,unit];
    }else if(component == 1){
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSInteger month;
        if(selectedRow == 0){
           month = self.minDateCompments.month + row;
        }else {
            month = row + 1;
        }
        return [NSString stringWithFormat:@"%ld%@",month,unit];
    }
    return @"";
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return DatePickerHeight/4.0;
}
// MARK: -- UIPickerViewDataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(component == 0){
        [pickerView reloadComponent:1];
    }
    if(_dateChange){
        _dateChange(self.date);
    }
}
-(void)showInController:(nullable UIViewController *)viewController{
    if(!viewController){
        viewController = [WQAPPHELP currentNavgationController];
    }
    _bottomTranstion = [WQControllerTransition transitionWithAnimatedView:self.containerView];
    if(_alertControllerStyle == UIAlertControllerStyleAlert){
        _bottomTranstion.showOneSubViewType = ShowOneSubviewFromDownToMiddleCenter;
        _bottomTranstion.animationType = AnimationTypeSpring;
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        _bottomTranstion.duration = 0.15;
        _bottomTranstion.showOneSubViewType =ShowOneSubviewFromDownToBottom;
        _bottomTranstion.targetBackColor = [UIColor clearColor];
        _containerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _bottomTranstion.animationType = AnimationTypeNormal;
    }
    
    
    self.transitioningDelegate = _bottomTranstion;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [viewController presentViewController:self animated:YES completion:NULL];
//    if(self.customDateStyle == WQCustomDateYearAndMonth){
//        if(!_date){
//            self.date = [NSDate date];
//        }
//    }
    
}

#pragma mark -- WQAlertBottomViewDelegate
-(void)bottomViewDidClickCancelAction{
    if(_dateCancel){
        _dateCancel(self);
    }else{
        [self dismissViewControllerAnimated:YES completion:NULL];
    }
}
-(void)bottomViewDidClickConfirmAction{
    if(_dateConfirm){
        _dateConfirm(self,self.date);
    }else{
       [self dismissViewControllerAnimated:YES completion:NULL]; 
    }
}
@end
