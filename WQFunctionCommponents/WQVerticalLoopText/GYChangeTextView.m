//
//  GYChangeTextView.m
//  GYShop
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 GY. All rights reserved.
//

#import "GYChangeTextView.h"

@interface ChangeSubTextView : UILabel

@end
@implementation ChangeSubTextView
-(instancetype)init{
    if(self = [super init]){
        self.textAlignment = NSTextAlignmentLeft;
    }
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.backgroundColor = [UIColor whiteColor];
    });
}
-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor whiteColor];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.backgroundColor = [UIColor whiteColor];
}
@end

#define DEALY_WHEN_TITLE_IN_MIDDLE  2.0
@interface GYChangeTextView (){
    NSInteger _lastIndex;
    BOOL _isAnimating;
}
@property (nonatomic, strong) NSArray *contentsAry;
@property (strong ,nonatomic) NSMutableArray *contentViews;
@property (weak ,nonatomic)  ChangeSubTextView *reuseView;
/*
 *1.控制延迟时间，当文字在中间时，延时时间长一些，如5秒，这样可以让用户浏览清楚内容；
 *2.当文字隐藏在底部的时候，不需要延迟，这样衔接才流畅；
 *3.通过上面的宏定义去更改需要的值
 */
@property (nonatomic, assign) CGFloat needDealy;
@property (nonatomic, assign) BOOL shouldStop;         /*是否停止*/

@end

@implementation GYChangeTextView
static NSString *const  anmationID = @"animation";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        self.shouldStop = NO;
      
        _isAnimating = NO;
        self.clipsToBounds = YES;   /*保证文字不跑出视图*/
        self.needDealy = DEALY_WHEN_TITLE_IN_MIDDLE;    /*控制第一次显示时间*/
