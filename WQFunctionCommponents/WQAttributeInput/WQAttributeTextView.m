//
//  InputTextView.m
//  AttrbuteInput
//
//  Created by hejinyin on 2017/11/10.
//  Copyright © 2017年 hejinyin. All rights reserved.
//

#import "WQAttributeTextView.h"
@implementation WQAttributeTextAttachment
@end
//MARK: =========== WQAttributeTextView ===========
@interface WQAttributeTextView(){
    UILabel *_placeHolderLabel;
}
@end
@implementation WQAttributeTextView

- (instancetype)init
{
    self = [super init];
    if (self) {
        if (@available(iOS 11.0,*)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        //非通知无法监听到xib创建的textview的文字的改变
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}


-(void)insertImage:(UIImage *)image withBounds:(CGRect)bounds{
    [self insertImage:image withBounds:bounds imgSrc:nil];
}
-(void)insertImage:(UIImage *)image withBounds:(CGRect)bounds imgSrc:(NSString *)src{
    WQAttributeTextAttachment *attach = [[WQAttributeTextAttachment alloc] init];
    attach.image = image;
    attach.bounds = bounds;
    attach.imgSrc = src;
    
    //解决字体问题
    UIFont *font = self.font;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attach]];
    
    // \n解决上下跳动问题
    [attr  insertAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:@{NSFontAttributeName:font}] atIndex:0];
    
    
    [self.textStorage insertAttributedString:attr   atIndex:self.selectedRange.location];
    
    self.font = font;
}


//MARK: =========== placehodle ===========

-(void)refreshPlaceholder{
    if([[self text] length])
    {
        [_placeHolderLabel setAlpha:0];
    }
    else
    {
        [_placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeHolderLabel sizeToFit];
    _placeHolderLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame)-16, CGRectGetHeight(_placeHolderLabel.frame));
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( _placeHolderLabel == nil )
    {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        _placeHolderLabel.alpha = 0;
        [self addSubview:_placeHolderLabel];
    }
    
    _placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

//When any text changes on textField, the delegate getter is called. At this time we refresh the textView's placeholder
-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}

@end
