//
//  ViewController.m
//  Demo
//
//  Created by FineexMac on 16/2/17.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import "ViewController.h"
#import "LPLevelView.h"

@interface ViewController ()
{
    __weak IBOutlet LPLevelView *levelView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //纯代码初始化
    LPLevelView *lView = [LPLevelView new];
    lView.frame = CGRectMake(100, 150, levelView.frame.size.width, levelView.frame.size.height);
    lView.iconColor = [UIColor orangeColor];
    lView.canScore = YES;
    lView.animated = YES;
    lView.level = 3.5;
    [self.view addSubview:lView];
    
    //storyboard生成
    levelView.backgroundColor = [UIColor clearColor];
    levelView.iconColor = [UIColor redColor];
    levelView.canScore = YES;
    levelView.levelInt = YES;
    levelView.iconFull = [UIImage imageNamed:@"LPLevelView.bundle/lp_badge_star_full"];
    levelView.iconHalf = [UIImage imageNamed:@"LPLevelView.bundle/lp_badge_star_half"];
    levelView.iconEmpty = [UIImage imageNamed:@"LPLevelView.bundle/lp_badge_star_empty"];
    levelView.level = 2.5;
}

@end
