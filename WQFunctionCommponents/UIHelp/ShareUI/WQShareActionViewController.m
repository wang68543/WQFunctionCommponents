//
//  ShareActionViewController.m
//  AirMonitor
//
//  Created by WangQiang on 16/5/21.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQShareActionViewController.h"
#import "WQShareActionCell.h"
#import "WQControllerTransition.h"
//#import "WQConstans.h"
#import "WQAPPHELP.h"

#define ShareItemH 80.0
@interface WQShareActionViewController()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
@property (strong ,nonatomic) UICollectionView *collectionView;
//@property (assign ,nonatomic) CGFloat shareItemH;
@property (strong ,nonatomic) NSArray *datas;
@property (strong ,nonatomic) WQControllerTransition *botomTransition;

@end
@implementation WQShareActionViewController
static NSString *const CellID = @"shareCell";
-(NSArray *)datas{
    if(!_datas){
        NSMutableArray *temp = [NSMutableArray array];
       
      WQShareActionItem *item1 = [WQShareActionItem shareActionItemWithIcon:@"首页5" shareType:ShareActionTypeWechatTimeline];
        [temp addObject:item1];
        
        WQShareActionItem *item2 = [WQShareActionItem shareActionItemWithIcon:@"首页6" shareType:ShareActionTypeQzone];
        [temp addObject:item2];
        WQShareActionItem *item3 = [WQShareActionItem shareActionItemWithIcon:@"首页7" shareType:ShareActionTypeTencent];
        [temp addObject:item3];
        WQShareActionItem *item4 = [WQShareActionItem shareActionItemWithIcon:@"首页8" shareType:ShareActionTypeWechatSession];
        [temp addObject:item4];
        WQShareActionItem *item5 = [WQShareActionItem shareActionItemWithIcon:@"首页9" shareType:ShareActionTypeQQ];
        [temp addObject:item5];
        WQShareActionItem *item6 = [WQShareActionItem shareActionItemWithIcon:@"首页10" shareType:ShareActionTypeSina];
        [temp addObject:item6];
        _datas = temp;
        
    }
    return _datas;
}
-(UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 1.0;
        layout.minimumLineSpacing = layout.minimumInteritemSpacing;
        layout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - layout.minimumInteritemSpacing *2)/3.0, ShareItemH);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, ShareItemH *ceilf(self.datas.count/3.0) + layout.minimumLineSpacing)collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
    }
    return _collectionView;
}
-(WQControllerTransition *)botomTransition{
    if(!_botomTransition){
        _botomTransition = [WQControllerTransition transitionWithAnimatedView:self.collectionView];
    }
    return _botomTransition;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WQShareActionCell class]) bundle:nil] forCellWithReuseIdentifier:CellID];
    [self.view addSubview:self.collectionView];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack)];
    tapGR.delegate = self;
    [self.view addGestureRecognizer:tapGR];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.view isKindOfClass:[UICollectionView class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{

    CGPoint point = [touch locationInView:self.view];
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if (CGRectContainsPoint(self.collectionView.frame, point)) {
        return NO;
    }
    return  YES;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WQShareActionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.item = self.datas[indexPath.item];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   __weak  typeof(self) weakSelf = self;
     [self dismiss:^(BOOL finsh) {
         if([weakSelf.delegate respondsToSelector:@selector(shareActionDidSelected:)]){
             [weakSelf.delegate shareActionDidSelected:weakSelf.datas[indexPath.item]];
         }
    }];
    
}

-(void)showInController:(UIViewController *)inVC{
    if(!inVC) inVC = [WQAPPHELP visibleViewController];
    self.transitioningDelegate = self.botomTransition;
    self.modalPresentationStyle = UIModalPresentationCustom;
    [inVC presentViewController:self animated:YES completion:NULL];
}
-(void)tapBack{
    __weak typeof(self) weakSelf = self;
    [self dismiss:^(BOOL finsh) {
        if([weakSelf.delegate respondsToSelector:@selector(shareActionDidCancel)]){
            [weakSelf.delegate shareActionDidCancel];
        }
    }];
}
-(void)dismiss:(void (^)(BOOL finsh))compeletion{
    [self dismissViewControllerAnimated:YES completion:^{
         if(compeletion)compeletion(YES);
    }];
    
}
@end
