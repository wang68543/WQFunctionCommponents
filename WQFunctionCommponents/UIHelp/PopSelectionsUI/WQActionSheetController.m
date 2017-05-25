//
//  WQActionSheetController.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/19.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQActionSheetController.h"
#import "WQActionSheetCell.h"
#import "WQPresentationController.h"

@interface WQActionSheetController ()

@end

@implementation WQActionSheetController
static NSString *const identifier = @"optionaCell";

#define BottomCancelSetionHeight 5.0
#define OptionsCellHeight 49.0
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[WQActionSheetCell class] forCellReuseIdentifier:identifier];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = OptionsCellHeight;
}
-(void)setHeaderView:(UIView *)headerView{
    _headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}
-(void)presentedInViewController:(UIViewController *)inViewController{
    
    //对应前面的WQPresentationController
    [self updatePreferredContentSizeWithTraitCollection:self.traitCollection];
    
     WQPresentationController *presentationC = [[WQPresentationController alloc] initWithPresentedViewController:self presentingViewController:inViewController];
    self.transitioningDelegate = presentationC ;  // 指定自定义modal动画的代理
     [inViewController presentViewController:self animated:YES completion:nil];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.bottomTitles.length > 0 && self.optionas.count > 0 ){
        return 2;
    }else if(self.bottomTitles.length > 0 || self.optionas.count > 0){
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(0 == section){
        if(self.optionas.count > 0){
            return self.optionas.count;
        }else if(self.bottomTitles.length > 0){
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([tableView numberOfSections] > 1 && section > 0){
        if(self.tableView.sectionHeaderHeight > 0){
            return self.tableView.sectionHeaderHeight;
        }else{
          return BottomCancelSetionHeight;
        }
    }
    return 0.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    NSString *content ;
    if(0 == indexPath.section && self.optionas.count > 0){
        if(self.optionalColor){
            cell.contentLabel.textColor = self.optionalColor;
        }else{
            cell.contentLabel.textColor = [UIColor lightGrayColor];
        }
        content = self.optionas[indexPath.row];
    }else{
        content = self.bottomTitles;
        if(self.cancelColor){
            cell.contentLabel.textColor = self.cancelColor;
        }else{
            cell.contentLabel.textColor = [UIColor lightGrayColor];
        }
    }
    cell.contentLabel.text = content;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger idx = 0;
    if([tableView numberOfSections] > 1){
        for (int i = 0; i < indexPath.section ; i ++) {
            idx += [tableView numberOfRowsInSection:i];
        }
        idx += indexPath.row;
    }else{
        idx += indexPath.row;
    }
    if([self.delegate respondsToSelector:@selector(actionSheetController:didSelectIndex:)]){
        [self.delegate actionSheetController:self didSelectIndex:idx];
    }
}
//对应前面的WQPresentationController
//当屏幕发生旋转的时候会调用这个方法
- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super willTransitionToTraitCollection:newCollection withTransitionCoordinator:coordinator];
    [self updatePreferredContentSizeWithTraitCollection:newCollection];
}

- (void)updatePreferredContentSizeWithTraitCollection:(UITraitCollection *)traitCollection{
    CGFloat contentH = self.tableView.rowHeight * self.optionas.count;
    if(self.bottomTitles.length > 0){
        if(self.tableView.sectionHeaderHeight > 0.0){
           contentH += self.tableView.sectionHeaderHeight + self.tableView.rowHeight;
        }else{
          contentH += BottomCancelSetionHeight + self.tableView.rowHeight;
        }
        
    }
    if(self.tableView.tableHeaderView){
        contentH += CGRectGetHeight(self.tableView.tableHeaderView.frame);
    }
    CGFloat contentW = self.tableView.frame.size.width;
    
    self.preferredContentSize = CGSizeMake(contentW, contentH);
}
@end
