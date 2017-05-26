//
//  GuDExamineDataViewController.h
//  Guardian
//
//  Created by WangQiang on 16/8/8.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GuDExaminationItem;
@class GuDExamineDataViewController;
@protocol ExamineDataDelegate <NSObject>
-(void)examineDataViewControllerDidClickNext:(GuDExamineDataViewController *)examine;
-(void)examineDataViewControllerDidClickForward:(GuDExamineDataViewController *)examine;

-(void)examineDataViewControllerCommitCheck:(GuDExamineDataViewController *)examine;
@end
@interface GuDExamineDataViewController : UITableViewController
@property (assign ,nonatomic) NSInteger pageNumber;
@property (strong ,nonatomic) NSArray *items;
//@property (strong ,nonatomic) GuDExaminationItem *item;
@property (weak ,nonatomic) id<ExamineDataDelegate>delegate;
@end
