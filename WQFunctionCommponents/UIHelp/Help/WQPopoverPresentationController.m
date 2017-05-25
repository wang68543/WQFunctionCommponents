//
//  WQPopoverPresentationController.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/1.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQPopoverPresentationController.h"

@implementation WQPopoverPresentationController
// 默认返回的是覆盖整个屏幕，需设置成UIModalPresentationNone。
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
// 设置点击蒙版是否消失，默认为YES
- (BOOL)popoverPresentationControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    return YES;
}
// 弹出视图消失后调用的方法
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
}
@end
