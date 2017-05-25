//
//  ShareActionItem.m
//  AirMonitor
//
//  Created by WangQiang on 16/5/21.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQShareActionItem.h"

@implementation WQShareActionItem
+(instancetype)shareActionItemWithIcon:(NSString *)icon shareType:(ShareActionType)shareType{
    return [[self alloc] initItemWithIcon:icon shareType:shareType];
}
-(instancetype)initItemWithIcon:(NSString *)icon shareType:(ShareActionType)shareType{
    if(self = [super init]){
        self.shareType = shareType;
        self.icon = icon;
    }
    return self;
}
-(void)setShareType:(ShareActionType)shareType{
    _shareType = shareType;
    // 这里可以设置对应第三方的实际类型
//    switch (_shareType) {
//        case ShareActionTypeQQ:
//            self.externShareType = UMShareToQQ;
//            break;
//        case ShareActionTypeQzone:
//            self.externShareType = UMShareToQzone;
//            break;
//        case ShareActionTypeSina:
//            self.externShareType = UMShareToSina;
//            break;
//        case ShareActionTypeTencent:
//            self.externShareType = UMShareToTencent;
//            break;
//        case ShareActionTypeWechatSession:
//            self.externShareType = UMShareToWechatSession;
//            break;
//        case ShareActionTypeWechatTimeline:
//            self.externShareType = UMShareToWechatTimeline;
//            break;
//        default:
//            break;
//    }
}
@end
