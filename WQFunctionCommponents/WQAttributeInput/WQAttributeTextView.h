//
//  WQAttributeTextView.h
//  AttrbuteInput
//
//  Created by hejinyin on 2017/11/10.
//  Copyright © 2017年 hejinyin. All rights reserved.
// 当前测试可行的是textView的高度固定的情况  其他的情况暂没有测试
// 另外一种图文输入思路是 以imageView 和 textView组成 然后都按顺序添加到数组中 (具体的查看印象笔记)

#import <UIKit/UIKit.h>
@interface WQAttributeTextAttachment:NSTextAttachment
@property (copy    ,nonatomic) NSString *imgSrc;
@end

@interface WQAttributeTextView : UITextView
@property (copy ,nonatomic) NSString *placeholder;

/** 先显示后上传 */
- (void)insertImage:(UIImage *)image withBounds:(CGRect)bounds;
/** 先上传后显示 */
- (void)insertImage:(UIImage *)image withBounds:(CGRect)bounds imgSrc:(NSString *)src;


@end
