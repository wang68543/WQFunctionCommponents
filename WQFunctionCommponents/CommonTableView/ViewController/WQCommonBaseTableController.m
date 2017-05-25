//
//  WQCommonBaseTableController.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseTableController.h"
#import "WQAPPHELP.h"

@interface WQCommonBaseTableController ()
@property (strong ,nonatomic) UITableView *tableView;

@end

@implementation WQCommonBaseTableController
//static NSString *const identifier = @"commonCell";
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //FIXME:做到数据源与数据分离
//     self.clearsSelectionOnViewWillAppear = NO;
    [self.view addSubview:self.tableView];
    self.tableDataHandle = [WQCommonDataResource configTableViewDelegateAndDataSource:self.tableView];
    
//    [self.tableView registerClass:[WQCommonBaseCell class] forCellReuseIdentifier:identifier];
}
//-(void)addGroups:(NSArray<WQCommonGroup *> *)groups{
//    _groups = groups;
//    [self.tableView reloadData];
//}
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//
//    return self.groups.count;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.groups[section].items.count;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WQCommonBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    cell.baseItem = self.groups[indexPath.section].items[indexPath.row];
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CGFloat cellHeight = self.groups[indexPath.section].items[indexPath.row].cellHeight;
//    if(cellHeight <= 0){
//        cellHeight = self.groups[indexPath.section].commonHeight.defaultCellHeight;
//    }
//    return cellHeight;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return self.groups[section].commonHeight.headerHeight;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return self.groups[section].commonHeight.footerHeight;
//}
////-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
////    return self.groups[section].header;
////}
////-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
////    return self.groups[section].footer;
////}
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc] init];
//    headerView.backgroundColor = [UIColor lightGrayColor];
//    WQCommonGroup *group = self.groups[section];
//    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), group.commonHeight.headerHeight);
//    UILabel *headerLabel = [[UILabel alloc] init];
//    headerLabel.font = [UIFont systemFontOfSize:15.0];
//    headerLabel.textColor = [UIColor blackColor];
//    headerLabel.frame = CGRectMake(15.0, 0.0, CGRectGetWidth(headerView.frame) - 15.0, CGRectGetHeight(headerView.frame));
//    headerLabel.text = group.header;
//    [headerView addSubview:headerLabel];
//    return headerView;
//}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc] init];
//    footerView.backgroundColor = [UIColor lightGrayColor];
//    WQCommonGroup *group = self.groups[section];
//    footerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.tableView.frame), group.commonHeight.headerHeight);
//    UILabel *footerLabel = [[UILabel alloc] init];
//    footerLabel.font = [UIFont systemFontOfSize:15.0];
//    footerLabel.textColor = [UIColor blackColor];
//    footerLabel.frame = CGRectMake(15.0, 0.0, CGRectGetWidth(footerView.frame) - 15.0, CGRectGetHeight(footerView.frame));
//    footerLabel.text = group.footer;
//    [footerView addSubview:footerLabel];
//    return footerView;
//}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    WQCommonBaseItem * baseItem = self.groups[indexPath.section].items[indexPath.row];
//    switch (baseItem.itemType) {
//        case CommonItemTypeArrow:
//        case CommonItemTypeSubtitle:
//        {
//            WQCommonArrowItem *item = (WQCommonArrowItem *)baseItem;
//            if(item.destClass){
//                UIViewController *destVc = [[item.destClass alloc] init];
//                [APPHELP setPropertyValue:destVc values:item.destPropertyParams];
//                [self.navigationController pushViewController:destVc animated:YES];
//            }
//            if(item.operation){
//                item.operation();
//            }
//        }
//            break;
//            case CommonItemTypeCenter:
//            case CommonItemTypeSwitch:
//            if(baseItem.operation){
//                baseItem.operation();
//            }
//            break;
//            
//        default:
//            break;
//    }
//}
@end
