//
//  SelectPhotoViewController.m
//  Guardian
//
//  Created by WangQiang on 2016/10/14.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQSelectPhotoController.h"
#import <Photos/Photos.h>

#import <WQBaseUIComponents/WQAPPHELP.h>
#import <WQBaseUIComponents/WQControllerTransition.h>

#define APP_WIDTH [[UIScreen mainScreen] bounds].size.width
#define APP_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define DivLineBG UIColorMake(225, 226, 230, 1.0)
#define subViewH  50
#define subBGColor(alph) [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:(alph)]
#define btnFont [UIFont systemFontOfSize:16.0]
@interface WQSelectPhotoController ()
@property (strong ,nonatomic) UIView *actionSheetView;
//@property (strong ,nonatomic,readonly) UIViewController *controller;
@property (strong ,nonatomic) WQControllerTransition *bottomTranstion;
@end

@implementation WQSelectPhotoController
+(instancetype)showSelectPhotoDelegate:(id<WQPhotoSelectedDelegate>) delegate inController:(UIViewController *)inController{
    WQSelectPhotoController *photoController = [[WQSelectPhotoController alloc] init];
    photoController.delegate = delegate;
    [photoController showInController:inController];
    return photoController;
}
-(WQControllerTransition *)bottomTranstion{
    if(!_bottomTranstion){
      _bottomTranstion =  [WQControllerTransition transitionWithAnimatedView:self.actionSheetView];
        _bottomTranstion.duration = 0.3;
    }
    return _bottomTranstion;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.actionSheetView];
 
}
-(UIView *)actionSheetView{
    if(!_actionSheetView){
        _actionSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_HEIGHT , APP_WIDTH, subViewH *3+4.0)];//- (subViewH *3+4.0)
    _actionSheetView.backgroundColor = [UIColor whiteColor];
    UIView *view1 = [self setupBtnWithTitleMessage:@"拍照" withTag:1];
    view1.frame = CGRectMake(0, 0, APP_WIDTH, subViewH);
    UIView *view2 =  [self setupBtnWithTitleMessage:@"从相册获取" withTag:2];
       view2.frame = CGRectMake(0, CGRectGetMaxY(view1.frame), APP_WIDTH, subViewH);
    UIView *cancelView =   [self setCancelButtonWithTitleMessage:@"取消"];
    cancelView.frame = CGRectMake(0, CGRectGetMaxY(view2.frame), APP_WIDTH, subViewH+4.0);
    }
    return _actionSheetView;
}

-(void)showInController:(UIViewController *)controller{
    if(!controller)controller = [WQAPPHELP visibleViewController];
//    _controller = controller;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    self.view.backgroundColor = [UIColor clearColor];
    
    //不自定义的情况下 使用下面两个也可以组合出透明的背景
//        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
//    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    //==============
    
//    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
//
    /*
     1.如果不自定义转场modal出来的控制器会移除原有的控制器
     2.如果自定义转场modal出来的控制器不会移除原有的控制器
     3.如果不自定义转场modal出来的控制器的尺寸和屏幕一样
     4.如果自定义转场modal出来的控制器的尺寸我们可以自己在containerViewWillLayoutSubviews方法中控制
     5.containerView 非常重要, 容器视图, 所有modal出来的视图都是添加到containerView上的
     6.presentedView() 非常重要, 通过该方法能够拿到弹出的视图
     */
    self.transitioningDelegate = self.bottomTranstion;
////    设置转场动画样式 (这个一定要设置不然会出现黑屏的情况)
    self.modalPresentationStyle = UIModalPresentationCustom;
    [controller presentViewController:self animated:YES completion:NULL];
}
#pragma mark -- 创建ActionSheet
/**
 *  其他按钮视图
 */
-(UIView *)setupBtnWithTitleMessage:(NSString *)message withTag:(NSInteger)tag{
    UIView *backView = [[UIView alloc] init];
    
    backView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [[UIButton alloc] init];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitle:message forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = btnFont;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.tag = tag;
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 0, APP_WIDTH, subViewH - 1.0);
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lineV.frame = CGRectMake(0, subViewH -1.0, APP_WIDTH, 1.0);
    [backView addSubview:lineV];
    [backView addSubview:btn];
    [_actionSheetView addSubview:backView];
    return backView;
}
/**
 *取消视图
 */
-(UIView *)setCancelButtonWithTitleMessage:(NSString *)message{
    
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor clearColor];
    UIButton *btn = [[UIButton alloc] init];
    btn.adjustsImageWhenHighlighted = NO;
    [btn setTitle:message forState:UIControlStateNormal];
    btn.tag = 0;
    [btn addTarget:self action:@selector(cancelDidClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = btnFont;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(0, 5.0, APP_WIDTH, subViewH - 5.0);
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    lineV.frame = CGRectMake(0, 0, APP_WIDTH, 5.0);
    [backView addSubview:lineV];
    [backView addSubview:btn];
    [_actionSheetView addSubview:backView];
    return backView;
    
}

-(void)cancelDidClicked{
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark --打开照相机
- (void)openCamera{
    [self openMediaWithSourceType:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark --打开相册
- (void)openAlbum{
    [self openMediaWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma mark -- 私有方法 
- (void)openMediaWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]){
        NSLog(@"此功能不支持");
        
        return;
    }
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.allowsEditing = self.allowsEditing;
    ipc.sourceType = sourceType;
    ipc.delegate = self;
 
    UINavigationBar *navBar = [UINavigationBar appearance];
    if (!navBar.barTintColor) {
         ipc.navigationBar.barTintColor = [UIColor blueColor];
    }
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark --UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    UIViewController *rootVC = self.presentingViewController;
//    while (rootVC.presentingViewController) {
//        rootVC = rootVC.presentingViewController;
//    }
//    [rootVC dismissViewControllerAnimated:YES completion:nil];
//
////    [picker dismissViewControllerAnimated:NO completion:NULL];
    __weak typeof(self) weakSelf = self;
    //self.controller 选中了 同时让当前控制器也销毁
    //self.controller
    /*
     * 在之前的文档中可以看到，在A中执行dismissViewController方法，B会被直接remove掉，这个毫无问题。但是如果A present B和dismiss B用的是自定义动画，那么即使此时并不执行B的dismiss动画，依然会有问题
     */
    //如果 调用系统的一些方法没响应 很大几率是其他分类替换掉了
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        //
        if([weakSelf.delegate respondsToSelector:@selector(photoSelectedViewDidFinshSelectedImage:)]){
            [weakSelf.delegate photoSelectedViewDidFinshSelectedImage:info[UIImagePickerControllerOriginalImage]];
        }else if([weakSelf.delegate respondsToSelector:@selector(photoSelectedViewDidFinshSelected:)]){
                [weakSelf.delegate photoSelectedViewDidFinshSelected:info];
        }else if (weakSelf.didFinshSelectedImageInfo){
            weakSelf.didFinshSelectedImageInfo(info);
        }else if (weakSelf.didFinshSelectedImage){
            weakSelf.didFinshSelectedImage(info[UIImagePickerControllerOriginalImage]);
        }else{
            NSAssert(NO, @"没有实现图片选择回调功能");
        }

    }];
}
//如果 运行时被拦截 这里就不好
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark --其他视图的点击事件
-(void)buttonDidClicked:(UIButton *)btn{
    if(1 == btn.tag){//拍照
        [self openCamera];
    }else if(2 == btn.tag){//相册
        [self openAlbum];
    }
}
- (void)dealloc
{
    NSLog(@"销毁了");
}
@end
