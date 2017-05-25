//
//  BottomTransition.m
//  SomeUIKit
//
//  Created by WangQiang on 2016/11/1.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQControllerTransition.h"

typedef void(^AnmationCompeletion)(BOOL finished);
@interface WQControllerTransition()<CAAnimationDelegate,UIGestureRecognizerDelegate>{
    id <UIViewControllerContextTransitioning> _transitionContext;
}
@property (weak ,nonatomic) UIView *animatedView;
@property (assign ,nonatomic) BOOL interactive;


@property (strong ,nonatomic) UIPercentDrivenInteractiveTransition *interactionController;
@property (weak ,nonatomic) UITabBarController *tabBarController;

@property (weak ,nonatomic) UINavigationController *navgationController;
@end
@implementation WQControllerTransition
#pragma mark -- 子View转场初始化方式
+(nonnull instancetype)transitionWithAnimatedView:(nullable UIView *)animatedView{
    return [[self alloc] initTransitionWithAnimatedView:animatedView];
}
-(instancetype)initTransitionWithAnimatedView:(nullable UIView *)animatedView{
    if(self = [super init]){
        self.animatedView = animatedView;
        [self defaultOneSubViewInit];
    }
    return self;
}
#pragma mark -- tabBarController支持左右滑动初始化方式
+(instancetype)transitionWithTabBarController:(UITabBarController *)tabBarController{
    NSAssert([tabBarController isKindOfClass:[UITabBarController class]], @"此方法只支持TabBarController初始化");
    return [[self alloc] initTransitionWithTabBarController:tabBarController];
}
-(instancetype)initTransitionWithTabBarController:(UITabBarController *)tabBarController{
    if(self = [super init]){
        _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleTabBarPan:)];
        [tabBarController.view addGestureRecognizer:panGR];
        tabBarController.delegate = self;
        _tabBarController = tabBarController;
        [self defaultSuperViewInit];
    }
    return self;
}

+(instancetype)transitionWithNavigationController:(UINavigationController *)navigationController{
    return [[self alloc] initWithNavigationController:navigationController];
}
-(instancetype)initWithNavigationController:(UINavigationController *)navigationController{
    if(self = [super init]){
        _interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        UIGestureRecognizer *gesture = navigationController.interactivePopGestureRecognizer;
        gesture.enabled = NO;
        UIView *gestureView = gesture.view;
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavPan:)];
        panGR.delegate = self;
        panGR.maximumNumberOfTouches = 1;
        [gestureView addGestureRecognizer:panGR];
        
        navigationController.delegate = self;
        _navgationController = navigationController;
        [self defaultSuperViewInit];
    }
    return self;
}
#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    /**
     *  这里有两个条件不允许手势执行，1、当前控制器为根控制器；2、如果这个push、pop动画正在执行（私有属性）
     */
    if(self.navgationController){
      return self.navgationController.viewControllers.count != 1 && ![[self.navgationController valueForKey:@"_isTransitioning"] boolValue];
    }
    return YES;
}
-(instancetype)init{
    if(self = [super init]){
        [self defaultOneSubViewInit];
    }
    return self;
}
-(void)defaultSuperViewInit{
    _showOneSubViewType = ShowOneSubviewTypeDefault;
    _duration = 0.25;
    [self defaultCommonInit];
}
-(void)defaultOneSubViewInit{
    _showOneSubViewType = ShowOneSubviewFromDownToBottom;
    _animationType = AnimationTypeNormal;
    _showSuperViewType = ShowSuperViewTypeDefault;
    _duration = 0.5;
    [self defaultCommonInit];
}
-(void)defaultCommonInit{
//     _present = YES;
      _reverseDismiss = YES;
}
#pragma mark -- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC {
    /**
     *  方法1中判断如果当前执行的是Pop操作，就返回我们自定义的Pop动画对象。
     */
    if (operation == UINavigationControllerOperationPop){
        _present = NO;
        _showSuperViewType = ShowSuperViewTypePop;
        return self;
    }else if(operation == UINavigationControllerOperationPush){
         /** 自定义push动画的话 如果在调用pushViewController之前 将要显示的View 不存在 就会出现黑屏问题 并且如果View是通过Xib创建的话 view的布局是按照xib的布局来 不会根据屏幕进行收缩*/
        _present = YES;
        _showSuperViewType = ShowSuperViewTypePush;
        return self;
    }
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    /**
     *  方法2会传给你当前的动画对象animationController，判断如果是我们自定义的Pop动画对象，那么就返回interactivePopTransition来监控动画完成度。
     */
    
    return self.interactive? self.interactionController :nil;
