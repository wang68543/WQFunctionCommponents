//
//  WQCommonBaseCell.m
//  SomeUIKit
//
//  Created by WangQiang on 2017/3/13.
//  Copyright © 2017年 WangQiang. All rights reserved.
//

#import "WQCommonBaseCell.h"

@interface WQCommonBaseCell()
@property (strong ,nonatomic) UILabel *subtitleLabel;
@property (strong ,nonatomic) UISwitch *switchOptions;
@property (strong ,nonatomic) UILabel *bageView;
@property (strong ,nonatomic) UILabel *titleLbale;
@property (strong ,nonatomic) UIImageView *iconView;


//@property (strong ,nonatomic) UIImageView *arrowView;

@end
@implementation WQCommonBaseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self commonInit];
    }
    return self;
}
-(void)commonInit{
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconView];
    
    _titleLbale = [[UILabel alloc] init];
    _titleLbale.font = [UIFont systemFontOfSize:17.0];
    _titleLbale.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.titleLbale];
    
    _subtitleLabel = [[UILabel alloc] init];
    _subtitleLabel.font = [UIFont systemFontOfSize:15.0];
    _subtitleLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.subtitleLabel];
    
    _bageView = [[UILabel alloc] init];
    _bageView.backgroundColor = [UIColor redColor];
    _bageView.textColor = [UIColor whiteColor];
    _bageView.font = [UIFont systemFontOfSize:13.0];
    [self.contentView addSubview:self.bageView];
    
    _switchOptions = [[UISwitch alloc] init];
    [_switchOptions addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.switchOptions];
    
}
-(void)switchAction:(UISwitch *)sender{
    if([self.delegate respondsToSelector:@selector(commonBaseCellDidSwitchChange:switchState:)]){
        [self.delegate commonBaseCellDidSwitchChange:self switchState:sender.isOn];
    }
}
//-(void)resetCommonInit{
//    self.subtitleLabel.text = nil;
//    self.subtitleLabel.frame = CGRectZero;
//    if(self.imageView){
//        self.imageView.image = nil;
//        self.imageView.frame = CGRectZero;
//    }
//    self.textLabel.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor clearColor];
//}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)setBaseItem:(WQCommonBaseItem *)baseItem{
    _baseItem = baseItem;
    
    NSString *bageText = @"";
    NSString *subtitle = @"";
    UIColor *textLbaleBackcolor = [UIColor whiteColor];
    UIColor *textColor = [UIColor blackColor];
    NSTextAlignment textAliment = NSTextAlignmentLeft;
    BOOL isHiddenSwitchOptions = YES;
    
    CGRect imageViewFrame = CGRectZero;
    
    CGRect textLabelFrame = CGRectZero;
    CGRect subtitleFrame = CGRectZero;
