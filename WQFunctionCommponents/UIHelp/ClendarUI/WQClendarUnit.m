//
//  ClenderUnit.m
//  scrollview
//
//  Created by WangQiang on 16/4/19.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQClendarUnit.h"
#import "WQClendarDayUnit.h"
//#import "NSDate+Utilities.h"

#define RandomColor [UIColor colorWithRed:arc4random_uniform(255) /255.0 green:arc4random_uniform(255) /255.0 blue:arc4random_uniform(255) /255.0 alpha:1]

@interface WQClendarUnit()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong ,nonatomic) UICollectionView *collectionView;
@property (assign ,nonatomic) NSInteger firstDayWeek;
/**
 *  一个月有多少天
 */
@property (assign ,nonatomic) NSInteger days;
@property (strong ,nonatomic) NSDateComponents *dateComponents;
@property (strong ,nonatomic) NSCalendar *currentClander;

@end
@implementation WQClendarUnit
-(NSCalendar *)currentClander{
    if(!_currentClander){
        _currentClander = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    }
    return _currentClander;
}
static NSString  *const  ClenderDay = @"ClenderDay";
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.minimumLineSpacing = 1.0;
          layout.minimumInteritemSpacing = 1.0;
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 8.0)/7.0, (self.frame.size.height - 5.0)/6.0);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        //        _collectionView.
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.contentInset = UIEdgeInsetsMake(0, layout.minimumLineSpacing, 0, 0);
        _collectionView.scrollEnabled = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}
-(void)setMonthDate:(NSDate *)monthDate{
    _monthDate = monthDate;
    self.firstDayWeek = ([self firstWeekdayInThisMonth:monthDate]%6);//处理使每个月的第一天在第一行
    self.days = [self totaldaysInThisMonth:monthDate];
    self.dateComponents = [self.currentClander components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:monthDate];

    [self.collectionView reloadData];
    
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    
        [self.collectionView registerClass:[WQClendarDayUnit class] forCellWithReuseIdentifier:ClenderDay];
        [self.contentView  addSubview:self.collectionView];
    }
    return self;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 42;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WQClendarDayUnit *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ClenderDay forIndexPath:indexPath];
    if(indexPath.item >= self.firstDayWeek && indexPath.item < self.firstDayWeek + self.days){
        NSDate *date = [self getDateWithDay:indexPath.item];
       
        cell.date = date;
    }else{
        cell.date = nil;
        cell.models = [NSArray array];
    }
    
    return cell;
}

-(NSDate *)getDateWithDay:(NSInteger)day{
    [self.dateComponents setDay:day-self.firstDayWeek+1];
    NSDate *date  = [self.currentClander dateFromComponents:self.dateComponents] ;
    
    return date;
}
#pragma mark 一个月有多少天
- (NSInteger)totaldaysInThisMonth:(NSDate *)date{
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}
#pragma mark --这周是周几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

@end
