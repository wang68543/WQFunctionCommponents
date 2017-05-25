//
//  WQCommonDataResource.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/4/1.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonDataResource.h"
#import "WQCommonBaseCell.h"
#import "WQAPPHELP.h"
#import "WQCommonCellProtocol.h"

@interface WQCommonDataResource ()
@property (weak ,nonatomic) UITableView *tableView;
@end
@implementation WQCommonDataResource
static NSString *const identifier = @"commonCell";
+(instancetype )configTableViewDelegateAndDataSource:(UITableView *)tableView{
    return [[self alloc] initWithTableView:tableView];
}
-(instancetype)initWithTableView:(UITableView *)tableView{
    if(self = [super init]){
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.tableView registerClass:[WQCommonBaseCell class] forCellReuseIdentifier:identifier];
    }
    return self;
}
-(void)addGroups:(NSArray<WQCommonGroup *> *)groups{
    _groups = groups;
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups[section].items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WQCommonBaseItem *baseItem = self.groups[indexPath.section].items[indexPath.row];
    if(baseItem.itemType == CommonItemTypeCustom){
        WQCommonCustomItem *customItem = (WQCommonCustomItem *)baseItem;
        
        UITableViewCell<WQCommonCellProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:[WQCommonCustomItem customIdentifire]];
        if(!cell){
            cell = [[customItem.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[WQCommonCustomItem customIdentifire]];
        }
        cell.baseItem = customItem;
        return cell;
    }else{
        WQCommonBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.baseItem = self.groups[indexPath.section].items[indexPath.row];
        return cell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat cellHeight = self.groups[indexPath.section].items[indexPath.row].cellHeight;
    if(cellHeight <= 0){
        cellHeight = self.groups[indexPath.section].commonHeight.defaultCellHeight;
    }
    return cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.groups[section].commonHeight.headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return self.groups[section].commonHeight.footerHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor lightGrayColor];
    WQCommonGroup *group = self.groups[section];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), group.commonHeight.headerHeight);
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.font = [UIFont systemFontOfSize:15.0];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.frame = CGRectMake(15.0, 0.0, CGRectGetWidth(headerView.frame) - 15.0, CGRectGetHeight(headerView.frame));
    headerLabel.text = group.header;
    [headerView addSubview:headerLabel];
    return headerView;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor lightGrayColor];
    WQCommonGroup *group = self.groups[section];
    footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), group.commonHeight.headerHeight);
    UILabel *footerLabel = [[UILabel alloc] init];
    footerLabel.font = [UIFont systemFontOfSize:15.0];
    footerLabel.textColor = [UIColor blackColor];
    footerLabel.frame = CGRectMake(15.0, 0.0, CGRectGetWidth(footerView.frame) - 15.0, CGRectGetHeight(footerView.frame));
    footerLabel.text = group.footer;
    [footerView addSubview:footerLabel];
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WQCommonBaseItem * baseItem = self.groups[indexPath.section].items[indexPath.row];
    switch (baseItem.itemType) {
        case CommonItemTypeArrow:
        case CommonItemTypeSubtitle:
        {
            WQCommonArrowItem *item = (WQCommonArrowItem *)baseItem;
            if(item.destClass){
                UIViewController *destVc = [[item.destClass alloc] init];
                [WQAPPHELP setPropertyValue:destVc values:item.destPropertyParams];
                [[WQAPPHELP currentNavgationController] pushViewController:destVc animated:YES];
            }
            if(item.operation){
                item.operation();
            }
        }
            break;
        default:
            if(baseItem.operation){
                baseItem.operation();
            }
            break;
    }
}
@end
