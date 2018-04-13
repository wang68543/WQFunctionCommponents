//
//  WQTagsFlowLayout.h
//  SomeUIKit
//
//  Created by WangQiang on 2016/11/24.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,LineAlignment) {
    LineAlignmentLeft,
    LineAlignmentCenter,
    LineAlignmentRight,
    LineAlignmentFill,
};
@class WQTagsFlowLayout;
@protocol WQTagsFlowLayoutDelegate<NSObject>

/**
 获取指定路径的宽度

 @param flowLayout 布局对象
 @param indexPath 元素原路径
 @param targetLine 准备投放的目标行
 @param remindWidth 当前行剩余的宽度
 @return 实际需要显示的宽度
 */
-(CGFloat)tagsFlowLayout:(WQTagsFlowLayout *)flowLayout widthAtIndex:(NSIndexPath *)indexPath targetLine:(NSInteger)targetLine lineRemindWidth:(CGFloat)remindWidth;
@optional
-(CGFloat)tagsFlowLayout:(WQTagsFlowLayout *)flowLayout  lineHeightAtLine:(NSInteger)line lastLine:(BOOL)isLast;
-(LineAlignment)tagsFlowLayout:(WQTagsFlowLayout *)flowLayout lineContentAliment:(NSInteger)line lastLine:(BOOL)isLast;
@end
@interface WQTagsFlowLayout : UICollectionViewFlowLayout
/**
 每一行的布局
 */
@property (assign ,nonatomic) LineAlignment lineContentAliment;

/**
 一共有多少行
 */
@property (assign ,nonatomic,readonly) NSInteger lines;


@property (assign ,nonatomic) CGFloat rowHeight;

@property (weak ,nonatomic) id<WQTagsFlowLayoutDelegate>delegate;
-(void)reloadLayout;
@end
