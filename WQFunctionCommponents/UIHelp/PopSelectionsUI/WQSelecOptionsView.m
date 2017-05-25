//
//  SelectTimeView.m
//  YunShouHu
//
//  Created by WangQiang on 16/4/20.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQSelecOptionsView.h"
#import "WQSelectOptionsCell.h"
//#import "WQConstans.h"

#define TimeCellHeight 30.0
#define BorderWidth 1.0
@interface WQSelecOptionsView()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>{
    NSMutableArray *_insideDatas;
    NSInteger _expectIndex;//排除显示
}
@property (strong ,nonatomic) UITableView *tableView;
@end
@implementation WQSelecOptionsView
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}
-(void)setTableViewBackGround:(UIColor *)backColor{
    self.tableView.backgroundColor = backColor;
}
-(void)setTableViewBorder:(UIColor *)tableViewBorder{
    _tableViewBorder = tableViewBorder;
    _tableView.layer.borderWidth = BorderWidth;
    _tableView.layer.borderColor = tableViewBorder.CGColor;
}
-(void)hide{
    __weak typeof(self) weakSelf = self;
    [self hideWithCompeletion:^{
        !weakSelf.didSelectedCompeletionIndexPath?:weakSelf.didSelectedCompeletionIndexPath(NO,[NSIndexPath indexPathForRow:0 inSection:0]);//这里后面的路径 是为了防止传空的时候使用出错
    }];
}
-(void)setDatas:(NSArray<NSString *> *)datas{
    _datas = datas;
    _expectIndex = -1;
    _insideDatas = [datas mutableCopy];
}
-(void)setExpectData:(NSString *)expectData{
    _expectData = expectData;
     _expectIndex = -1;
    if(expectData && _insideDatas){
        _expectIndex = [_insideDatas indexOfObject:expectData];
        if(  _expectIndex > _insideDatas.count -1){
            _expectIndex = -1;
        }else{
             [_insideDatas removeObjectAtIndex:_expectIndex];
        }
  
    }
   
}
-(void)hideWithCompeletion:(void(^)())compeletion{
    [UIView animateWithDuration:0.15 animations:^{
        self.tableView.bounds = CGRectMake(self.tableView.bounds.origin.x, self.tableView.bounds.origin.y, self.tableView.bounds.size.width, 0.0);
    } completion:^(BOOL finished) {
        if(compeletion)compeletion();
        _showing = NO;
        [self removeFromSuperview];
    }];
}

