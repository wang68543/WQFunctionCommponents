//
//  WQCommonDataResource.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/1.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WQCommonGroup.h"


@interface WQCommonDataResource : NSObject<UITableViewDataSource,UITableViewDelegate>
+(instancetype)configTableViewDelegateAndDataSource:(UITableView *)tableView;
@property (strong ,nonatomic,readonly) NSArray<WQCommonGroup *> *groups;

-(void)addGroups:(NSArray <WQCommonGroup *>*)groups;
@end
