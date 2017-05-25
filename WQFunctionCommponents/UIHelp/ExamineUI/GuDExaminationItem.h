//
//  GuDExaminationItem.h
//  Guardian
//
//  Created by WangQiang on 16/8/8.
//  Copyright © 2016年 WangQiang. All rights reserved.
//  考核题目

#import <Foundation/Foundation.h>

@interface GuDExaminationItem : NSObject
@property (copy ,nonatomic) NSString *answer;
@property (copy ,nonatomic) NSString *content;
@property (copy ,nonatomic) NSString *idStr;
@property (copy ,nonatomic) NSString *title;
/**问题类型1 单选2 多选 3对错*/
@property (copy ,nonatomic) NSString *type;
/**选择的答案中间以逗号隔开*/
@property (copy ,nonatomic) NSString *currentSelectedItems;
@property (copy ,nonatomic) NSString *typeDescription;
//检测答案
-(BOOL)checkAnser;

+(NSArray *)examinationWithArray:(NSArray *)array;

+(instancetype)itemWithIdStr:(NSString *)idStr content:(NSString *)content answer:(NSString *)answer title:(NSString *)title type:(NSString *)type;
@end
