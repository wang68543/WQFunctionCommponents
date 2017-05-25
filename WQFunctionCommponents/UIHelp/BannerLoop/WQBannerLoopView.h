//
//  BannerLoopView.h
//  UIScrollView无限滚动
//
//  Created by WangQiang on 16/8/30.
//  Copyright © 2016年 itcast. All rights reserved.
//  当控制器的View上只有一个View且是ScollView的时候 会出问题

#import <UIKit/UIKit.h>

@class WQBannerLoopView;
@protocol BannerLoopViewDelegate <NSObject>
-(void)bannerLoopView:(WQBannerLoopView *)bannerLoopView didSelected:(NSInteger)index;

@end
@interface WQBannerLoopView : UIView
@property (strong ,nonatomic) NSArray *datas;
@property (weak ,nonatomic) id<BannerLoopViewDelegate> delegate;
@end
