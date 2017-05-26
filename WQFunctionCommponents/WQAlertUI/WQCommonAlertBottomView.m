//
//  WQCommonAlertBottomView.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonAlertBottomView.h"
@interface WQCommonAlertBottomView()
@property (strong ,nonatomic) UIButton *confirmBtn;
@property (strong ,nonatomic) UIButton *cancelBtn;

@property (strong ,nonatomic) UIView *topLineView;
@property (strong ,nonatomic) UIView *midLineView;


@end
@implementation WQCommonAlertBottomView

-(UIButton *)confirmBtn{
    if(!_confirmBtn){
        _confirmBtn = [[UIButton alloc] init];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _confirmBtn.tag = 0;
        [_confirmBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

-(UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _cancelBtn.tag = 1;
        [_cancelBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

-(UIView *)topLineView{
    if(!_topLineView){
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _topLineView;
}
-(UIView *)midLineView{
    if(!_midLineView){
        _midLineView = [[UIView alloc] init];
        _midLineView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _midLineView;
}
+(instancetype)bottomViewWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle{
    return [[self alloc] initWithConfirmTitle:confirmTitle cancelTitle:cancelTitle];
}
-(instancetype)initWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle{
    if(self = [super init]){
        _cancelTitle = cancelTitle;
        _confirmTitle = confirmTitle;
        [self configBottomButtons];
        [self addSubview:self.topLineView];
    }
    return self;
}
-(void)setConfirmTitle:(NSString *)confirmTitle{
    _confirmTitle = confirmTitle;
     [self configBottomButtons];
}
-(void)setCancelTitle:(NSString *)cancelTitle{
    _cancelTitle = cancelTitle;
     [self configBottomButtons];
}
-(void)configBottomButtons{
    if(_confirmTitle){
        [self addSubview:self.confirmBtn];
        if(_confirmAttribute){
            NSAttributedString *confirmAttrStr = [[NSAttributedString alloc] initWithString:_confirmTitle attributes:_confirmAttribute];
            [_confirmBtn setAttributedTitle:confirmAttrStr forState:UIControlStateNormal];
        }else{
            [_confirmBtn setTitle:_confirmTitle forState:UIControlStateNormal];
        }
    }else{
        [_confirmBtn removeFromSuperview];
    }
    if(_cancelTitle){
        [self addSubview:self.cancelBtn];
        if(_cancelAttribute){
            NSAttributedString *cancleAttrStr = [[NSAttributedString alloc] initWithString:_cancelTitle attributes:_cancelAttribute];
            [_cancelBtn setAttributedTitle:cancleAttrStr forState:UIControlStateNormal];
        }else{
          [_cancelBtn setTitle:_cancelTitle forState:UIControlStateNormal];
        }
    }else{
        [_cancelBtn removeFromSuperview];
    }
    
    if(_cancelBtn.superview && _confirmBtn.superview){
        [self addSubview:self.midLineView];
    }else{
        [_midLineView removeFromSuperview];
    }
    [self layoutIfNeeded];
}
-(void)setTintColor:(UIColor *)tintColor{
    [super setTintColor:tintColor];
    if(tintColor){
        _midLineView.backgroundColor = tintColor;
        _topLineView.backgroundColor = tintColor;
    }
}
-(void)setCancelAttribute:(NSDictionary *)cancelAttribute{
    _cancelAttribute = cancelAttribute;
    [self configBottomButtons];
}
-(void)setConfirmAttribute:(NSDictionary *)confirmAttribute{
    _confirmAttribute = confirmAttribute;
     [self configBottomButtons];
}

-(void)bottomBtnAction:(UIButton *)sender{
    if(sender.tag == 0){
        if([self.delegate respondsToSelector:@selector(bottomViewDidClickConfirmAction)]){
            [self.delegate bottomViewDidClickConfirmAction];
        }
    }else if(sender.tag == 1){
        if([self.delegate respondsToSelector:@selector(bottomViewDidClickCancelAction)]){
            [self.delegate bottomViewDidClickCancelAction];
        }
    }
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat viewW = CGRectGetWidth(self.frame);
    CGFloat viewH = CGRectGetHeight(self.frame);
    CGFloat lineW = 1.0;
    CGFloat btnW ;
    CGFloat btnH = viewH - lineW;
    CGFloat topY = lineW;
    
    _topLineView.frame = CGRectMake(0, 0, viewW, lineW);
    
    if(_cancelBtn.superview && _confirmBtn.superview){
        btnW = (viewW - lineW)*0.5;
        _cancelBtn.frame = CGRectMake(0, topY, btnW, btnH);
        _midLineView.frame = CGRectMake(CGRectGetMaxX(_cancelBtn.frame), topY, lineW, btnH);
        _confirmBtn.frame = CGRectMake(CGRectGetMaxX(_midLineView.frame), topY, btnW, btnH);
    }else if(_cancelBtn.superview){
        btnW = viewW;
        _cancelBtn.frame = CGRectMake(0, topY, btnW, btnH);
    }else{
        btnW = viewW;
        _confirmBtn.frame = CGRectMake(0, topY, btnW, btnH);
    }
}
-(CGFloat)heightForView{
    return 49.0;
}
@end
