//
//  WQCommonSubtitleItem.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonSubtitleItem.h"

@implementation WQCommonSubtitleItem
-(CommonItemType)itemType{
    return CommonItemTypeSubtitle;
}
-(void)commonInit{
    [super commonInit];
    _needArrow = YES;
    _subtitleAlignment = SubtitleAlignmentRightCenter;
}
-(instancetype)init{
    if(self = [super init]){
        [self commonInit];
    }
    return self;
}
-(instancetype)initWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subtitle{
    if(self = [super initWithIcon:icon title:title]){
        self.subtitle = subtitle;
    }
    return self;
}
+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subTitle:(NSString *)subtitle{
    return [[self alloc] initWithIcon:icon title:title subTitle:subtitle];
}
@end
