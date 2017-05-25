//
//  WQCommonSubtitleItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonArrowItem.h"
typedef NS_ENUM(NSInteger,SubtitleAlignment) {
    SubtitleAlignmentRightCenter,
    SubtitleAlignmentLeftBottom,
};
@interface WQCommonSubtitleItem : WQCommonArrowItem

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subtitle;
/**
 子标题的排列方式
 */
@property (assign ,nonatomic) SubtitleAlignment subtitleAlignment;
@property (copy ,nonatomic) NSString *subtitle;
@property (strong ,nonatomic) UIColor *subtitleColor;
/**是否需要指示箭头*/
@property (assign ,nonatomic) BOOL needArrow;
@end
