//
//  WQCommonCustomItem.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/1.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonCustomItem.h"

@implementation WQCommonCustomItem
+(NSString *)customIdentifire{
    static NSString *const customIdentifire = @"customCell";
    return customIdentifire;
}

-(CommonItemType)itemType{
    return CommonItemTypeCustom;
}
@end
