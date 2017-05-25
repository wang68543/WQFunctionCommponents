//
//  WQCommonGroup.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQCommonBaseItem.h"
#import "WQCommonArrowItem.h"
#import "WQCommonSwitchItem.h"
#import "WQCommonSubtitleItem.h"
#import "WQCommonCenterItem.h"
#import "WQCommonCustomItem.h"
typedef struct WQCommonHeight WQCommonHeight;

@interface WQCommonGroup : NSObject
+(instancetype)commonGroup;
+(instancetype)comomnGroupWithHeder:(NSString *)header footer:(NSString *)footer;
@property (copy ,nonatomic) NSString *header;
@property (copy ,nonatomic) NSString *footer;
@property (strong ,nonatomic) NSMutableArray<WQCommonBaseItem*> *items;
@property (assign ,nonatomic) WQCommonHeight commonHeight;
@end

struct WQCommonHeight {
    CGFloat headerHeight;
    CGFloat footerHeight;
    CGFloat defaultCellHeight;
};
CG_INLINE WQCommonHeight
WQCommonHeightMake(CGFloat headerHeight, CGFloat footerHeight,CGFloat cellHeight)
{
    WQCommonHeight commonHeight;
    commonHeight.headerHeight = headerHeight;
    commonHeight.footerHeight = footerHeight;
    commonHeight.defaultCellHeight = cellHeight;
    return commonHeight;
}
