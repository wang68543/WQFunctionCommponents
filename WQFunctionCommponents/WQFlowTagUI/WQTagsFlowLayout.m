//
//  WQTagsFlowLayout.m
//  SomeUIKit
//
//  Created by WangQiang on 2016/11/24.
//  Copyright © 2016年 WangQiang. All rights reserved.
//

#import "WQTagsFlowLayout.h"

@interface WQTagLayoutAttrbute : NSObject
@property (assign ,nonatomic) CGSize itemSize;
@property (assign ,nonatomic) CGPoint origin;
@property (strong ,nonatomic) NSIndexPath *indexPath;

@end
@implementation WQTagLayoutAttrbute

@end

@interface WQTagsFlowLayout()

@property (strong ,nonatomic) NSMutableArray *cacheLayoutAttributes;

@property (assign ,nonatomic) CGFloat maxY;
@end
@implementation WQTagsFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLayout];
    }
    return self;
}
-(void)cacheLayoutItems{
    _cacheLayoutAttributes = [NSMutableArray array];    
    _lines = 0;
    _maxY = 0;
    CGFloat lineMaxW = 0;
    CGFloat contentW = self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right;
    CGFloat sectionW = self.minimumInteritemSpacing;
    NSMutableArray *lineItems = [NSMutableArray array];
    NSInteger sections = [self.collectionView numberOfSections];
    for (int section = 0; section < sections ; section ++) {
        NSInteger rows = [self.collectionView numberOfItemsInSection:section];
        NSMutableArray *itemLayouts = [NSMutableArray array];
        _maxY += self.sectionInset.top + self.headerReferenceSize.height;
        for (int item = 0; item < rows ; item ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            WQTagLayoutAttrbute *attr = [[WQTagLayoutAttrbute alloc] init];
            attr.indexPath = indexPath;
            CGFloat width = [self.delegate tagsFlowLayout:self widthAtIndex:indexPath targetLine:_lines lineRemindWidth:contentW - lineMaxW];
            //预布局
            attr.itemSize = CGSizeMake(width, _rowHeight);
            //重新布局
            if(lineMaxW + width +sectionW > contentW){
               [self lineLayoutPreMaxW:lineMaxW sectionW:sectionW lineItems:lineItems isLastLine:NO];
                lineMaxW = 0.0;
                [lineItems removeAllObjects];
            }
           [lineItems addObject:attr];
           lineMaxW += width +sectionW;
         [itemLayouts addObject:attr];
        }
        [_cacheLayoutAttributes addObject:itemLayouts];
    }
    //最后一行(需要处理最后一行包含多个Section)
//    lineItems.count > [self.collectionView numberOfItemsInSection:[self.collectionView numberOfSections]
    [self lineLayoutPreMaxW:lineMaxW sectionW:sectionW lineItems:lineItems isLastLine:YES];
}



/**
 重新布局一行

 @param lineMaxW 之前预算的一行按照从左到右的默认间隔布局子控件的最大宽度
 @param sectionW 间隔
 @param items 一行的item
 @param lastLine 是否是最后一行
 */
-(void)lineLayoutPreMaxW:(CGFloat)lineMaxW sectionW:(CGFloat)sectionW lineItems:(NSArray *)items isLastLine:(BOOL)lastLine{
    NSInteger itemsCount = items.count;
    LineAlignment aliment = _lineContentAliment ;
    if([self.delegate respondsToSelector:@selector(tagsFlowLayout:lineContentAliment:lastLine:)]){
        aliment = [self.delegate tagsFlowLayout:self lineContentAliment:_lines lastLine:lastLine];
    }
    
    CGFloat lineHeight = _rowHeight;
    if([self.delegate respondsToSelector:@selector(tagsFlowLayout:lineHeightAtLine:lastLine:)]){
        lineHeight = [self.delegate tagsFlowLayout:self lineHeightAtLine:_lines lastLine:lastLine];
    }
   
    CGFloat lineX ;
    CGFloat tempSectionW;
    
    switch (aliment) {
        case LineAlignmentLeft:
            lineX = self.sectionInset.left;
            tempSectionW = sectionW;
            break;
        case LineAlignmentRight:
            tempSectionW = sectionW;
            lineX = self.collectionView.frame.size.width - lineMaxW -self.sectionInset.right;
            break;
        case LineAlignmentCenter:
            tempSectionW = sectionW;
            lineX = (self.collectionView.frame.size.width - lineMaxW)*0.5;
            break;
        case LineAlignmentFill:
            //如果少于两个 就用不上
            if(itemsCount < 2){
                tempSectionW = 0.0;
            }else{
               tempSectionW = (self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right -(lineMaxW - (itemsCount -1)*sectionW))/(itemsCount-1);
            }
            lineX = self.sectionInset.left;
            break;
            
        default:
            break;
    }

    
    for (WQTagLayoutAttrbute *theAttr in items) {
        theAttr.origin = CGPointMake(lineX, _maxY);
        theAttr.itemSize = CGSizeMake(theAttr.itemSize.width, lineHeight);
        lineX+= tempSectionW+ theAttr.itemSize.width;
    }
    _maxY += lineHeight;
    if(!lastLine){
       _lines++;
        _maxY += self.minimumLineSpacing;
    }
}
- (void)setupLayout
{
    self.minimumInteritemSpacing = 5;//同一行不同cell间距
    self.minimumLineSpacing = 5;//行间距
    self.headerReferenceSize = CGSizeMake(0, 50);//设置section header 固定高度，如果需要的话
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    _lineContentAliment = LineAlignmentLeft;
    _rowHeight = 45.0;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

-(void)prepareLayout{
    [super prepareLayout];
    if(!_cacheLayoutAttributes){
         [self cacheLayoutItems];
    }
   
}
-(void)reloadLayout{
    _cacheLayoutAttributes = nil;
}
#pragma mark - 指定cell的布局属性
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
     UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    WQTagLayoutAttrbute *tagLayout = _cacheLayoutAttributes[indexPath.section][indexPath.item];
    attrs.frame = CGRectMake(tagLayout.origin.x, tagLayout.origin.y, tagLayout.itemSize.width, tagLayout.itemSize.height);
    return attrs;
}
//sectionheader sectionfooter decorationview collectionviewcell的属性都会走这个方法


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 消除警报
    NSArray *array = [[NSArray alloc] initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES]; ;
    for(UICollectionViewLayoutAttributes *attrs in array){
        //类型判断
        if(attrs.representedElementCategory == UICollectionElementCategoryCell){
            //只有这里调用 重载的方法才起作用
            UICollectionViewLayoutAttributes *theAttrs = [self layoutAttributesForItemAtIndexPath:attrs.indexPath];
            attrs.frame = theAttrs.frame;
        }
    }
    return array;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.frame.size.width;
    return CGSizeMake(width, _maxY + self.sectionInset.bottom);
}
@end
