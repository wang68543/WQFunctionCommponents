//
//  WQClendarView.m
//  SomeUIKit
//
//  Created by WangQiang on 2016/11/19.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQClendarView.h"
#import "WQClendarUnit.h"
#define CenterItem 72
@interface WQClendarView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong ,nonatomic) UICollectionView *collectionView;
@property (strong ,nonatomic) NSDate *currentDateFirstDay;
@property (assign ,nonatomic) NSInteger currentMonth;
@property (strong ,nonatomic) NSCalendar *currentCalendar;

@end
@implementation WQClendarView
static NSString  *const  Clender = @"Clender";
-(NSCalendar *)currentCalendar{
    if(!_currentCalendar){
        _currentCalendar =[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _currentCalendar;
}
-(NSDate *)currentDateFirstDay{
    if(!_currentDateFirstDay){
        NSDate *today = [NSDate date];
        NSDate *beginningOfWeek = nil;
        [self.currentCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&beginningOfWeek interval:NULL forDate:today];
        _currentDateFirstDay = beginningOfWeek;
//        if(ok){
//            _currentDateFirstDay = [beginningOfWeek modifyDate];
//        }else{
//            NSString *str = today.toFormat_yyyy_MM_dd;
//            str = [str stringByReplacingCharactersInRange:NSMakeRange(8, 2) withString:@"01"];
//            _currentDateFirstDay = [str.format_yyyy_MM_ddToDate modifyDate];
//        }
    }
    return _currentDateFirstDay;
}
-(instancetype)init{
    NSAssert(0, @"请用initWithFrame初始化");
    return nil;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self == [super initWithFrame:frame]){
        [self.collectionView registerClass:[WQClendarUnit class] forCellWithReuseIdentifier:Clender];
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:CenterItem inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
        [self addSubview:self.collectionView];
    }
    return self;
}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(self.frame.size.width,self.frame.size.height);
        layout.scrollDirection =  UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor redColor];
        
    }
    return _collectionView;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1000;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WQClendarUnit *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Clender forIndexPath:indexPath];
    NSDate *monthDate = [self getDateByAddingMonth:indexPath.item];
//    NSArray *models = [self findRemindsInMonth:monthDate];
    
//    cell.models = models;
    cell.monthDate = monthDate;
    
    return cell;
}
-(NSDate *)getDateByAddingMonth:(NSInteger)month{
    NSDateComponents *compements = [[NSDateComponents alloc] init];
    NSInteger difMonth = month - CenterItem;
    if(difMonth == 0){//当前日期
        [compements setMonth:0];
    }else if(difMonth < 0){//向以前的日期
        [compements setYear:(difMonth -(12 - self.currentMonth))/12];
        [compements setMonth:difMonth];
    }else{//向以后
        [compements setYear:(difMonth+self.currentMonth -1)/12];
        
        [compements setMonth:difMonth];
    }
    
    NSDate *date  = [self.currentCalendar dateByAddingComponents:compements toDate:self.currentDateFirstDay options:NSCalendarWrapComponents];
    return date;
}
@end
