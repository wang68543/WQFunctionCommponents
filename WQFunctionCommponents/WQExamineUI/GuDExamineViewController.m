//
//  GuDExamineViewController.m
//  Guardian
//
//  Created by WangQiang on 16/8/8.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "GuDExamineViewController.h"
#import "GuDExamineDataViewController.h"
#import "GuDExaminationItem.h"
@interface GuDExamineViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,ExamineDataDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@end

@implementation GuDExamineViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    //设置翻页的效果
     NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    self.pageViewController.delegate = self;
    
    GuDExamineDataViewController *startingViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:NULL];
    [self updateTitleWithIndex:startingViewController.pageNumber];
    self.pageViewController.dataSource = self;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    
    CGRect pageViewRect = self.view.bounds;
   
    self.pageViewController.view.frame = pageViewRect;
    
    [self.pageViewController didMoveToParentViewController:self];
    //解决边缘点击翻页的问题
      self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    for (UIGestureRecognizer *gesture in self.pageViewController.gestureRecognizers) {
        if([gesture isKindOfClass:[UITapGestureRecognizer class]])
        gesture.delegate = self;
    }
  
}

-(void)initData{
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"1.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"2.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"3.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"4.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"5.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"6.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"7.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"8.生活方式评估的要点包括：" type:@"1"]];
    [items addObject:[GuDExaminationItem itemWithIdStr:@"8" content:@"膳食疾病、体力活动|体力活动、膳食、精神压力|疾病、体力活动、精神压力|社会适应能力|对健康的总体感受" answer:@"2" title:@"9.生活方式评估的要点包括：" type:@"1"]];
    self.items = items;
    
}
- (GuDExamineDataViewController *)viewControllerAtIndex:(NSUInteger)index
{
    GuDExamineDataViewController *dataViewController = [[GuDExamineDataViewController alloc] init];
    dataViewController.pageNumber = index;
    dataViewController.items = self.items;
    dataViewController.delegate = self;
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(GuDExamineDataViewController *)viewController{
    return viewController.pageNumber;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    NSUInteger index = [self indexOfViewController:(GuDExamineDataViewController *)viewController];
    if ((index <= 1) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
   
    NSUInteger index = [self indexOfViewController:(GuDExamineDataViewController *)viewController];
   
    if (index == NSNotFound) {//小于零的话就会被转为无穷大
        return nil;
    }

    GuDExaminationItem *item = self.items[index-1];
    if(item.currentSelectedItems.length <= 0){
        return nil;
    }
    
    ++index;
    if (index > self.items.count) {
        return nil;
    }
   
    
    return [self viewControllerAtIndex:index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    GuDExamineDataViewController *dataController = (GuDExamineDataViewController *)[pageViewController.viewControllers objectAtIndex:0];
   [self updateTitleWithIndex:dataController.pageNumber];
}

#pragma mark -- 更新标题
-(void)updateTitleWithIndex:(NSInteger)index{
    self.title = [NSString stringWithFormat:@"考核(%ld/%ld)",(long)index,(unsigned long)self.items.count];
}
#pragma mark -- ExamineDataDelegate
-(void)examineDataViewControllerDidClickForward:(GuDExamineDataViewController *)examine{
     GuDExamineDataViewController *startingViewController = [self viewControllerAtIndex:examine.pageNumber-1];
    NSArray *viewControllers = @[startingViewController];
    typeof(self) WeakSelf = self;
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
        [WeakSelf updateTitleWithIndex:startingViewController.pageNumber];
    }];
}
-(void)examineDataViewControllerDidClickNext:(GuDExamineDataViewController *)examine{
    GuDExamineDataViewController *startingViewController = [self viewControllerAtIndex:examine.pageNumber+1];
    NSArray *viewControllers = @[startingViewController];
    typeof(self) WeakSelf = self;
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
     [WeakSelf updateTitleWithIndex:startingViewController.pageNumber];
    }];
    
}
-(void)examineDataViewControllerCommitCheck:(GuDExamineDataViewController *)examine{
    __block NSUInteger correctCount = 0;
    [self.items enumerateObjectsUsingBlock:^(GuDExaminationItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj checkAnser]){
            correctCount++;
        }
        NSLog(@"正确答案%@===选择答案:%@",obj.answer,obj.currentSelectedItems);
    }];
}
//解决点击边缘翻页问题
-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //[gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]
//    if ([[touch view] isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
if([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]){
        return NO;
    }
    return YES;
    
}
@end
