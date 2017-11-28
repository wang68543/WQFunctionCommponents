//
//  FontStyleView.h
//  AttrbuteInput
//
//  Created by hejinyin on 2017/10/27.
//  Copyright © 2017年 hejinyin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FontStyleView;
@protocol FontStyleDeletage <NSObject>
- (void)fontStyleDidClickFinshed:(FontStyleView *)fontStyle;
@optional
- (void)fontStyleDidSelected:(FontStyleView *)fontStyle indexpath:(NSIndexPath *)index;

@end
@interface FontStyleView : UIView
@property (assign  ,nonatomic) id <FontStyleDeletage> delegate;
@property (strong  ,nonatomic,readonly) UITableView *tableView;
@end
