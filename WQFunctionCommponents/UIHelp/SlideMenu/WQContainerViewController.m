//
//  WQContainerViewController.m
//  SlideMenu
//
//  Created by WangQiang on 2016/12/11.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQContainerViewController.h"
#import "MainTabBarController.h"
#import "MainNavController.h"

@interface WQContainerViewController ()<MenuControllerDelegate>

@property (assign ,nonatomic) NSUInteger controllerIndex;
//@property (assign ,nonatomic) BOOL isSame;
-(void)addMenuController;
-(void)addContentControllers;
@end

@implementation WQContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _menumWidth = 180.0;
    _animateDuration = 0.15;
    [self addMenuController];
    [self addContentControllers];
}

-(void)addMenuController{
    [self setMenuController:[[MenuViewController alloc] init]];
    [self.menuController setDelegate:self];
    [self addChildViewController:self.menuController];
    [self.view addSubview:self.menuController.view];
}
-(void)addContentControllers{
    UIViewController *firstController = [[UIViewController alloc] init];
    firstController.title = @"First";
    firstController.view.backgroundColor = [UIColor orangeColor];
    MainNavController *navFirstController = [[MainNavController alloc] initWithRootViewController:firstController];
    
    UIViewController *secondController = [[UIViewController alloc] init];
    secondController.view.backgroundColor = [UIColor whiteColor];
    secondController.title = @"Second";
    MainNavController *navSecondController = [[MainNavController alloc] initWithRootViewController:secondController];
    [self setViewControllers:@[navFirstController,navSecondController]];
    [self setContentViewController:navFirstController];
    
//    MainTabBarController *tabBarController = [[MainTabBarController alloc] init];
//    [self setContentViewController:tabBarController];
}
-(void)setContentViewController:(UIViewController *)contentViewController{
    if(_contentViewController == contentViewController) return;
    
    //确保新添加的transform与之前的transform保持一致 不然后期添加的view的动画很快
    if(_contentViewController){
         contentViewController.view.transform = _contentViewController.view.transform;
    }
    
    //nil 表示从父控制器移除
    [_contentViewController willMoveToParentViewController:nil];
    [_contentViewController.view removeFromSuperview ];
    //解除父子控制关系
    [_contentViewController removeFromParentViewController];
    
    _contentViewController = contentViewController;
    [self addChildViewController:_contentViewController];
    [self.view addSubview:_contentViewController.view];
    
}
// MARK: 关闭菜单栏
-(void)closeMenum{
    _isAnimating = YES;
    [UIView animateWithDuration:_animateDuration animations:^{
        self.contentViewController.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _isAnimating = NO;
        _isMenuOpen = NO;
    }];
}
// MARK: 之前没有开启菜单 这里开启新的菜单
-(void)openNewMenum{
     _isAnimating = YES;
    [UIView animateWithDuration:_animateDuration animations:^{
        self.contentViewController.view.transform = CGAffineTransformMakeTranslation(_menumWidth, 0);
    } completion:^(BOOL finished) {
         _isAnimating = NO;
        _isMenuOpen = YES;
    }];
}
// MARK: 打开新的关闭旧的
-(void)openNewAndCloseOldMenum{
    _isAnimating = YES;
    [UIView animateWithDuration:_animateDuration animations:^{
        self.contentViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds), 0);
    } completion:^(BOOL finished) {
        [self setContentViewController:self.viewControllers[self.controllerIndex]];//设置新的
        [UIView animateWithDuration:_animateDuration animations:^{
            self.contentViewController.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            _isAnimating = NO;
            _isMenuOpen = NO;
        }];
    }];
}
// MARK: 导航栏上的菜单按钮点击响应事件
-(void)openCloseMenum{
    if(_isMenuOpen){
        [self closeMenum];
    }else{
        [self openNewMenum];
    }
//    if(_isAnimating)return;
//    [UIView animateWithDuration:_animateDuration animations:^{
//        _isAnimating = YES;
//        if(!_isMenuOpen){
//            self.contentViewController.view.transform = CGAffineTransformMakeTranslation(_menumWidth, 0);
//        }else{
//            self.contentViewController.view.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds), 0);
//        }
//    }completion:^(BOOL finished) {
//        _isMenuOpen = !_isMenuOpen;
//        [self setContentViewController:self.viewControllers[self.controllerIndex]];
//        if(!_isMenuOpen){
//            [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.contentViewController.view.transform = CGAffineTransformIdentity;
//            } completion:^(BOOL finished) {
//                _isAnimating = NO;
//            }];
//        }else{
//            _isAnimating = NO;
//        }
//    } ];
}

#pragma mark -- MenuControllerDelegate
-(void)menuController:(MenuViewController *)menuController didSelectItemAtIndex:(NSInteger)index{
    
//    MainTabBarController *tabBarController = (MainTabBarController *)self.contentViewController;
//    
//    if(index == 0){
//        FirstViewController *firstController  = [[FirstViewController alloc] init];
//        [(UINavigationController *)tabBarController.selectedViewController pushViewController:firstController animated:NO];
//    }else{
//        SecondViewController *secondController  = [[SecondViewController alloc] init];
//        [(UINavigationController *)tabBarController.selectedViewController pushViewController:secondController animated:NO];
//    }
    if(self.controllerIndex == index){
        [self closeMenum];
    }else{
     [self setControllerIndex:index];
     [self openNewAndCloseOldMenum];
    }
    
    
//    [self openCloseMenum];
}

@end