//    CGRect switchFrame = CGRectZero;
    CGRect bageViewFrame = CGRectZero;
    UITableViewCellAccessoryType accessoryType  = UITableViewCellAccessoryNone;
    UIView *accessoryView = nil;
    
    
    CGFloat leftPadding = 15;
    CGFloat sectionH = 10.0;
    
    CGFloat maxX = leftPadding;
    CGFloat topPading = 5.0;
    CGFloat cellHeight = baseItem.cellHeight;
    CGFloat cellWidth = CGRectGetWidth(self.frame);
    
    CGFloat titleLabelRadius = 0.0;
    CGFloat arrowRight = 35;//箭头视图的总宽度是35
    if(cellHeight <= 0){
        cellHeight = CGRectGetHeight(self.frame);
    }
    if(baseItem.icon){
        CGFloat imageH = cellHeight - topPading*2;
        imageViewFrame = CGRectMake(maxX, topPading, imageH, imageH);
        maxX +=(imageH + sectionH);
        _iconView.image = [UIImage imageNamed:baseItem.icon];
    }
   CGFloat textWidth =  [baseItem.title boundingRectWithSize:CGSizeMake(cellWidth - maxX - arrowRight , cellHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_titleLbale.font} context:nil].size.width;
 
    
    switch (baseItem.itemType) {
        case CommonItemTypeArrow:
        {
            WQCommonArrowItem *arrowItem = (WQCommonArrowItem *)baseItem;
            accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
            CGFloat bageW = 0.0;
            CGFloat arroW = arrowRight;
            if(arrowItem.bageValue == NSNotFound){
                bageW = 3.0;
            }else if(arrowItem.bageValue > 10){
                bageW = 30.0;
                if(arrowItem.bageValue <= 99){
                    bageText = [NSString stringWithFormat:@"%ld",(long)arrowItem.bageValue];
                }else{
                   bageText = @"99+";
                }
            }else if(arrowItem.bageValue > 0){
                bageW = 20.0;
                bageText = [NSString stringWithFormat:@"%ld",(long)arrowItem.bageValue];
            }
            bageViewFrame = CGRectMake(cellWidth - arroW - bageW, (cellHeight - bageW)*0.5, bageW, bageW);
            self.bageView.layer.cornerRadius = bageW*0.5;
            self.bageView.layer.masksToBounds = YES;

        }
            break;
        case CommonItemTypeSubtitle:
        {
            WQCommonSubtitleItem *subtitleItem = (WQCommonSubtitleItem *)baseItem;
            CGFloat bageW = 0.0;
            CGFloat rightMinX = leftPadding;
            if(subtitleItem.needArrow){
              accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                rightMinX = cellWidth - arrowRight;
            }
            if(subtitleItem.bageValue == NSNotFound){
                bageW = 3.0;
            }else if(subtitleItem.bageValue > 10){
                bageW = 30.0;
                if(subtitleItem.bageValue <= 99){
                    bageText = [NSString stringWithFormat:@"%ld",(long)subtitleItem.bageValue];
                }else{
                    bageText = @"99+";
                }
            }else if(subtitleItem.bageValue > 0){
                bageW = 20.0;
                bageText = [NSString stringWithFormat:@"%ld",(long)subtitleItem.bageValue];
            }
            bageViewFrame = CGRectMake(rightMinX - bageW, (cellHeight - bageW)*0.5, bageW, bageW);
            self.bageView.layer.cornerRadius = bageW*0.5;
            self.bageView.layer.masksToBounds = YES;
            if(bageW > 0){
                rightMinX -= (bageW+sectionH);
            }
            
            switch (subtitleItem.subtitleAlignment) {
                case SubtitleAlignmentRightCenter:
                    textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
                    subtitleFrame = CGRectMake(CGRectGetMaxX(textLabelFrame)+sectionH, 0, rightMinX - (CGRectGetMaxX(textLabelFrame)+sectionH), cellHeight);
                    _subtitleLabel.textAlignment = NSTextAlignmentRight;
                    break;
                case SubtitleAlignmentLeftBottom:
                    textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight *0.6);
                    subtitleFrame = CGRectMake(maxX, CGRectGetMaxY(textLabelFrame), rightMinX - maxX - sectionH, cellHeight*0.4);
                    _subtitleLabel.textAlignment = NSTextAlignmentLeft;
                    break;
                default:
                    break;
            }
            subtitle = subtitleItem.subtitle;
            
        }
            break;
        case CommonItemTypeCenter:
        {
            WQCommonCenterItem *centerItem = (WQCommonCenterItem *)baseItem;
            textLabelFrame = CGRectMake(centerItem.contentEdge.left, centerItem.contentEdge.top, cellWidth - centerItem.contentEdge.left - centerItem.contentEdge.right, cellHeight- centerItem.contentEdge.top - centerItem.contentEdge.bottom);
            textAliment = NSTextAlignmentCenter;
            textLbaleBackcolor = centerItem.centerBackColor;
            textColor = centerItem.centerContentColor;
            titleLabelRadius = centerItem.cornerRadius;
        }
            break;
        case CommonItemTypeSwitch:
        {
            textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
            accessoryView = _switchOptions;
            isHiddenSwitchOptions = NO;
        }
            break;
            
        case CommonItemTypeBase:
            textLabelFrame = CGRectMake(maxX, 0, textWidth, cellHeight);
        default:
            break;
    }
   
    
    
    _iconView.frame = imageViewFrame;
 
    _titleLbale.text = baseItem.title;
    _titleLbale.textColor = textColor;
    _titleLbale.backgroundColor = textLbaleBackcolor;
    _titleLbale.textAlignment = textAliment;
    _titleLbale.frame = textLabelFrame;
    if(titleLabelRadius > 0.0){
        _titleLbale.layer.cornerRadius = titleLabelRadius;
        _titleLbale.layer.masksToBounds = YES;
    }else{
        _titleLbale.layer.cornerRadius = 0.0;
        _titleLbale.layer.masksToBounds = NO;
    }
    
    _subtitleLabel.frame = subtitleFrame;
    _subtitleLabel.text = subtitle;
    
    
    _bageView.text = bageText;
    _bageView.frame = bageViewFrame;
    
    self.accessoryType = accessoryType;
    self.accessoryView = accessoryView;
    
    _switchOptions.hidden = isHiddenSwitchOptions;
    
    [self layoutIfNeeded];

}
@end
