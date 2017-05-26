//
//  MainNavController.m
//  SlideMenu
//
//  Created by WangQiang on 2016/12/14.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "MainNavController.h"
#import "WQContainerViewController.h"

@interface MainNavController ()

@end

@implementation MainNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.navigationController.view.layer setShadowOffset:CGSizeMake(-10.0, 0.0)];
    [self.navigationController.view.layer setShadowOpacity:0.15];
    [self.navigationController.view.layer setShadowRadius:10];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count == 0){
        UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(openCloseMenum:)];
        [viewController.navigationItem setLeftBarButtonItem:menuItem];
       
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        [viewController.navigationItem setRightBarButtonItem:backItem];
    }
    [super pushViewController:viewController animated:animated];
}
-(void)back:(UIBarButtonItem *)backItem{
    [self.parentViewController.navigationController setNavigationBarHidden:NO animated:NO];
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
    
    
}
-(void)openCloseMenum:(UIBarButtonItem *)menuItem{
    UIViewController *childViewController = self;
    while (1) {
        UIViewController *parentViewController = childViewController.parentViewController;
        if([parentViewController isKindOfClass:[WQContainerViewController class]]){
            [parentViewController performSelector:@selector(openCloseMenum)];
            break;
        }else{
            childViewController = parentViewController;
        }
    }
}

@end
