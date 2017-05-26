//
//  WQAlertBottomViewProtocol.h
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/24.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#ifndef WQAlertBottomViewProtocol_h
#define WQAlertBottomViewProtocol_h

@protocol WQAlertBottomViewDelegate <NSObject>
- (void)bottomViewDidClickConfirmAction;
- (void)bottomViewDidClickCancelAction;
@end

@protocol WQAlertBottomViewProtocol <NSObject>
@property (weak ,nonatomic) id<WQAlertBottomViewDelegate> delegate;
-(CGFloat)heightForView;
+(instancetype)bottomViewWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle;
@optional
@property (copy ,nonatomic) NSString *cancelTitle;
@property (copy ,nonatomic) NSString *confirmTitle;
/**底部标题属性*/
@property (strong ,nonatomic) NSDictionary * cancelAttribute;
@property (strong ,nonatomic) NSDictionary * confirmAttribute;
-(instancetype)initWithConfirmTitle:(NSString *)confirmTitle cancelTitle:(NSString *)cancelTitle;

@end


#endif /* WQAlertBottomViewProtocol_h */
