//
//  BannerLoopView.m
//  UIScrollView无限滚动
//
//  Created by WangQiang on 16/8/30.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "WQBannerLoopView.h"

@interface WQBannerLoopView ()<UIScrollViewDelegate>{
    UIImageView *_reusableView; // 循环利用的
    UIImageView *_centerView; // 中间的
    CGFloat _pageW;
    UIVisualEffectView *_pageBackground;
}
@property (strong ,nonatomic) UIScrollView *scrollView;
@property (strong ,nonatomic) UIPageControl *pageControl;

@end
@implementation WQBannerLoopView
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
 static NSString * const offset = @"offset";
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _pageW = frame.size.width;
        self.scrollView.frame = self.bounds;
        _scrollView.contentSize = CGSizeMake(_pageW * 3, 0);
        
        [self addSubview:self.scrollView];
        
        _centerView = [[UIImageView alloc] init];
        _centerView.frame = CGRectMake(_pageW, 0, _pageW, frame.size.height);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedImageView:)];
        _centerView.userInteractionEnabled = YES;
        [_centerView addGestureRecognizer:tapGesture];
        [_scrollView addSubview:_centerView];
        
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelectedImageView:)];
        
        _reusableView = [[UIImageView alloc] init];
        _reusableView.frame = _scrollView.bounds;
        _reusableView.userInteractionEnabled = YES;
        [_reusableView addGestureRecognizer:tapGesture2];
        
        _pageBackground =  [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect  effectWithStyle:UIBlurEffectStyleLight]];
        _pageBackground.alpha = 0.8;
        [self addSubview:_pageBackground];
        _pageBackground.frame = CGRectMake(0, frame.size.height - 30, _pageW, 30.0);
        
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.currentPageIndicatorTintColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [_pageBackground addSubview:_pageControl];
    }
    return self;
}
-(void)setDatas:(NSArray *)datas{
    _datas = datas;
    //
    CGSize size = [_pageControl sizeForNumberOfPages:datas.count];
    _pageControl.numberOfPages = datas.count;
    _pageControl.frame = CGRectMake(_pageW  - size.width - 20, 0,size.width, _pageBackground.frame.size.height);
     _centerView.image = [UIImage imageNamed:[datas firstObject]];
    _centerView.tag = 0;
    _scrollView.contentOffset = CGPointMake(_pageW, 0);
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat w = scrollView.frame.size.width;
    CGRect f = _reusableView.frame;
    NSInteger index = 0;
    if (offsetX > _centerView.frame.origin.x) { // 显示在最右边
        f.origin.x = scrollView.contentSize.width - w;
        index = _centerView.tag + 1;
        if (index >= self.datas.count) index = 0;
    } else { // 显示在最左边
        f.origin.x = 0;
        
        index = _centerView.tag - 1;
        if (index < 0) index = self.datas.count - 1;
    }
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
    _reusableView.frame = f;
    _reusableView.tag = index;
//    NSString *icon = [NSString stringWithFormat:@"0%ld.jpg", index];
    NSString *icon = self.datas[index];
    _reusableView.image = [UIImage imageNamed:icon];
   
    // 2.显示了 最左 或者 最右 的图片
    if (offsetX < 0 || offsetX > w * 2) {
        UIImageView *temp = _centerView;
        _centerView = _reusableView;
        _reusableView = temp;
        // 2.2.设置显示位置
        _centerView.layer.position = _reusableView.layer.position;
        scrollView.contentOffset = CGPointMake(w, 0);
        //下面两步也可以 scrollview初始化加进去
        [_reusableView removeFromSuperview];
    } else {
        [_scrollView insertSubview:_reusableView atIndex:0];
        
    }
//    [CATransaction commit];
    _pageControl.currentPage = _centerView.tag;
}
-(void)didSelectedImageView:(UITapGestureRecognizer *)tapGesture{
    if([self.delegate respondsToSelector:@selector(bannerLoopView:didSelected:)]){
        [self.delegate bannerLoopView:self didSelected:tapGesture.view.tag];
    }
}
@end
