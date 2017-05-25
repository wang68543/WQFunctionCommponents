//
//  GuDExaminationItem.m
//  Guardian
//
//  Created by WangQiang on 16/8/8.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "GuDExaminationItem.h"

@implementation GuDExaminationItem
+(NSArray *)examinationWithArray:(NSArray *)array{
    NSMutableArray *items = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        GuDExaminationItem *item = [self examinationWithDict:dic];
        if(item){
            [items addObject:item];
        }
    }
    return items;
}
+(instancetype)itemWithIdStr:(NSString *)idStr content:(NSString *)content answer:(NSString *)answer title:(NSString *)title type:(NSString *)type{
    GuDExaminationItem *item = [[GuDExaminationItem alloc] init];
    item.idStr = idStr;
    item.content = content;
    item.answer = answer;
    item.title = title;
    item.type = type;
    return item;
}
+(instancetype)examinationWithDict:(NSDictionary *)dict{
    if(![dict isKindOfClass:[NSDictionary class]]) return nil;
    return [[self alloc] initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"]){
        self.idStr = value;
    }
}
-(NSString *)typeDescription{
    if(!_typeDescription){
        switch ([_type integerValue]) {
            case 1:
                _typeDescription = @"单选题";
                break;
            case 2:
                _typeDescription = @"多选题";
                break;
            case 3:
                _typeDescription = @"对错题";
                break;
                
            default:
                 _typeDescription = @"未知";
                break;
        }
    }
    return _typeDescription;
}
-(BOOL)checkAnser{
    return self.currentSelectedItems == self.answer;
}
@end
