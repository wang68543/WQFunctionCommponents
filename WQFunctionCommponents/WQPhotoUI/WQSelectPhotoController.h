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

/**
 NSPhotoLibraryAddUsageDescription iOS11之后 相册写需要添加这个
 */
@interface WQSelectPhotoController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate>
+(instancetype)showSelectPhotoDelegate:(id<WQPhotoSelectedDelegate>) delegate inController:(UIViewController *)inController;

@property (assign ,nonatomic) BOOL allowsEditing;

-(void)showInController:(UIViewController *)controller;

/** 代理方法实现了 优先调用代理方法 */
@property (weak ,nonatomic) id<WQPhotoSelectedDelegate> delegate;

/** 回调单张图片 */
@property (copy    ,nonatomic) void (^didFinshSelectedImage)(UIImage *image);
/** 回调图片信息 */
@property (copy    ,nonatomic) void (^didFinshSelectedImageInfo)(NSDictionary *imageInfo);
@end
