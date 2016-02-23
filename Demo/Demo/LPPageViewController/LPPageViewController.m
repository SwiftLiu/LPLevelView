//
//  LPPageViewController.m
//  LPPageViewController
//
//  Created by FineexMac on 16/1/27.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import "LPPageViewController.h"
#import "LPPageViewMenu.h"

@interface LPPageViewController ()<UIScrollViewDelegate>
{
    LPPageViewMenu *menuView;
    UIScrollView *pageScrollView;
    
    dispatch_once_t onceToken;
}
@end

@implementation LPPageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //滚动视图
    pageScrollView = [UIScrollView new];
    pageScrollView.delegate = self;
    pageScrollView.bounces = NO;
    pageScrollView.pagingEnabled = YES;
    pageScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:pageScrollView];
    
    //菜单
    menuView = [LPPageViewMenu new];
    [self.view addSubview:menuView];
    menuView.scollView = pageScrollView;//关联（点击菜单视图左右按钮执行动画）
    
    //重设置(若在滚动视图和菜单初始化之前设置了以下属性，需要重新设置)
    [self setThemeColor:_themeColor];
    [self setLeftMenuTitle:_leftMenuTitle];
    [self setRightMenuTitle:_rightMenuTitle];
    [self setLeftViewController:_leftViewController];
    [self setRightViewController:_rightViewController];
}

#pragma mark - 布局
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    dispatch_once(&onceToken, ^{
        CGFloat w = self.view.frame.size.width;
        menuView.width = w;
        CGFloat y = CGRectGetMaxY(menuView.frame);
        CGFloat h = self.view.frame.size.height - y;
        
        pageScrollView.frame = CGRectMake(0, y, w, h);
        pageScrollView.contentSize = CGSizeMake(w * 2, h);
        
        self.leftViewController.view.frame = CGRectMake(0, 0, w, h);
        self.rightViewController.view.frame = CGRectMake(w, 0, w, h);
    });
}


#pragma mark - 设置界面
- (void)setThemeColor:(UIColor *)themeColor
{
    if (themeColor) {
        _themeColor = themeColor;
        if (menuView) menuView.themeColor = themeColor;
    }
}

- (void)setLeftMenuTitle:(NSString *)leftMenuTitle
{
    if (leftMenuTitle) {
        _leftMenuTitle = leftMenuTitle;
        if (menuView) menuView.leftTitle = leftMenuTitle;
    }
}

- (void)setRightMenuTitle:(NSString *)rightMenuTitle
{
    if (rightMenuTitle) {
        _rightMenuTitle = rightMenuTitle;
        if (menuView) menuView.rightTitle = rightMenuTitle;
    }
}

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if (leftViewController) {
        _leftViewController = leftViewController;
        if (pageScrollView) {
            [self addChildViewController:leftViewController];
            [pageScrollView addSubview:leftViewController.view];
        }
    }
}

- (void)setRightViewController:(UIViewController *)rightViewController
{
    if (rightViewController) {
        _rightViewController = rightViewController;
        if (pageScrollView) {
            [self addChildViewController:rightViewController];
            [pageScrollView addSubview:rightViewController.view];
        }
    }
}



#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.x;
    CGFloat progress = offset / (scrollView.contentSize.width/2.l);
    [menuView animateViewProgress:progress];
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    menuView.userInteractionEnabled = NO;
}

//结束拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    menuView.userInteractionEnabled = YES;
}

@end
