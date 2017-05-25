//
//  WQCommonCellProtocol.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/1.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#ifndef WQCommonCellProtocol_h
#define WQCommonCellProtocol_h
#import "WQCommonGroup.h"

@protocol WQCommonCellProtocol <NSObject>
@required
@property (strong ,nonatomic) WQCommonBaseItem * _Nonnull baseItem;
@optional
- (instancetype _Nullable )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier;
+ (instancetype _Nullable )alloc;
@end

#endif /* WQCommonCellProtocol_h */
