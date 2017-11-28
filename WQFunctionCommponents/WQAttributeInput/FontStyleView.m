//
//  FontStyleView.m
//  AttrbuteInput
//
//  Created by hejinyin on 2017/10/27.
//  Copyright © 2017年 hejinyin. All rights reserved.
//

#import "FontStyleView.h"
#import <Masonry/Masonry.h>
@interface FontStyleView()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation FontStyleView
static NSString *const identifire = @"cell";
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
- (void)commonInit{
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifire];
    _tableView.rowHeight = 50.0;
    
    UIView *headerView = [[UIView alloc] init]; 
    headerView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50.0);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(200, 0, 80, 50.0);
    [headerView addSubview:button];
     _tableView.tableHeaderView = headerView;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf);
    }];
    
    [self setNeedsLayout];
}

 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    NSString *text;
    
    switch (indexPath.row) {
        case 0:
            text = @"小标题";
            break;
        case 1:
            text = @"大标题";
            break;
        case 2:
            text = @"正文";
            break;
        default:
            break;
    }
    cell.textLabel.text = text;
    return cell;
}
//MARK: =========== button actions ===========
- (void)done:(UIButton *)sender{
    [self.delegate fontStyleDidClickFinshed:self];
}
@end
