//
//  MainTabBarController.m
//  SlideMenu
//
//  Created by WangQiang on 2016/12/14.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "MainTabBarController.h"
#import "MainNavController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController *itemOneController = [[UIViewController alloc] init];
    [itemOneController setTitle:@"One"];
    [itemOneController.view setBackgroundColor:[UIColor blackColor]];
    MainNavController *navOneController = [[MainNavController alloc] initWithRootViewController:itemOneController];
    
    UIViewController *itemTwoController = [[UIViewController alloc] init];
    [itemTwoController setTitle:@"Two"];
    [itemTwoController.view setBackgroundColor:[UIColor whiteColor]];
    MainNavController *navTwoController = [[MainNavController alloc] initWithRootViewController:itemTwoController];
    
    [self setViewControllers:@[navOneController,navTwoController]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
