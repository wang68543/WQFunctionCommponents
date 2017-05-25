//
//  WQCommonArrowItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseItem.h"

@interface WQCommonArrowItem : WQCommonBaseItem
/**红色提示数字 值为NSNotFound的时候显示为小红点 */
@property (assign ,nonatomic) NSInteger bageValue;

@property (assign ,nonatomic) Class destClass;


/**
 将要跳转的页面携带的一些参数
 */
@property (strong ,nonatomic) NSDictionary *destPropertyParams;

@end
