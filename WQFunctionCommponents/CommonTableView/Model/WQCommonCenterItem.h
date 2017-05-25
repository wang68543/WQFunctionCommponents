//
//  WQCommonCenterItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseItem.h"

@interface WQCommonCenterItem : WQCommonBaseItem

@property (assign ,nonatomic) CGFloat cornerRadius;
@property (assign ,nonatomic) UIEdgeInsets contentEdge;
/**
 居中控件的背景颜色
 */
@property (strong ,nonatomic) UIColor *centerBackColor;

/**
 居中控件的文字颜色
 */
@property (strong ,nonatomic) UIColor *centerContentColor;


@end
