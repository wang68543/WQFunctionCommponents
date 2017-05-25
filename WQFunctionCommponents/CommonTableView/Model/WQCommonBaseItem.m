//
//  WQBaseCommonItem.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseItem.h"

@implementation WQCommonBaseItem
-(CommonItemType)itemType{
    return CommonItemTypeBase;
}
- (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title
{
    self = [super init];
    if (self) {
        [self commonInit];
        self.title = title;
        self.icon = icon;
    }
    return self;
}
-(void)commonInit{
     _cellHeight = 44.0;
}
+(instancetype)baseItemWithTitle:(NSString *)title{
    return [self baseItemWithIcon:nil title:title];
}
+(instancetype)baseItemWithIcon:(NSString *)icon title:(NSString *)title{
    return [[self alloc] initWithIcon:icon title:title];
}
@end
