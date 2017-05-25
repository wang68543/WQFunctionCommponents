//
//  GuDExamineDataViewController.m
//  Guardian
//
//  Created by WangQiang on 16/8/8.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "GuDExamineDataViewController.h"
#import "GuDExaminationItem.h"
#import "ExamineCell.h"
//#import "UIImage+Extension.h"

@interface GuDExamineDataViewController ()
///<,UITableViewDataSource>
//@property (strong ,nonatomic) UITableView *tableView;
@property (strong ,nonatomic) NSArray *datas;
@property (strong ,nonatomic) NSArray *selectedItems;
@property (strong ,nonatomic) GuDExaminationItem *item;

@property (weak ,nonatomic) UIButton *nextBtn;
@end
@implementation GuDExamineDataViewController
static NSString *const ID = @"examineCell";
- (void)viewDidLoad{
    [super viewDidLoad];
    _item = self.items[self.pageNumber - 1];
    self.datas = [_item.content componentsSeparatedByString:@"|"];
    self.selectedItems = [_item.currentSelectedItems componentsSeparatedByString:@"|"];
    [self headerView];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ExamineCell class]) bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if([self.item.type integerValue] == 2){
        self.tableView.allowsMultipleSelection = YES;
    }else{
        self.tableView.allowsMultipleSelection = NO;
    }
     [self footerView];
    
}
-(void)headerView{
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.numberOfLines = 0;
    headerLabel.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50.0);
    headerLabel.font = [UIFont systemFontOfSize:15.0];
    headerLabel.text = [NSString stringWithFormat:@"  (%@)%@",self.item.typeDescription,self.item.title];
    self.tableView.tableHeaderView = headerLabel;
 }
-(void)footerView{
   
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60.0);
    CGFloat btnW = 100;
    CGFloat btnH = 45.0;
    CGFloat y = (footerView.frame.size.height - btnH)*0.5+ btnH*0.5;
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.bounds = CGRectMake(0, 0, btnW, btnH);
    nextBtn.center = CGPointMake([[UIScreen mainScreen] bounds].size.width*0.75, y);
     if(self.pageNumber < self.items.count){
         [nextBtn setTitle:@"下一题" forState:UIControlStateNormal];
         [nextBtn addTarget:self action:@selector(nextPage) forControlEvents:UIControlEventTouchUpInside];
     }else{
         [nextBtn setTitle:@"提交" forState:UIControlStateNormal];
         [nextBtn addTarget:self action:@selector(commit) forControlEvents:UIControlEventTouchUpInside];
     }
//    [nextBtn setBackgroundImage:[UIImage imageWithColor:LightGreen] forState:UIControlStateNormal];
    nextBtn.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
//    nextBtn.backgroundColor = LightGreen;
    [footerView addSubview:nextBtn];
    nextBtn.enabled = self.item.currentSelectedItems.length;
    self.nextBtn = nextBtn;
    
    if(self.pageNumber > 1){
        UIButton *forwardBtn = [[UIButton alloc] init];
        forwardBtn.bounds = CGRectMake(0, 0, btnW, btnH);
        forwardBtn.center = CGPointMake([[UIScreen mainScreen] bounds].size.width*0.25, y);
        [forwardBtn setTitle:@"上一题" forState:UIControlStateNormal];
        forwardBtn.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
        [forwardBtn addTarget:self action:@selector(forwardPage) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:forwardBtn];
    }
  
    self.tableView.tableFooterView = footerView;
 
}
#pragma mark -- tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.datas.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExamineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.contentLabel.text = self.datas[indexPath.row];
    [self.selectedItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([obj integerValue] == indexPath.row){
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            *stop = YES;
        }
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.nextBtn.enabled = YES;
    NSString *selectedItem = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
    if(self.item.currentSelectedItems.length <= 0 || [self.item.currentSelectedItems rangeOfString:selectedItem].location == NSNotFound){
        if(self.item.currentSelectedItems.length <= 0){
            self.item.currentSelectedItems = selectedItem;
        }else{
            self.item.currentSelectedItems = [NSString stringWithFormat:@"%@|%@",self.item.currentSelectedItems,selectedItem];
        }
        
    }
  
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.item.currentSelectedItems.length > 0){
        NSString *selectedItem ;
        NSString *firstItem = [self.item.currentSelectedItems substringToIndex:1];
        if([firstItem integerValue] == indexPath.row + 1){
           selectedItem = [NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
        }else{
           selectedItem = [NSString stringWithFormat:@"|%ld",(long)indexPath.row+1];
        }
        self.item.currentSelectedItems = [self.item.currentSelectedItems stringByReplacingOccurrencesOfString:selectedItem withString:@""];
    }
}
-(void)nextPage{
    if([self.delegate respondsToSelector:@selector(examineDataViewControllerDidClickNext:)]){
        [self.delegate examineDataViewControllerDidClickNext:self];
    }
}
-(void)forwardPage{
    if([self.delegate respondsToSelector:@selector(examineDataViewControllerDidClickForward:)]){
        [self.delegate examineDataViewControllerDidClickForward:self];
    }
}
-(void)commit{
    if([self.delegate respondsToSelector:@selector(examineDataViewControllerCommitCheck:)]){
        [self.delegate examineDataViewControllerCommitCheck:self];
    }
}
@end
