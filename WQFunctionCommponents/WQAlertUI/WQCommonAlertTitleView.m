//
//  WQCommonAlertTitleView.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonAlertTitleView.h"

@interface WQCommonAlertTitleView ()
@property (strong ,nonatomic) UILabel *titleLabel;
@property (strong ,nonatomic) UIImageView *iconView;
@property (strong ,nonatomic) UIView *bottomLine;

@end
@implementation WQCommonAlertTitleView

-(UIImageView *)iconView{
    if(!_iconView){
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconView;
}

-(UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}
-(UIView *)bottomLine{
    if(!_bottomLine){
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomLine;
}
+(nonnull instancetype)titleViewWithTitle:(nullable NSString *)title icon:(nullable UIImage *)titleIcon{
    return [[self alloc] initWithTitle:title icon:titleIcon];
}
-(instancetype)initWithTitle:(NSString *)title icon:(UIImage *)titleIcon{
    if(self = [super init]){
        _title = title;
        _titleIcon = titleIcon;
        [self addSubview:self.bottomLine];
        [self configProperty];
    }
    return self;
}
-(void)setTitleAttribute:(NSDictionary *)titleAttribute{
    _titleAttribute = titleAttribute;
    [self configProperty];
}
-(void)setTitle:(NSString *)title{
    _title = title;
    [self configProperty];
}
-(void)setTitleIcon:(UIImage *)titleIcon{
    _titleIcon = titleIcon;
    [self configProperty];
}
-(void)configProperty{
    if(_titleIcon){
        [self addSubview:self.iconView];
    }else{
        [_iconView removeFromSuperview];
    }
    if(_title){
        if(_titleAttribute){
            NSAttributedString *titleAttr = [[NSAttributedString alloc] initWithString:_title attributes:_titleAttribute];
            self.titleLabel.attributedText = titleAttr;
        }else{
            self.titleLabel.text = _title;
        }
        [self addSubview:self.titleLabel];
    }else{
        [_titleLabel removeFromSuperview];
    }
    
    [self layoutIfNeeded];
}
-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    if(tintColor){
        self.bottomLine.backgroundColor = tintColor;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat leftPadding = 15;
    CGFloat viewH = CGRectGetHeight(self.frame);
    CGFloat viewW = CGRectGetWidth(self.frame);
    CGFloat lineW = 1.0;
    CGFloat imageW = _titleIcon.size.width;
    CGFloat imageH = _titleIcon.size.height;
    CGFloat imageTopPadding = 8.0;
    CGFloat imageMaxH = imageH - imageTopPadding*2;
    CGFloat scale = 1.0;
    CGFloat sectionPadiing = 10.0;
    if(imageH > imageMaxH){
        scale = imageMaxH / imageH;
        imageH = imageMaxH;
        imageW *= scale;
    }
    
    if(_titleLabel.superview && _iconView.superview){
        _iconView.frame = CGRectMake(leftPadding, imageTopPadding, imageW, imageH);
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame)+ sectionPadiing, 0, viewW - (CGRectGetMaxX(_iconView.frame)+ sectionPadiing + leftPadding), viewH - lineW);
    }else if(_iconView.superview){
        _iconView.frame = CGRectMake(leftPadding, imageTopPadding, imageW, imageH);
    }else{
        _titleLabel.frame = CGRectMake(leftPadding, 0, viewW - 2*leftPadding, viewH);
    }
    _bottomLine.frame = CGRectMake(0, viewH - lineW, viewW, lineW);
}
-(CGFloat)heightForView{
    return 49.0;
}
@end
