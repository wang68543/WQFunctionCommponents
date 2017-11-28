//
//  InputView.h
//  AttrbuteInput
//
//  Created by hejinyin on 2017/11/10.
//  Copyright © 2017年 hejinyin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQAttibuteInputDelegate<NSObject>
- (void)shouldUploadImage:(UIImage *)image compeletion:(void(^)(NSString * src ))compeletion;
@end
@interface WQAttibuteInputView : UIView
@property (strong  ,nonatomic) UIToolbar  *toolBar;

@property (weak    ,nonatomic) UIViewController *present;

@property (weak    ,nonatomic) id<WQAttibuteInputDelegate> delegate;


- (NSArray *)getResults;
@end
