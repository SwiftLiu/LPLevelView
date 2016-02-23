//
//  LPPageViewMenu.m
//  LPPageViewController
//
//  Created by FineexMac on 16/1/28.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import "LPPageViewMenu.h"

@interface LPPageViewMenu ()
{
    __weak IBOutlet NSLayoutConstraint *widthConstraint;
    __weak IBOutlet UIButton *leftButton;
    __weak IBOutlet NSLayoutConstraint *lineWidth;
    __weak IBOutlet UIButton *rightButton;
    __weak IBOutlet UIView *animateView;
    __weak IBOutlet NSLayoutConstraint *animateViewLeadMargin;
}
@end

@implementation LPPageViewMenu

- (void)awakeFromNib
{
    //分割线
    lineWidth.constant = 0.5;
    //选择左边按钮
    leftButton.selected = YES;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *nibName = NSStringFromClass([self class]);
        self = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil].firstObject;
    }
    return self;
}

#pragma mark - 动画
- (void)animateViewProgress:(CGFloat)progress
{
    animateViewLeadMargin.constant = progress * widthConstraint.constant / 2.l;
    if (progress > 0.5) {
        [self selectMenuRightButton];
    }else{
        [self selectMenuLeftButton];
    }
}

#pragma mark - 切换按钮
- (void)selectMenuLeftButton
{
    if (!leftButton.selected) {
        leftButton.selected = YES;
        rightButton.selected = NO;
    }
}

- (void)selectMenuRightButton
{
    if (!rightButton.selected) {
        rightButton.selected = YES;
        leftButton.selected = NO;
    }
}

#pragma mark - 设置宽度
- (void)setWidth:(CGFloat)width
{
    _width = width;
    widthConstraint.constant = width;
}

#pragma mark - 界面
- (void)setLeftTitle:(NSString *)leftTitle
{
    _leftTitle = leftTitle;
    if (leftButton) {
        [leftButton setTitle:leftTitle forState:UIControlStateNormal];
        [leftButton setTitle:leftTitle forState:UIControlStateHighlighted];
        [leftButton setTitle:leftTitle forState:UIControlStateSelected];
    }
}

- (void)setRightTitle:(NSString *)rightTitle
{
    _rightTitle = rightTitle;
    if (rightButton) {
        [rightButton setTitle:rightTitle forState:UIControlStateNormal];
        [rightButton setTitle:rightTitle forState:UIControlStateHighlighted];
        [rightButton setTitle:rightTitle forState:UIControlStateSelected];
    }
}

- (void)setThemeColor:(UIColor *)themeColor
{
    if (themeColor) {
        _themeColor = themeColor;
        [leftButton setTitleColor:themeColor forState:UIControlStateSelected];
        [leftButton setTitleColor:[themeColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        [rightButton setTitleColor:themeColor forState:UIControlStateSelected];
        [rightButton setTitleColor:[themeColor colorWithAlphaComponent:0.8] forState:UIControlStateHighlighted];
        animateView.backgroundColor = themeColor;
    }
}

#pragma mark - 事件
- (IBAction)leftButtonPressed:(UIButton *)sender {
    if (_scollView) [_scollView setContentOffset:CGPointZero animated:YES];
}

- (IBAction)rightButtonPressed:(UIButton *)sender {
    if (_scollView) [_scollView setContentOffset:CGPointMake(_scollView.contentSize.width/2.l, 0) animated:YES];
}
@end