//要根据其高度来 默认向下(如果高度够的话)
-(void)showWithRect:(CGRect)rect{
    CGFloat contentSizeHeight = _insideDatas.count * self.cellHeight;
    //如果向下高度够的话就向下显示
    if([[UIScreen mainScreen] bounds].size.width - CGRectGetMaxY(rect) - self.bottomInset > contentSizeHeight){
      [self showWithRect:rect position:ShowPostionDown];
    }else if(rect.origin.y  - self.topInset > contentSizeHeight){ //如果向上高度够的话就向上显示
         [self showWithRect:rect position:ShowPostionUp];
    }else {//都不够的话就向下显示
        if(CGRectGetMaxY(rect) < [[UIScreen mainScreen] bounds].size.height*0.5){
            [self showWithRect:rect position:ShowPostionDown];
        }else{
           [self showWithRect:rect position:ShowPostionUp];
        }
        
    }
    
}
-(void)showWithRect:(CGRect)rect position:(ShowPostion)position{
    
    CGPoint positionPoint;
    CGPoint anchorPoint ;
    CGFloat tableViewHeight = 0.0;
     CGRect bounds = CGRectMake(0, 0, rect.size.width, tableViewHeight);
    self.tableView.bounds = bounds;
    
    self.frame = [UIApplication sharedApplication].delegate.window.bounds;
    [[UIApplication sharedApplication].delegate.window addSubview:self];
    switch (position) {
        case ShowPostionUp:
            positionPoint = CGPointMake(rect.origin.x, rect.origin.y);
            anchorPoint = CGPointMake(0, 1.0);
            tableViewHeight = MIN(_insideDatas.count *self.cellHeight, rect.origin.y - self.topInset);
            break;
        case ShowPostionDefault:
        case ShowPostionDown:
            positionPoint = CGPointMake(rect.origin.x, CGRectGetMaxY(rect));
            anchorPoint = CGPointMake(0, 0);
            tableViewHeight = MIN(_insideDatas.count *self.cellHeight, [[UIScreen mainScreen] bounds].size.height - CGRectGetMaxY(rect)-self.bottomInset);
            break;
        default:
            break;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.tableView.layer.anchorPoint = anchorPoint;
    if(self.tableViewBorder){
        positionPoint.x -= BorderWidth;
    }
    self.tableView.layer.position = positionPoint;
    [CATransaction commit];
   
    _showing = YES;
    if(self.tableViewBorder){
        bounds = CGRectMake(0, 0, rect.size.width+BorderWidth*2, tableViewHeight);
    }else{
        bounds = CGRectMake(0, 0, rect.size.width, tableViewHeight);
    }
   
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.tableView.bounds = bounds;
    }completion:^(BOOL finished) {
        if(weakSelf.selectedData && weakSelf.selectedData != weakSelf.expectData){
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[_insideDatas indexOfObject:weakSelf.selectedData] inSection:0];
            if(indexpath && indexpath.row < _insideDatas.count&&indexpath.row >= 0){
                [weakSelf.tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
            
        }
    }];
}
-(instancetype)init{
    if(self = [super init]){
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        tapGR.delegate = self;
        [self addGestureRecognizer:tapGR];
        [self commonInit];
    }
    return self;
}
-(void)commonInit{
    _textAlignment = NSTextAlignmentCenter;
    _topInset = 84.0;
    _bottomInset = 30.0;
    _labelFont = [UIFont systemFontOfSize:15.0];
    _cellHeight = TimeCellHeight;
    _textColor = [UIColor blackColor];
    [self addSubview:self.tableView];
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    if(CGRectContainsPoint(self.tableView.frame, point)){
        return NO;
    }else{
        return YES;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _insideDatas.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"dateCell";
    WQSelectOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell){
        cell = [[WQSelectOptionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = _textAlignment;
        cell.textLabel.textColor = _textColor;
        cell.textLabel.font = self.labelFont;
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _insideDatas[indexPath.row];
    return cell;
}
#pragma mark -- 根据控件来显示
-(void)showWithView:(UIView *)view{
     NSAssert(view, @"弹出框依赖视图不能为空");
    CGRect frame = [view.superview convertRect:view.frame toView:nil];
    [self showWithRect:frame];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

//-(void)setSelectedData:(NSString *)data{
//    [_insideDatas enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if([obj isEqualToString:data]){
//            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
//            *stop = YES;
//        }
//    }];
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //__weak  这里用week在iphone5真机上有问题(提前销毁了)
    /* 猜测__weak
     * 1.当变量前使用__weak修饰的时候 block会拷贝一个指向它的指针,这样在block定义之后修改这个变量的值在block里面起作用,如果不用__weak 就会直接拷贝一份他的值,可是这样在定义block之后修改的变量的值在block中不起作用
     * 2.而__weak的作用域就是当当前self存在的时候起作用 当self销毁的时候 __weak 修饰的变量也会被销毁(应该是self会把这些weak修饰的变量从weak表中移除并置空)
     */
    NSIndexPath *orignalSelectedIndexPath ;
    if(_expectIndex != -1 && indexPath.row >= _expectIndex){
        orignalSelectedIndexPath = [NSIndexPath indexPathForRow:indexPath.row +1 inSection:0];
    }else{
        orignalSelectedIndexPath = indexPath;
    }
    
    __weak typeof(self) weakSelf = self;
    dispatch_block_t block = ^(){
        if(weakSelf.didSelectedCompeletionIndexPath)weakSelf.didSelectedCompeletionIndexPath(YES,orignalSelectedIndexPath);
    };
    [self hideWithCompeletion:block];
    
    // 这里修改block的值
   // orignalSelectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
}
@end
