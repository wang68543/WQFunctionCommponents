//
//  WQCommonCustomItem.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/1.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseItem.h"
//#import "WQCommonCellProtocol.h"

@interface WQCommonCustomItem : WQCommonBaseItem
+(NSString *)customIdentifire;
/**须遵守 WQCommonCellProtocol*/
@property (assign ,nonatomic) Class cellClass;
@end
