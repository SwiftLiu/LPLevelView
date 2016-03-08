//
//  Created by iOS_Liu on 16/2/3.
//  Copyright © 2016年 iOS_Liu. All rights reserved.
//
//  作者GitHub主页 https://github.com/SwiftLiu
//  作者邮箱 1062014109@qq.com
//  下载链接 https://github.com/SwiftLiu/LPLevelView.git

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
    lView.frame = CGRectMake(145, 150, levelView.frame.size.width, levelView.frame.size.height);
    lView.iconColor = [UIColor orangeColor];
    lView.iconSize = CGSizeMake(20, 20);
    lView.canScore = YES;
    lView.animated = YES;
    lView.level = 0;
    [lView setScoreBlock:^(float level) {
        NSLog(@"打分：%f", level);
    }];
    [self.view addSubview:lView];
    
    //storyboard生成
//    levelView.backgroundColor = [UIColor clearColor];
//    levelView.iconColor = [UIColor redColor];
//    levelView.canScore = YES;
//    levelView.levelInt = YES;
//    levelView.iconSize = CGSizeMake(20, 20);
//    levelView.iconFull = [UIImage imageNamed:@"LPLevelView.bundle/lp_badge_star_full"];
//    levelView.iconHalf = [UIImage imageNamed:@"LPLevelView.bundle/lp_badge_star_half"];
//    levelView.iconEmpty = [UIImage imageNamed:@"LPLevelView.bundle/lp_badge_star_empty"];
//    levelView.level = 2.5;
}

@end
