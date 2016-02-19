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
    
    //storyboard生成
    levelView.level = 2.5;
    levelView.iconColor = [UIColor redColor];
    levelView.canScore = YES;
    
    //纯代码初始化
    LPLevelView *lView = [LPLevelView new];
    lView.frame = CGRectMake(levelView.frame.origin.x, 150, levelView.frame.size.width, levelView.frame.size.height);
    lView.level = 3.5;
    lView.iconColor = [UIColor orangeColor];
    lView.canScore = YES;
    lView.animated = YES;
    [self.view addSubview:lView];
}

@end
