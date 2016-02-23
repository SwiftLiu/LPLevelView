//
//  LPPageViewMenu.h
//  LPPageViewController
//
//  Created by FineexMac on 16/1/28.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPPageViewMenu : UIView

///宽度
@property (assign, nonatomic) CGFloat width;
///菜单主题
@property (strong, nonatomic) NSString *leftTitle;
@property (strong, nonatomic) NSString *rightTitle;
///菜单主色彩
@property (strong, nonatomic) UIColor *themeColor;

///动画关联scrollView（点击菜单按钮时会滚动到相应位置）
@property (weak, nonatomic) UIScrollView *scollView;

///动画(progress: 滚动条左边距/(菜单视图长度 * 2))
- (void)animateViewProgress:(CGFloat)progress;

@end
