//
//  WQContainerViewController.h
//  SlideMenu
//
//  Created by WangQiang on 2016/12/11.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface WQContainerViewController : UIViewController
@property (strong ,nonatomic) MenuViewController *menuController;
@property (strong ,nonatomic) UIViewController *contentViewController;
@property (strong ,nonatomic) NSArray *viewControllers;
@property (assign ,nonatomic ,readonly) BOOL isMenuOpen;
@property (assign ,nonatomic ,readonly) BOOL isAnimating;

/**左侧菜单的宽度*/
@property (assign ,nonatomic) CGFloat menumWidth;
/**动画时长*/
@property (assign ,nonatomic) CGFloat animateDuration;
-(void)openCloseMenum;
@end
