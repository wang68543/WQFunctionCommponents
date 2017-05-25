//
//  APPHELP.m
//  Guardian
//
//  Created by WangQiang on 16/8/29.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQAPPHELP.h"
#import <objc/runtime.h>

#import "WQBroserController.h"
@interface WQAPPHELP()
@property (strong ,nonatomic) UIWebView *webView;

@end
@implementation WQAPPHELP
#pragma mark -- 打开浏览器
+(void)openBroserWithRoute:(UINavigationController *)nav url:(NSString *)url title:(NSString *)title{
    WQBroserController *broser = [[WQBroserController alloc] init];
    broser.URLString = url;
    broser.title = title;
    [nav pushViewController:broser animated:YES];
}
#pragma amrk -- 拨打电话
+(void)callNumber:(NSString *)phoneNumber{
    [[WQAPPHELP sharedAPP].webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]]]];
 
}
-(UIWebView *)webView{
    if(!_webView){
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    return _webView;
}


+(UINavigationController *)currentNavgationController{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self getNavgationControllerFrom:rootViewController];
}

+(UINavigationController *)getNavgationControllerFrom:(UIViewController *)fromViewController{
    if([fromViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navController = (UINavigationController *)fromViewController;
          return [self getNavgationControllerFrom:navController.visibleViewController];
    }else if ([fromViewController isKindOfClass:[UITabBarController class]]){
      return [self getNavgationControllerFrom:[(UITabBarController *)fromViewController selectedViewController]];
    }else{
        if(fromViewController.navigationController){
            return fromViewController.navigationController;
         }else{
            return nil;
        }
    }
}
+ (UIViewController*)visibleViewController{
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self getVisibleViewControllerFrom:rootViewController];
}
///////////////////
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}

// push控制器
+ (void)runtimePush:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav {
    //类名(对象名)
    
    NSString *class = vcName;
    
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        //创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        //注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象(写到这里已经可以进行随机页面跳转了)
    id instance = [[newClass alloc] init];
    [self setPropertyValue:instance values:dic];
     if(!nav)nav = [self currentNavgationController];
    [nav pushViewController:instance animated:YES];
    
}
/**用运行时给某个对象赋值*/
+(void)setPropertyValue:(id)instance values:(NSDictionary *)values{
    //下面是传值－－－－－－－－－－－－－－
    if(values && instance){
        [values enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
                //kvc给属性赋值
                [instance setValue:obj forKey:key];
            }else {
                NSLog(@"不包含key=%@的属性",key);
            }
        }];
    }
}
/**
 *  检测对象是否存在该属性
 */
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName
{
    unsigned int outCount, i;
    
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance
                                                           class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    // 再遍历父类中的属性
    Class superClass = class_getSuperclass([instance class]);
    
    //通过下面的方法获取属性列表
    unsigned int outCount2;
    objc_property_t *properties2 = class_copyPropertyList(superClass, &outCount2);
    
    for (int i = 0 ; i < outCount2; i++) {
        objc_property_t property2 = properties2[i];
        //  属性名转成字符串
        NSString *propertyName2 = [[NSString alloc] initWithCString:property_getName(property2) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName2 isEqualToString:verifyPropertyName]) {
            free(properties2);
            return YES;
        }
    }
    free(properties2); //释放数组
    
    return NO;
}

//MARK: -- 获取当前View所在的控制器
-(UIViewController*)viewController:(UIView *)view
{
    UIResponder *nextResponder =  view;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}


//MARK: -- 查找一个View中所有的输入框
+(NSArray<UIView<UITextInput> *> *)deepInputTextViews:(UIView *)view{
    if(view.subviews.count <= 0){
        return [NSArray array];
    }else{
        NSMutableArray *textFiledViews = [NSMutableArray array];
        for (UIView *subView in view.subviews) {
            if([subView  conformsToProtocol:@protocol(UITextInput)]){
                [textFiledViews addObject:subView];
            }else{
                [textFiledViews addObjectsFromArray:[self deepInputTextViews:subView]];
            }
        }
        return textFiledViews;
    }
    
}

+ (instancetype)sharedAPP
{//获取单例
    static WQAPPHELP *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

//singleton_m(APP);
@end