//        self.currentIndex = 0;
    }
    return self;
}
-(ChangeSubTextView *)commonButton{
    ChangeSubTextView *_textBtn = [[ChangeSubTextView alloc] init];
    _textBtn.userInteractionEnabled = NO;
    [self addSubview:_textBtn];
    return _textBtn;
}
-(void)addLabels{
    
    if(self.contentViews){
        [self.contentViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    self.contentViews = [NSMutableArray array];
    
   
    
    self.animationTextCount = MAX(self.animationTextCount, 1);
    //高度按照指定的展示条目进行计算高度
    CGFloat LabelH = self.frame.size.height /(self.animationTextCount *1.0);
    
    self.animationTextCount = MIN(self.animationTextCount, self.contentsAry.count);
    CGFloat LeftPadding = 10.0;
     CGFloat LabelW = self.frame.size.width - LeftPadding *2;
    CGFloat Label_y = 0.0;
    for (int i = 0; i < self.animationTextCount ; i ++) {
        ChangeSubTextView *btn = [self commonButton];
        btn.frame = CGRectMake(LeftPadding, Label_y, LabelW, LabelH);
        Label_y += LabelH;
        [self.contentViews addObject:btn];
    }
    if(self.contentsAry.count > self.animationTextCount){
        _reuseView = [self commonButton];
        _reuseView.frame = CGRectMake(LeftPadding, Label_y, LabelW, LabelH);
        [self.contentViews addObject:_reuseView];
    }
//    [self setNeedsLayout];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    CGFloat LabelW = self.width;
//    CGFloat LabelH = self.height /(self.animationTextCount *1.0);
//    CGFloat LeftPadding = 0.0;
//    
//    __block CGFloat Label_y = 0.0;
//    [self.Labels enumerateObjectsUsingBlock:^(UIView  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.frame = CGRectMake(LeftPadding, Label_y, LabelW, LabelH);
//        Label_y += LabelH;
//    }];
////    _reuseLabel.frame = CGRectMake(LeftPadding, Label_y, LabelW, LabelH);
//    
//}
- (void)animationWithTexts:(NSArray *)textAry {
//    if(_isAnimating){
//        self.shouldStop = YES;
//        do {//等待动画完成
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }while(_isAnimating);
//    }
    self.contentsAry = textAry;
    [self addLabels];
    for (int i = 0; i < self.animationTextCount ; i ++) {
        ChangeSubTextView *btn = self.contentViews[i];
        btn.text = textAry[i];
        btn.tag = i;
    }
    
    if(self.contentsAry.count > self.animationTextCount){
        _reuseView.text = self.contentsAry[self.animationTextCount];
        _reuseView.tag = self.animationTextCount;
        _lastIndex = self.animationTextCount ;
        //刚开始若没有frame初始值 会没有动画效果 后面layoutsubViews调用了才有效果
        if(!_isAnimating)
        [self startAnimation];
        self.shouldStop = NO;
    }else{
        self.shouldStop = YES;
    }

}
- (void)startAnimation{

        CGFloat labelH = _reuseView.frame.size.height;
        __weak typeof(self) weakSelf = self;
        _isAnimating = YES;
        [UIView animateWithDuration:0.3 delay:self.needDealy options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            for (UIButton *label in weakSelf.contentViews) {
                label.layer.position = CGPointMake(label.layer.position.x, label.layer.position.y - labelH);
            }
        }completion:^(BOOL finished) {
//               _isAnimating = NO;
            if(!weakSelf.shouldStop){
                [weakSelf.contentViews enumerateObjectsUsingBlock:^(ChangeSubTextView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if(CGRectGetMaxY(obj.frame) <= 0.0){
                        
                        ChangeSubTextView *temp = _reuseView;
                        _reuseView = obj;
                        _lastIndex ++;
                        _reuseView.tag = [weakSelf realLastIndex];
                        _reuseView.text = weakSelf.contentsAry[_reuseView.tag];
                        _reuseView.layer.position = CGPointMake(_reuseView.layer.position.x, self.frame.size.height + labelH *0.5);
                        
                        obj = temp;
                        *stop = YES;
                    }
                }];
             
                [weakSelf startAnimation];
            }else{
                _isAnimating = NO;
            }
        }];
}
-(NSInteger)realLastIndex{
    return _lastIndex % [self.contentsAry count];
}

- (void)stopAnimation {
    self.shouldStop = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // 获取点击点
    CGPoint point = [[touches anyObject] locationInView:self];
    __weak typeof(self) weakSelf = self;
    [self.contentViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 获取tmpView的layer当前的位置
        CGRect presentationPosition = [[obj.layer presentationLayer] frame];
        if(CGRectContainsPoint(presentationPosition, point)){
            [obj touchesBegan:touches withEvent:event];
            if([weakSelf.delegate respondsToSelector:@selector(gyChangeTextView:didTapedAtIndex:)]){
                [weakSelf.delegate gyChangeTextView:weakSelf didTapedAtIndex:obj.tag];
            }
            *stop = YES;
        }
    }];
    
}
//-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint point = [[touches anyObject] locationInView:self];
//    
//    [self.contentViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        // 获取tmpView的layer当前的位置
////        CGRect presentationPosition = [[obj.layer presentationLayer] frame];
////        if(CGRectContainsPoint(presentationPosition, point)){
//            [obj touchesCancelled:touches withEvent:event];
////            *stop = YES;
////        }
//    }];
//
//}
////- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
////    
////}
//-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGPoint point = [[touches anyObject] locationInView:self];
//    __weak typeof(self) weakSelf = self;
//    
//    [self.contentViews enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        // 获取tmpView的layer当前的位置
//        CGRect presentationPosition = [[obj.layer presentationLayer] frame];
//        if(CGRectContainsPoint(presentationPosition, point)){
//            [obj touchesEnded:touches withEvent:event];
//            if([weakSelf.delegate respondsToSelector:@selector(gyChangeTextView:didTapedAtIndex:)]){
//                [weakSelf.delegate gyChangeTextView:weakSelf didTapedAtIndex:obj.tag];
//            }
//                   NSLog(@"%ld===",obj.tag);
//            *stop = YES;
//        }
//    }];
//
//}
@end
