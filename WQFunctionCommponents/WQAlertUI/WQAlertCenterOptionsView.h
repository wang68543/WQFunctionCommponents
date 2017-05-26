//
//  WQAlertCenterOptionsView.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/5.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQAlertCenterOptionsView : UIView
+(instancetype)optionsView;
@property (strong ,nonatomic,readonly) UITableView *tableView;


@end
