//
//  WQCommonCenterItem.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonCenterItem.h"

@implementation WQCommonCenterItem
-(CommonItemType)itemType{
    return CommonItemTypeCenter;
}
-(void)commonInit{
    [super commonInit];
    _contentEdge = UIEdgeInsetsMake(0, 30, 0, 30);
    _centerBackColor = [UIColor redColor];
    _centerContentColor = [UIColor whiteColor];
    _cornerRadius = 6.0;
}
-(instancetype)init{
    if(self = [super init]){
        [self commonInit];
    }
    return self;
}

@end
