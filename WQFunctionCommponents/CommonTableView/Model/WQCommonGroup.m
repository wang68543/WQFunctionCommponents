//
//  WQCommonGroup.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonGroup.h"

@implementation WQCommonGroup
+(instancetype)commonGroup{
    return [self comomnGroupWithHeder:nil footer:nil];
}
+(instancetype)comomnGroupWithHeder:(NSString *)header footer:(NSString *)footer{
    return [[self alloc] initWithHeader:header footer:footer];
}
- (instancetype)initWithHeader:(NSString *)header footer:(NSString *)footer
{
    self = [super init];
    if (self) {
        [self comomnInit];
        self.header = header;
        self.footer = footer;
    }
    return self;
}
-(NSMutableArray<WQCommonBaseItem *> *)items{
    if(!_items){
        _items = [NSMutableArray array];
    }
    return _items;
}
-(instancetype)init{
    if(self = [super init]){
        [self comomnInit];
    }
    return self;
}
-(void)comomnInit{
    _commonHeight = WQCommonHeightMake(25.0, 25.0, 44.0);
}
@end
