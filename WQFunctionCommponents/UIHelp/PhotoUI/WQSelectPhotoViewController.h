//
//  SelectPhotoViewController.h
//  Guardian
//
//  Created by WangQiang on 2016/10/14.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PhotoSelectedViewControllerDelegate <NSObject>
@optional
-(void)photoSelectedViewDidFinshSelectedImage:(UIImage *)image;
-(void)photoSelectedViewDidFinshSelected:(NSDictionary *)info;
@end
@interface WQSelectPhotoViewController : UIViewController
@property (assign ,nonatomic) BOOL allowsEditing;
-(void)showInController:(UIViewController *)controller;
@property (weak ,nonatomic) id<PhotoSelectedViewControllerDelegate> delegate;
@end
