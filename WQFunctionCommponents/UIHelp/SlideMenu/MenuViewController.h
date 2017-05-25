//
//  MenuViewController.h
//  SlideMenu
//
//  Created by WangQiang on 2016/12/11.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuViewController;
@protocol MenuControllerDelegate<NSObject>
-(void)menuController:(MenuViewController *)menuController didSelectItemAtIndex:(NSInteger)index;
@end
@interface MenuViewController : UIViewController
@property (weak ,nonatomic) id<MenuControllerDelegate> delegate;
@end
