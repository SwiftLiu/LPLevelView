//
//  BadgeView.h
//  FineExAPP
//
//  Created by FineexMac on 15/8/26.
//  Copyright (c) 2015年 FineEX-LF. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ImgHollowStarFull [UIImage imageNamed:@"star_hollow_full"]
#define ImgHollowStarHalf [UIImage imageNamed:@"star_hollow_half"]
#define ImgHollowStarEmpty [UIImage imageNamed:@"star_hollow_empty"]

#define ImgSolidStarFull [UIImage imageNamed:@"star_solid_full"]
#define ImgSolidStarHalf [UIImage imageNamed:@"star_solid_half"]
#define ImgSolidStarEmpty [UIImage imageNamed:@"star_solid_empty"]

@interface BadgeView : UIView

//三种图片
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *imageHalf;
@property (strong, nonatomic) UIImage *imageEmpty;
//图片间距
@property (assign, nonatomic, getter=badgeSpacing) CGFloat imgSpacing;
//图片放大缩小倍数，默认1.0倍
@property (assign, nonatomic, getter=badgeSizeScale) CGFloat imgSizeScale;
//图片尺寸
@property (assign, nonatomic, getter=badgeSize) CGSize imgSize;
//图片绘制总宽度
@property (assign, nonatomic, readonly) CGFloat vaildWidth;

//星级
@property (assign, nonatomic) float level;
//星级是否为整数
@property (assign, nonatomic) BOOL levelIntEnable;
//最大等级，默认为5
@property (assign, nonatomic) int maxLevel;
//是否允许打分，即用户触摸设置星级
@property (assign, nonatomic) BOOL scoreEnable;
//打分是否有动画
@property (assign, nonatomic) BOOL scoreAnimated;
//完成评分后处理
@property (strong, nonatomic) void (^completeScoreBlock)(float level);

@end
