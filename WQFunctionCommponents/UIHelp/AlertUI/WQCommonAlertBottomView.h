//
//  WQCommonAlertBottomView.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQAlertBottomViewProtocol.h"

@interface WQCommonAlertBottomView : UIView<WQAlertBottomViewProtocol>
@property (copy ,nonatomic) NSString *confirmTitle;
@property (weak ,nonatomic) id<WQAlertBottomViewDelegate> delegate;
@property (copy ,nonatomic) NSString *cancelTitle;
/**底部标题属性*/
@property (strong ,nonatomic) NSDictionary * cancelAttribute;
@property (strong ,nonatomic) NSDictionary * confirmAttribute;
+(instancetype)bottomViewWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle;
-(instancetype)initWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle;

-(CGFloat)heightForView;
@end
