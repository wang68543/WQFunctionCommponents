//
//  MenuViewController.m
//  SlideMenu
//
//  Created by WangQiang on 2016/12/11.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    [self addMenuItems];
}
-(void)addMenuItems{
    UIButton *item1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [item1 setFrame:CGRectMake(0, 100, 180, 40)];
    [item1 setBackgroundColor:[UIColor orangeColor]];
    [item1 setTitle:@"item1" forState:UIControlStateNormal];
    [item1.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [item1 setTag:0];
    [self.view addSubview:item1];
    
    UIButton *item2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [item2 setFrame:CGRectMake(0, 140, 180, 40)];
    [item2 setBackgroundColor:[UIColor orangeColor]];
    [item2 setTitle:@"item2" forState:UIControlStateNormal];
    [item2.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [item2 setTag:1];
    [self.view addSubview:item2];
    
    [item1 addTarget:self action:@selector(menuItemSelected:) forControlEvents:UIControlEventTouchUpInside];
    
    [item2 addTarget:self action:@selector(menuItemSelected:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)menuItemSelected:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(menuController:didSelectItemAtIndex:)]){
        [self.delegate menuController:self didSelectItemAtIndex:sender.tag];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
