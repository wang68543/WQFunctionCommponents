//
//  ClenderUnit.h
//  scrollview
//
//  Created by WangQiang on 16/4/19.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ClendarHeight 250.0
@interface WQClendarUnit : UICollectionViewCell
/**
 *  一个月的第一天
 */
@property (strong ,nonatomic) NSDate *monthDate;
/**
 *  处在当前月里面的提醒
 */
@property (strong ,nonatomic) NSArray *models;

@end
