//
//  InputView.m
//  AttrbuteInput
//
//  Created by hejinyin on 2017/11/10.
//  Copyright © 2017年 hejinyin. All rights reserved.
//

#import "WQAttibuteInputView.h"
#import "WQAttributeTextView.h"
#import <Masonry/Masonry.h>
#import "FontStyleView.h"
#define BOTTOM_MARGIN 10.0
#define BOTTOM_INPUT_HEIGHT 0.0
@interface WQAttibuteInputView()< UIScrollViewDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate,FontStyleDeletage>
@property (strong  ,nonatomic) WQAttributeTextView *textView;
@property (strong  ,nonatomic) FontStyleView *fontStyleView;
@property (assign  ,nonatomic) CGRect showKeyboardFrame;
@property (strong  ,nonatomic) NSLayoutConstraint *bottomConstraint;
@end
@implementation WQAttibuteInputView
-(UIToolbar *)toolBar{
    if (!_toolBar) {
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44.0)];
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openAlbum)];
        UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"字体" style:UIBarButtonItemStylePlain target:self action:@selector(openOtherInputView)];
     
        _toolBar.items = @[item1,item2];
        
    }
    return _toolBar;
}

-(FontStyleView *)fontStyleView{
    if (!_fontStyleView) {
        _fontStyleView = [[FontStyleView alloc] init];
        _fontStyleView.delegate = self;
    }
    return _fontStyleView;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}
-(void)commonInit{
    _textView = [[WQAttributeTextView alloc] init];
    _textView.font = [UIFont systemFontOfSize:20.0];
    _textView.inputAccessoryView = self.toolBar;
    [self addSubview:_textView];
    UIEdgeInsets edges = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
    __weak typeof(self) weakSelf = self;
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.edges.equalTo(weakSelf).with.insets(edges);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}
 

//MARK: =========== FontStyleDeletage ===========

-(void)fontStyleDidClickFinshed:(FontStyleView *)fontStyle{
    [self hideFontStyleView];
 
}

-(void)updateConstraints{
    [super updateConstraints];
    
    if (!self.bottomConstraint)
    {
        NSArray *constraints = self.superview.constraints;
        
        [constraints enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSLayoutConstraint *  _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
            if ((constraint.firstItem == self || constraint.secondItem == self) && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom)
            {//获取自己和父控件底部约束
                 self.bottomConstraint = constraint;
                *stop = YES;
            }
        }];
    }
}
- (void)hideFontStyleView{
    [self.fontStyleView removeFromSuperview];
    [self setNeedsLayout];
}
//MARK: =========== item action ===========
-(void)openAlbum {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.allowsEditing = YES;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    
    ipc.delegate = self;
    [self.present presentViewController:ipc animated:YES completion:nil];
}
//打开字体风格
- (void)openOtherInputView{
    UIView *keyboardWindow = nil;
    CGFloat fontStyleShowH = BOTTOM_INPUT_HEIGHT;
    
    for (UIWindow *window in [UIApplication sharedApplication].windows) {
        if ([NSStringFromClass([window class]) rangeOfString:@"Keyboard"].location != NSNotFound) {
            keyboardWindow = window;
            break;
        }
    }
    fontStyleShowH += CGRectGetHeight(self.showKeyboardFrame);
    CGSize windowSize = keyboardWindow.frame.size;
    
    self.fontStyleView.frame = CGRectMake(0.0,windowSize.height, windowSize.width, fontStyleShowH);
    [keyboardWindow addSubview:self.fontStyleView];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.fontStyleView.frame = CGRectOffset(self.fontStyleView.frame, 0.0, -fontStyleShowH);
        [keyboardWindow setNeedsLayout];
    }];
}


//MARK: =========== 键盘通知 ===========


- (void)keyboardWillShowNotification:(NSNotification *)note{
    
    //不做transform 变化 可以解决 textView输入内容过多的时候 上下滚动
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.showKeyboardFrame = keyboardF;
//     __weak typeof(self) weakSelf = self;
    self.bottomConstraint.constant = -CGRectGetHeight(keyboardF);
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.present.view setNeedsLayout];
    } completion:NULL];
 
    
}
- (void)keyboardWillHideNotification:(NSNotification *)note{
    self.showKeyboardFrame = CGRectZero;
    self.bottomConstraint.constant = 0.0;
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.present.view setNeedsLayout];
    } completion:NULL];
 
}
//MARK: =========== UIImagePickerControllerDelegate ===========
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
    UIImage *image = info[UIImagePickerControllerEditedImage];
 __weak typeof(self) weakSelf = self;
    [self.delegate shouldUploadImage:image compeletion:^(NSString *src) {
        CGSize imageSize = [self fitShowImageSize:image];
       [weakSelf.textView insertImage:image withBounds:CGRectMake(0, 0, imageSize.width, imageSize.height) imgSrc:src];
    }];
    
}

- (NSArray *)getResults{
    NSMutableArray *array = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    [self.textView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.textView.attributedText.length) options:kNilOptions  usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        //NSAttachment
//        NSAttachmentAttributeName
        NSMutableDictionary *results = [NSMutableDictionary dictionary];
        [results setValue:@"" forKey:@"inputStr"];
        [results setValue:@"" forKey:@"imagePath"];
        WQAttributeTextAttachment *attach = [attrs objectForKey:NSAttachmentAttributeName];
        if (attach) {
            [NSString stringWithFormat:@"<img src = \"%@\"/>",attach.imgSrc];
             [array addObject:results];
        }else{
            NSAttributedString *attr = [weakSelf.textView.attributedText attributedSubstringFromRange:range];
            if (attr.string.length > 0) {
               [results setValue:attr.string forKey:@"inputStr"];
                [array addObject:results];
            }
            
        }
       
//        NSLog(@"%@",attrs);
    }];
    
    return [array copy];
}
- (CGSize)fitShowImageSize:(UIImage *)image{
    CGFloat appW =  CGRectGetWidth(self.textView.frame) - 10.0;
    CGSize size = image.size;
    CGSize showSize = size;
    CGFloat scale = appW/size.width;
    showSize.width = appW;
    showSize.height = size.height * scale;
    return showSize;
}

@end
