//
//  SelectPhotoViewController.h
//  Guardian
//
//  Created by WangQiang on 2016/10/14.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WQPhotoSelectedDelegate <NSObject>
@optional
-(void)photoSelectedViewDidFinshSelectedImage:(UIImage *)image;
-(void)photoSelectedViewDidFinshSelected:(NSDictionary *)info;
//FIXME: 暂时还没有实现 
-(void)photoSelectedViewDidFinshSelectedImages:(NSArray *)images;
@end
@interface WQSelectPhotoController : UIViewController
+(instancetype)showSelectPhotoDelegate:(id<WQPhotoSelectedDelegate>) delegate inController:(UIViewController *)inController;

@property (assign ,nonatomic) BOOL allowsEditing;
-(void)showInController:(UIViewController *)controller;
@property (weak ,nonatomic) id<WQPhotoSelectedDelegate> delegate;

@end
