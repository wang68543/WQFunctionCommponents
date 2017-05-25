//
//  WQCommonBaseCell.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCommonCellProtocol.h"

@class WQCommonBaseCell;

@protocol WQCommonBaseCellDelegate<NSObject>
@optional
-(void)commonBaseCellDidSwitchChange:(WQCommonBaseCell *)baseCell switchState:(BOOL)state;
@end

@interface WQCommonBaseCell : UITableViewCell<WQCommonCellProtocol>

@property (weak ,nonatomic) id<WQCommonBaseCellDelegate> delegate;
@property (strong ,nonatomic) WQCommonBaseItem *baseItem;

@end
