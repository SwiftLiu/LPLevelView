//
//  LPPageViewController.h
//  LPPageViewController
//
//  Created by FineexMac on 16/1/27.
//  Copyright © 2016年 LPiOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface LPPageViewController : BasicViewController

///菜单主题
@property (strong, nonatomic) NSString *leftMenuTitle;
@property (strong, nonatomic) NSString *rightMenuTitle;
///菜单主色彩
@property (strong, nonatomic) UIColor *themeColor;

///子控制器(左)
@property (strong, nonatomic) UIViewController *leftViewController;
///子控制器(右)
@property (strong, nonatomic) UIViewController *rightViewController;

@end