//    return self.interactionController;
}

#pragma mark -- ViewController Transitioning Delegate
// MARK: - UIViewControllerTransitioningDelegate
// 该方法用于返回一个负责转场动画的对象
// 可以在该对象中控制弹出视图的尺寸等

//这里下面可以自定义一个类 遵守UIViewControllerAnimatedTransitioning协议可以在其中实现UIViewControllerInteractiveTransitioning协议的方法进行自定义动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    _present = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    _present = NO;
    return self;
}


#pragma mark -- ViewController Interactive Transitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    //return [transitionContext isAnimated] ? 0.55 : 0;
    return self.duration;
}
#pragma mark -- TabBarController  Delegate
// MARK: 这里参考的 http://chuansong.me/n/2672777  
- (nullable id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController
                               interactionControllerForAnimationController: (id <UIViewControllerAnimatedTransitioning>)animationController{
    return self.interactive? _interactionController:nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                                       toViewController:(UIViewController *)toVC{
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    _showSuperViewType = toIndex < fromIndex ? ShowSuperViewTypeTabLeft:ShowSuperViewTypeTabRight;
    _present = YES;
    return self;
}
#pragma mark -- 控制器的View只有一个子View的时候 使用这个动画 只动画子view的frame跟父View的的背景色
-(void)animationOneSubView:(id <UIViewControllerContextTransitioning>)transitionContext{
   //viewForKey:方法返回 nil 只有一种情况：  UIModalPresentationCustom 模式下的 Modal 转场 ，通过此方法获取 presentingView 时得到的将是 nil
    //UIModalPresentationCustom 这种模式下的 Modal 转场结束时 fromView 并未从视图结构中移除 UIModalPresentationFullScreen 模式的 Modal 转场结束后 fromView 依然主动被从视图结构中移除了
    
    //iOS8 协议添加了viewForKey:方法以方便获取 fromView 和 toView，但是在 Modal 转场里要注意，从上面可以知道，Custom 模式下，presentingView 并不受 containerView 管理，这时通过viewForKey:方法来获取 presentingView 得到的是 nil，必须通过viewControllerForKey:得到 presentingVC 后来获取。因此在 Modal 转场中，较稳妥的方法是从 fromVC 和 toVC 中获取 fromView 和 toView。
    
    //TODO:viewControllerForKey 获取的两个控制器显示或消失的时候都不为空 viewForKey获取的View只能够获到弹出的View(弹出的时候用UITransitionContextToViewKey获取弹出的View 消失的时候用UITransitionContextFromViewKey获取之前被弹出的View)
    /**
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    NSLog(@"%@----%@",toViewController,fromViewController);
    NSLog(@"%@----%@",[transitionContext viewForKey:UITransitionContextToViewKey],[transitionContext viewForKey:UITransitionContextFromViewKey]);
    */
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIColor *viewBackColor ;
    //    CGAffineTransform  transform;

    if(!self.animatedView) self.animatedView = [toView.subviews firstObject];
    CGRect targetFrame = self.animatedView.frame;
    
    if(toView){//显示动画
//        _present = YES;
        CGRect orignalFrame = self.animatedView.frame;
        UIView *containerView = [transitionContext containerView];
        [containerView addSubview:toView];
        viewBackColor =  self.targetBackColor ?self.targetBackColor:[[UIColor blackColor] colorWithAlphaComponent:0.5];
        //        transform = CGAffineTransformMakeTranslation(0, -self.actionSheetView.height);
        
        switch (_showOneSubViewType) {
            case ShowOneSubviewFromDownToBottom:
                orignalFrame.origin.y = toView.frame.size.height;
                targetFrame.origin.y = toView.frame.size.height - targetFrame.size.height;
                break;
            case ShowOneSubviewFromDownToMiddleCenter:
                orignalFrame.origin.y = toView.frame.size.height;
                
                targetFrame.origin.y = toView.center.y - targetFrame.size.height*0.5;
                targetFrame.origin.x = (CGRectGetWidth(toView.frame) - CGRectGetWidth(orignalFrame))*0.5;
                break;
            case ShowOneSubviewFromTopToMiddleCenter:
                orignalFrame.origin.y = -orignalFrame.size.height;
                
                targetFrame.origin.y = toView.center.y - targetFrame.size.height*0.5;
                targetFrame.origin.x = (CGRectGetWidth(toView.frame) - CGRectGetWidth(orignalFrame))*0.5;
                break;
            case ShowOneSubviewMiddleCenterFlipTopToDown:
                orignalFrame.origin.y = -orignalFrame.size.height;
                
                targetFrame.origin.y = toView.center.y - targetFrame.size.height*0.5;
                targetFrame.origin.x = (CGRectGetWidth(toView.frame) - CGRectGetWidth(orignalFrame))*0.5;
                break;
            case ShowOneSubviewTypeCustom:
                orignalFrame = CGRectIsEmpty(self.orignalFrame)?self.animatedView.frame:self.orignalFrame;
                //先弄一个默认的位置(默认显示在底部) 以防目标frame为空
                targetFrame.origin.y = toView.frame.size.height - targetFrame.size.height;
                targetFrame = CGRectIsEmpty(self.targetFrame)?targetFrame:self.targetFrame;
                break;
                
            default:
                break;
        }
        //预设好动画的初始状态
        toView.backgroundColor = self.origanlBackColor ? self.origanlBackColor:[UIColor clearColor];
        //        toView.backgroundColor = viewBackColor;
        self.animatedView.frame = orignalFrame;//先摆好要动画的View的位置
    }else{//消失动画
//        _present = NO;
        toView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        
        viewBackColor = self.origanlBackColor?self.origanlBackColor:[UIColor clearColor];
        //        transform = CGAffineTransformIdentity;
        
        //回到初始的值
        
        switch (_showOneSubViewType) {
            case ShowOneSubviewFromDownToBottom:
                targetFrame.origin.y = toView.frame.size.height;
                break;
            case ShowOneSubviewFromDownToMiddleCenter:
                targetFrame.origin.y = toView.frame.size.height;
                break;
            case ShowOneSubviewFromTopToMiddleCenter:
                targetFrame.origin.y = -targetFrame.size.height;
                break;
            case ShowOneSubviewMiddleCenterFlipTopToDown:
                targetFrame.origin.y = toView.frame.size.height;
                break;
            case ShowOneSubviewTypeCustom:
                targetFrame.origin.y = toView.frame.size.height;
                targetFrame = CGRectIsEmpty(self.orignalFrame)?targetFrame:self.orignalFrame;
                break;
            default:
                targetFrame = CGRectZero;
                break;
        }
        
    }
    __weak typeof(self) weakSelf = self;

    AnmationCompeletion animationCompletion = ^(BOOL finshed){
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    };
    
    //先预设初始的frame
    if(_animationType == AnimationTypeSpring){
        /**
         *  usingSpringWithDamping 范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显
         *  initialSpringVelocity 则表示初始的速度，数值越大一开始移动越快 值得注意的是，初始速度取值较高而时间较短时，也会出现反弹情况。
         */
        dispatch_block_t backColorAnimation = ^{
            toView.backgroundColor = viewBackColor;
        };
        [self normalAnmiation:backColorAnimation completion:NULL];
        dispatch_block_t subViewFrameAnimation = ^{
            if(weakSelf.animatedView){
                weakSelf.animatedView.frame = targetFrame;
            }
        };
        
        if(self.isPresent){
          [self springAnimation:subViewFrameAnimation damping:0.5 velocity:3.0 completion:animationCompletion];
        }else{
            [self springAnimation:subViewFrameAnimation damping:0.6 velocity:3.5 completion:animationCompletion];
        }
        //        _animationType = AnimationTypeNormal;//这里 暂时设置显示的时候Spring动画  消失的时候回归正常动画 解决 spring消失动画闪现黑屏问题
    }else if(_animationType == AnimationTypeBlipBounce){//中间弹开
        if(!self.animatedView){
            animationCompletion(NO);
        }else{
            CGRect frame = targetFrame;
            frame.size.height = 0;
            frame.origin.y = CGRectGetHeight(toView.frame)*0.5;
            frame.origin.x = (CGRectGetWidth(toView.frame) - CGRectGetWidth(frame))*0.5;
            
            targetFrame.origin.x = frame.origin.x;
            targetFrame.origin.y = frame.origin.y - CGRectGetHeight(targetFrame)*0.5;
            self.animatedView.frame = frame;
            [self springAnimation:^{
                self.animatedView.frame = targetFrame;
            } damping:0.5 velocity:2.0 completion:animationCompletion];
//            [UIView animateWithDuration:_duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                self.animatedView.frame = targetFrame;
//            } completion:^(BOOL finished) {
//                 [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//            }];
        }
    }else{
        dispatch_block_t anmation = ^{
            if(weakSelf.animatedView){
                weakSelf.animatedView.frame = targetFrame;
            }
            toView.backgroundColor = viewBackColor;
        };
        [self normalAnmiation:anmation completion:animationCompletion];
    }
}

#pragma mark -- 动画类型 有context就需要结束通知上下文
-(void)normalAnmiation:(dispatch_block_t)anmtionBlock completion:(AnmationCompeletion)commpletion{
    [UIView animateWithDuration:self.duration animations:anmtionBlock completion:commpletion];
}

// MARK: -- 弹簧动画
-(void)springAnimation:(dispatch_block_t)anmtionBlock damping:(CGFloat)damping velocity:(CGFloat)velocity completion:(AnmationCompeletion)completion{
    [UIView animateWithDuration:self.duration delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionCurveEaseInOut animations:anmtionBlock completion:completion];
}
/* 过渡效果
 fade     //交叉淡化过渡(不支持过渡方向)
 push     //新视图把旧视图推出去
 moveIn   //新视图移到旧视图上面
 reveal   //将旧视图移开,显示下面的新视图
 cube     //立方体翻滚效果
 oglFlip  //上下左右翻转效果
 suckEffect   //收缩效果，如一块布被抽走(不支持过渡方向)
 rippleEffect //滴水效果(不支持过渡方向)
 pageCurl     //向上翻页效果
 pageUnCurl   //向下翻页效果
 cameraIrisHollowOpen  //相机镜头打开效果(不支持过渡方向)
 cameraIrisHollowClose //相机镜头关上效果(不支持过渡方向)
 */

/* 过渡方向
 fromRight;
 fromLeft;
 fromTop;
 fromBottom;
 */


/** *********push的时候自定义动画效果***********
 CATransition *animation = [CATransition animation];
 [animation setDuration:0.5];
 [animation setType: kCATransitionPush];
 [animation setSubtype:kCATransitionFromTop];//从上推入
 [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
 [self  pushViewController:aViewController animated:NO];
 [self .view.layer addAnimation:animation forKey:nil];
 
 ** ***********present的时候自定义动画效果********************
 CATransition *animation = [CATransition animation];
 animation.duration = 1.0;
 animation.timingFunction = UIViewAnimationCurveEaseInOut;
 animation.type = @"pageCurl";
 //animation.type = kCATransitionPush;
 animation.subtype = kCATransitionFromLeft;
 [self.view.window.layer addAnimation:animation forKey:nil];
 [self presentModalViewController:myNextViewController animated:NO completion:nil];
 */
/*
 Transition   	                   Subtypes	             Accepted parameters
 moveIn/push/reveal	fromLeft,fromRight,fromBottom,fromTop	      -
 pageCurl/pageUnCur fromLeft, fromRight, fromTop, fromBottom	float inputColor[];
 cube/alignedCube	fromLeft, fromRight, fromTop, fromBottom	float inputAmount; (perspective)
 flip/alignedFlip/oglFlip	fromLeft, fromRight, fromTop, fromBottom	float inputAmount;
 cameraIris	                         -	               CGPoint inputPosition;
 rippleEffect	                     -	                           -
 rotate	                 90cw, 90ccw, 180cw, 180ccw	               -
 suckEffect	                         -	              CGPoint inputPosition;
 */
//-(void)transition:(id <UIViewControllerContextTransitioning>)transitionContext{
//    
//    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    UIColor *viewBackColor ;
//    //    CGAffineTransform  transform;
//    
//    if(!self.animatedView) self.animatedView = [toView.subviews firstObject];
//    CGRect targetFrame = self.animatedView.frame;
//    
//    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    
//    if(toView){
//        self.animatedView.center =  toView.center;
//        
//       
//    }
//
//  [UIView transitionWithView:fromView duration:self.duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
//      toView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//      UIView *containerView = [transitionContext containerView];
//       [containerView addSubview:toView];
////      toView.backgroundColor = [UIColor redColor];
//      
//  } completion:^(BOOL finished) {
//      [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
//  }];
////
////    
////
////    
////    CATransition *animation = [CATransition animation];
////    
////    [animation setDuration:3.0];
////    
////    [animation setFillMode:kCAFillModeForwards];
////    
////    animation.timingFunction = UIViewAnimationCurveEaseInOut;
////    [animation setType:@"rippleEffect"];// rippleEffect
////    
////    [animation setSubtype:kCATransitionFromTop];
////    animation.startProgress = 0.0; //动画开始起点(在整体动画的百分比)
////    animation.endProgress = 1.0;  //动画停止终点(在整体动画的百分比)
////    animation.removedOnCompletion = NO;
////    [containerView.layer addAnimation:animation forKey:nil];
////    [containerView addSubview:toView];
////    toView.backgroundColor = [UIColor redColor];
////      [transitionContext completeTransition:YES];
////    [containerView addSubview:toView];
////    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
////    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
////    [toViewController transitionFromViewController:fromViewController toViewController:toViewController duration:self.duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:NULL completion:^(BOOL finished) {
////        [transitionContext completeTransition:YES];
////    }];
//    
////    [UIView transitionFromView:[transitionContext viewForKey:UITransitionContextFromViewKey] toView:[transitionContext viewForKey:UITransitionContextToViewKey] duration:self.duration options:UIViewAnimationOptionTransitionFlipFromLeft completion:^(BOOL finished) {
////        [transitionContext completeTransition:YES];
////    }];
////    [UIView transitionWithView:[transitionContext viewForKey:UITransitionContextToViewKey] duration:self.duration options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
////        
////    } completion:^(BOOL finished) {
////        [transitionContext completeTransition:YES];
////    }];
//}
// MARK: -- 父View的转场动画(tabBar控制器的切换页面动画)
-(void)handleTabBarPan:(UIPanGestureRecognizer *)panGR{
    CGFloat transLationX = fabs([panGR translationInView:_tabBarController.view].x);
    
//让 View 跟着手指移动 (无跳跃感)
    
//    [panGR setTranslation:CGPointZero inView:panGR.view.superview];
    CGFloat progress = transLationX/_tabBarController.view.frame.size.width;
    switch (panGR.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interactive = YES;
            CGFloat velocityX = [panGR velocityInView:_tabBarController.view].x;
            if(velocityX < 0){
                if(_tabBarController.selectedIndex < _tabBarController.viewControllers.count -1){
                    _tabBarController.selectedIndex += 1;
                }
            }else{
                if(_tabBarController.selectedIndex > 0 ){
                    _tabBarController.selectedIndex -= 1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            //问
            [self.interactionController updateInteractiveTransition:progress];
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            /*这里有个小问题，转场结束或是取消时有很大几率出现动画不正常的问题。在8.1以上版本的模拟器中都有发现，7.x 由于缺乏条件尚未测试，
             但在我的 iOS 9.2 的真机设备上没有发现，而且似乎只在 UITabBarController 的交互转场中发现了这个问题。在 NavigationController 暂且没发现这个问题，
             Modal 转场尚未测试，因为我在 Demo 里没给它添加交互控制功能。
             
             测试不完整，具体原因也未知，不过解决手段找到了。多谢 @llwenDeng 发现这个 Bug 并且找到了解决手段。
             解决手段是修改交互控制器的 completionSpeed 为1以下的数值，这个属性用来控制动画速度，我猜测是内部实现在边界判断上有问题。
             这里其修改为0.99，既解决了 Bug 同时尽可能贴近原来的动画设定。
             */
            self.interactionController.completionSpeed = 0.99;
            if(progress > 0.3){
                [self.interactionController finishInteractiveTransition];
            }else{
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                [self.interactionController cancelInteractiveTransition];
            }
            self.interactive = NO;
        default:
            break;
    }
}

// MARK: -- UINavigationController交互手势(只支持navigationController作为容器的手势交互)
-(void)handleNavPan:(UIPanGestureRecognizer *)panGR{
    /**
     *  interactivePopTransition就是我们说的方法2返回的对象，我们需要更新它的进度来控制Pop动画的流程，我们用手指在视图中的位置与视图宽度比例作为它的进度。
     */
    CGFloat progress = 0.0;
    if(self.showSuperViewType == ShowSuperViewTypePop || self.showSuperViewType == ShowSuperViewTypePush){//水平方向
       progress = [panGR translationInView:panGR.view].x / panGR.view.bounds.size.width;
    }else if(self.showSuperViewType == ShowSuperViewTypeDismissal || self.showSuperViewType == ShowSuperViewTypePresentation){//垂直方向交互
        progress = [panGR translationInView:panGR.view].y / panGR.view.bounds.size.height;
    }
    /**
     *  稳定进度区间，让它在0.0（未完成）～1.0（已完成）之间
     */
    progress = MIN(1.0, MAX(0.0, progress));
    if (panGR.state == UIGestureRecognizerStateBegan) {
         self.interactive = YES;
        /**
         *  告诉控制器开始执行pop的动画
         */
        [self.navgationController popViewControllerAnimated:YES];
    }
    else if (panGR.state == UIGestureRecognizerStateChanged) {
        
        /**
         *  更新手势的完成进度
         */
        [self.interactionController updateInteractiveTransition:progress];
    }
    else if (panGR.state == UIGestureRecognizerStateEnded || panGR.state == UIGestureRecognizerStateCancelled) {
        self.interactionController.completionSpeed = 0.99;
        /**
         *  手势结束时如果进度大于一半，那么就完成pop操作，否则重新来过。
         */
        if (progress > 0.3) {
            [self.interactionController finishInteractiveTransition];
        }
        else {
                [self.interactionController cancelInteractiveTransition];
        }
//        self.interactionController = nil;
         self.interactive = NO;
    }
}
// MARK: -- 控制器的View转场动画
-(void)animationSuperView:(id <UIViewControllerContextTransitioning>)transitionContext{
 
    UIView *contanierView = [transitionContext containerView];
   
    if(_showSuperViewType < ShowSuperViewTypeFrameChange){
        UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view;
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        CGFloat translation = contanierView.frame.size.width;
        CGAffineTransform toViewTransform = CGAffineTransformIdentity;
        CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
        switch (_showSuperViewType) {
            case ShowSuperViewTypeTabRight:
                translation = -translation;
            case ShowSuperViewTypeTabLeft:
                fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
                toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
                break;
            case ShowSuperViewTypePop:
                fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
                toViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
                if(_reverseDismiss){
                    _showSuperViewType = ShowSuperViewTypePush;
                }
                break;
            case ShowSuperViewTypePush:
                fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0);
                toViewTransform = CGAffineTransformMakeTranslation(translation, 0);
                if(_reverseDismiss){
                _showSuperViewType = ShowSuperViewTypePop;
                }
                break;
            case ShowSuperViewTypePresentation:
                translation =  contanierView.frame.size.height;
                fromViewTransform = CGAffineTransformMakeTranslation(0, -translation);
                toViewTransform = CGAffineTransformMakeTranslation(0, translation);
                if(_reverseDismiss){
                    _showSuperViewType = ShowSuperViewTypeDismissal;
                }
                break;
            case ShowSuperViewTypeDismissal:
                translation =  contanierView.frame.size.height;
                fromViewTransform = CGAffineTransformMakeTranslation(0, translation);
                toViewTransform = CGAffineTransformMakeTranslation(0, -translation);
                if(_reverseDismiss){
                    _showSuperViewType = ShowSuperViewTypePresentation;
                }
                break;

            default:
                break;
        }
        
        if(self.navgationController){
            //在navigationCntroller push、pop转场中呈现显示View都要添加到容器视图中
           [contanierView addSubview:toView];
            if(self.isPresent){
                //如果push转场的时候 将要呈现的控制器是xib创建的 他的尺寸就是xib的尺寸而不会根据屏幕大小进行调整
               toView.frame = contanierView.bounds; 
            }
        }else if(self.isPresent){
            
            //在  modal的dismissal 转场中，不要添加 toView，否则黑屏
            [contanierView addSubview:toView];
        }
        
        toView.transform = toViewTransform;
        dispatch_block_t animation = ^(){
            fromView.transform = fromViewTransform;
            toView.transform = CGAffineTransformIdentity;
        };
        AnmationCompeletion animationCompletion = ^(BOOL finshed){
            toView.transform = CGAffineTransformIdentity;
            fromView.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        };
//        if(self.animationType == AnimationTypeSpring){
//            [self springAnimation:animation damping:0.7 velocity:2.0 completion:animationCompletion];
//        }else{
            [self normalAnmiation:animation completion:animationCompletion];
//        }
    
        //也可以用这个实现动画
//        [UIView transitionFromView:<#(nonnull UIView *)#> toView:<#(nonnull UIView *)#> duration:<#(NSTimeInterval)#> options:<#(UIViewAnimationOptions)#> completion:<#^(BOOL finished)completion#>]
    }else{//TODO: --控制器中间父View转场frame变换
        UIView *view ;
        if(self.isPresent){
            view = [transitionContext viewForKey:UITransitionContextToViewKey];
        }else{
            view = [transitionContext viewForKey:UITransitionContextFromViewKey];
        }
        switch (self.showSuperViewType) {
            case ShowSuperViewTypeFrameChange:
                if(CGRectIsNull(self.targetFrame))self.targetFrame = view.frame;
                if(self.isPresent){
                    [CATransaction begin];
                    [CATransaction setDisableActions:YES];
                    view.frame = self.orignalFrame;
                    [CATransaction commit];
                    [contanierView addSubview:view];
                    [UIView animateWithDuration:_duration animations:^{
                        view.frame = self.targetFrame;
                    } completion:^(BOOL finished) {
                        //               _present = NO;
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                    }];
                }else{
                    [UIView animateWithDuration:_duration animations:^{
                        view.frame = self.orignalFrame;
                    } completion:^(BOOL finished) {
                        //                _present = YES;
                        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
                    }];
                }
                break;
             case ShowSuperViewTypeScaleCircle:
            {
                CGPoint startPoint;
                UIBezierPath *fromPath ;
                UIBezierPath *toPath ;
                
                if(CGRectIsNull(self.orignalFrame)){
                    startPoint = contanierView.center;
                    fromPath = [UIBezierPath bezierPathWithArcCenter:startPoint radius:10.0 startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
                    toPath = [UIBezierPath bezierPathWithArcCenter:startPoint radius:sqrt([UIScreen mainScreen].bounds.size.width *[UIScreen mainScreen].bounds.size.width + [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].bounds.size.height) * 0.5 startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
                }else{
                    startPoint = CGPointMake(CGRectGetMidX(self.orignalFrame), CGRectGetMidY(self.orignalFrame));
                   fromPath = [UIBezierPath bezierPathWithArcCenter:startPoint radius:sqrt(self.orignalFrame.size.width*self.orignalFrame.size.width + self.orignalFrame.size.height*self.orignalFrame.size.height)*0.5 startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
                    
                     toPath = [UIBezierPath bezierPathWithArcCenter:contanierView.center radius:sqrt([UIScreen mainScreen].bounds.size.width *[UIScreen mainScreen].bounds.size.width + [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].bounds.size.height) * 0.5 startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
                }
                CABasicAnimation *revealAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
                CAShapeLayer *shapeLayer = [CAShapeLayer layer];
                if (self.isPresent) {
                    [contanierView addSubview:view];
                    shapeLayer.path = toPath.CGPath;
                    revealAnimation.fromValue = (__bridge id )(fromPath.CGPath);
                    revealAnimation.toValue = (__bridge id)(toPath.CGPath);
                }else{
                    shapeLayer.path = fromPath.CGPath;
                    revealAnimation.fromValue = (__bridge id )(toPath.CGPath);
                    revealAnimation.toValue = (__bridge id )(fromPath.CGPath);
                }
                revealAnimation.duration = [self transitionDuration:transitionContext];
                revealAnimation.delegate = self;
                [shapeLayer addAnimation:revealAnimation forKey:@"scaleAnimation"];
                view.layer.mask =  shapeLayer;
                _transitionContext = transitionContext;
                
            }
                
                break;
            default:
                break;
        }
    }

}

// MARK: -- CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
     [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
}
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if(_showSuperViewType == ShowSuperViewTypeDefault){
         [self animationOneSubView:transitionContext];
    }else{
        [self animationSuperView:transitionContext];
    }
   
//    [self transition:transitionContext];
}
//MARK: -- 系统方法
//- (void)animationEnded:(BOOL) transitionCompleted{
//    
//}
-(void)dealloc{
    NSLog(@"转场调度器销毁了");
}
@end
