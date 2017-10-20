//
//  WQAlertCenterOptionsView.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/5/5.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQAlertCenterOptionsView.h"
@interface WQAlertCenterOptionsView()<UITableViewDelegate,UITableViewDataSource>
@end
@implementation WQAlertCenterOptionsView
static NSString *const identifire = @"cell";
//MARK: =========== init ===========
+(instancetype)optionsView{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit{
    _hideLastSepratorLine = YES;
    
    _tableView = [[UITableView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 44.0;
    //用于缺省自定义
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifire];
    [self addSubview:_tableView];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}
-(void)registerCell:(NSString *)clsStr isNib:(BOOL)nib{
    if (nib) {
        [_tableView registerNib:[UINib nibWithNibName:clsStr bundle:nil] forCellReuseIdentifier:identifire];
    }else{
        [_tableView registerClass:NSClassFromString(clsStr) forCellReuseIdentifier:identifire];
    }
}

//MARK: =========== tableView data source ===========

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.optionsCount;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    if (self.cellForRow) {
      cell = self.cellForRow(cell, indexPath);
    }
    if (indexPath.row + 1 == [tableView numberOfRowsInSection:indexPath.section]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
//        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}


//MARK: =========== tableView delegate ===========
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectRow) {
        self.didSelectRow(indexPath);
    }
}
@end
