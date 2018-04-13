//
//  ClendarDayUnit.m
//  scrollview
//
//  Created by WangQiang on 16/4/19.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQClendarDayUnit.h"
@interface WQClendarDayUnit ()
@property (weak ,nonatomic) UILabel *dayLabel;

/**
 *  用于记录未选中的文字颜色(用于恢复)
 */
@property (weak ,nonatomic) UIColor *lastDayLabelColor;
@end
@implementation WQClendarDayUnit
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        UILabel *dayLabel = [[UILabel alloc] init];
        dayLabel.backgroundColor = [UIColor clearColor];
        dayLabel.font = [UIFont systemFontOfSize:15.0];
        dayLabel.text = [NSString stringWithFormat:@"%u",arc4random()%31];
        dayLabel.textAlignment = NSTextAlignmentCenter;
//        dayLabel.text = @"12";
        dayLabel.textColor = [UIColor blackColor];
        self.lastDayLabelColor = [UIColor blackColor];
        self.dayLabel = dayLabel;
        [self.contentView addSubview:dayLabel];
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor greenColor];
        selectedView.layer.cornerRadius = 5.0;
        selectedView.layer.masksToBounds = YES;
        self.selectedBackgroundView = selectedView;
//        self.contentView.layer.borderWidth = 1.0;
//        self.contentView.layer.borderColor = LineColor.CGColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.dayLabel.frame = self.bounds;
}
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
   
        if(selected){
            self.dayLabel.textColor = [UIColor whiteColor];
        }else{
         if(self.models.count <= 0)
            self.dayLabel.textColor = self.lastDayLabelColor;
        }
   
}
-(void)setDate:(NSDate *)date{
    if(date && [date isKindOfClass:[NSDate class]]){
        _date = date;
        NSInteger day = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] component:NSCalendarUnitDay fromDate:date];
        self.dayLabel.text = [NSString stringWithFormat:@"%ld",(long)day];
        self.userInteractionEnabled = YES;
//        if(_date.isToday){
//            self.backgroundColor = [UIColor greenColor];
//        }
    }else{
        self.dayLabel.text = @"";
        self.userInteractionEnabled = NO;
    }
   
}
-(void)setModels:(NSArray *)models{
    _models = models;
//    if(models.count <= 0){
//        self.backgroundColor = [UIColor clearColor];
//        self.dayLabel.textColor = [UIColor blackColor];
//    }else{
//        switch (models.count) {
//            case 1:
//                self.backgroundColor = LightGreen;
//                break;
//            case 2:
//                self.backgroundColor = NormalGreen;
//                break;
//            case 3:
//                self.backgroundColor = DeepGreen;
//                break;
//            case 4:
//                self.backgroundColor = LightBrown;
//                break;
//                
//            default:
//                self.backgroundColor = DeepRed;
//                break;
//        }
//        self.dayLabel.textColor = [UIColor whiteColor];
//    }
}
@end
