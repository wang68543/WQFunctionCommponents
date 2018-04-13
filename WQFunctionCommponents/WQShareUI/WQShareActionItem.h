//
//  ShareActionItem.h
//  AirMonitor
//
//  Created by WangQiang on 16/5/21.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger , ShareActionType) {
    ShareActionTypeQQ,
    ShareActionTypeQzone,
    ShareActionTypeSina,
    ShareActionTypeTencent,
    ShareActionTypeWechatSession,//微信好友
    ShareActionTypeWechatTimeline,//微信朋友圈
    
};
@interface WQShareActionItem : NSObject

/**
 分享的图标
 */
@property (copy ,nonatomic) NSString *icon;

/**
 自定义的分享类型
 */
@property (assign ,nonatomic) ShareActionType shareType;

/**
 对应的第三方分享类型
 */
@property (copy ,nonatomic) NSString *externShareType;
+(instancetype)shareActionItemWithIcon:(NSString *)icon shareType:(ShareActionType)shareType;
@end
