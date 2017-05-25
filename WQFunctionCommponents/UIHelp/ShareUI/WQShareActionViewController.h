//
//  ShareActionViewController.h
//  AirMonitor
//
//  Created by WangQiang on 16/5/21.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQShareActionItem.h"

@protocol ShareActionDelegate <NSObject>

-(void)shareActionDidSelected:(WQShareActionItem *)item;

@optional
-(void)shareActionDidCancel;
@end
@interface WQShareActionViewController : UIViewController
-(void)showInController:(UIViewController *)inVC;
@property (assign ,nonatomic) id <ShareActionDelegate> delegate;
@end
