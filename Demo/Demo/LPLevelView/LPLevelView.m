//
//  BadgeView.m
//  FineExAPP
//
//  Created by FineexMac on 15/8/26.
//  Copyright (c) 2015年 FineEX-LF. All rights reserved.
//

#import "LPLevelView.h"

#define DefaultAnimateColor [UIColor orangeColor]

#define DefaultIconSize CGSizeMake(20, 20)

#define DefaultFullIcon [UIImage imageNamed:@"lp_badge_star_full"]
#define DefaultHalfIcon [UIImage imageNamed:@"lp_badge_star_half"]
#define DefaultEmptyIcon [UIImage imageNamed:@"lp_badge_star_empty"]

@interface LPLevelView ()
{
    UILabel *animateLabel;//评分时动画显示分数
}
@end

@implementation LPLevelView

#pragma mark - 重写
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initData];
}

- (void)initData
{
    _iconSizeScale = 1;
    self.maxLevel = 5;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.maxLevel = _maxLevel;
}

- (void)addSubview:(UIView *)view
{
    if (view == animateLabel) {
        [super addSubview:view];
    }
}

#pragma mark - 设置属性值
- (void)setCanScore:(BOOL)canScore
{
    _canScore = canScore;
    self.userInteractionEnabled = canScore;
    self.clipsToBounds = NO;
}

- (void)setLevel:(float)level
{
    _level = level;
    [self setNeedsDisplay];
}

- (void)setIconColor:(UIColor *)iconColor
{
    _iconColor = iconColor;
    [self setNeedsDisplay];
}

- (void)setMaxLevel:(int)maxLevel
{
    if (maxLevel==0) maxLevel = 5;
    _iconSpacing = (self.bounds.size.width - DefaultIconSize.width*maxLevel)/((CGFloat)maxLevel);
    if (maxLevel != _maxLevel) {
        _maxLevel = maxLevel;
        [self setNeedsDisplay];
    }
}

- (void)setIconSizeScale:(CGFloat)iconSizeScale
{
    if (iconSizeScale==0) iconSizeScale = 1;
    if (iconSizeScale != _iconSizeScale) {
        _iconSizeScale = iconSizeScale;
        [self setNeedsDisplay];
    }
}



#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //绘制默认图标
    if (_iconColor) {
        CGContextClipToMask(context, rect, [self clipPathImage]);//按蒙版图像路径剪切
        CGContextSetFillColorWithColor(context, [UIColor orangeColor].CGColor);
        CGContextFillRect(context, rect);
    }
    //绘制自定义图标
    else {
        [self drawIcons];//绘制
    }
    CGContextRestoreGState(context);
}

//绘制蒙版图像，即剪切路径
- (CGImageRef)clipPathImage
{
    //方法①：
    //在内存中创建image绘制画布
    CGFloat scale = [UIScreen mainScreen].scale;//必须设置画布分辨率，否则会模糊
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);
    CGContextRef imageContext = UIGraphicsGetCurrentContext();
    //翻转画布坐标系Y轴再平移坐标系原点到(0,0)位置，此处使用矩阵变换
    CGFloat transY = CGContextGetClipBoundingBox(imageContext).size.height;
    CGContextConcatCTM(imageContext, CGAffineTransformMake(1, 0, 0, -1, 0, transY));
    //绘制
    [self drawIcons];
    //提取UIImage
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //释放该画布
    CGContextRelease(imageContext);
    UIGraphicsEndImageContext();//关闭image绘制
    return image.CGImage;
    
    /*方法②：不是很好的方法，建议不使用
    //创建没有alpha通道的bitmap新画布
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();//灰度色彩空间
    CGBitmapInfo info = (CGBitmapInfo)kCGImageAlphaNone;
    CGContextRef imgContext = CGBitmapContextCreate(NULL, width, height, 8, width, colorSpace, info);
    //翻转画布坐标系Y轴再平移坐标系原点到(0,0)位置，此处使用矩阵变换
    CGFloat transY = CGBitmapContextGetHeight(imgContext);
    CGAffineTransform trans = CGAffineTransformMake(1, 0, 0, -1, 0, transY);
    CGContextConcatCTM(imgContext, trans);
    //绘制
    [self drawIconsInContext:imgContext];
    //提取CGImage
    CGImageRef imageRef = CGBitmapContextCreateImage(imgContext);
    CGContextRelease(imgContext);
    return imageRef;
    */
}

//绘制图标到指定画布
- (void)drawIcons
{
    CGFloat iconX = _iconSpacing/2.l;
    for (int i=1; i<=_maxLevel; i++) {
        //①获取图标
        UIImage *iconImg;
        if (_iconColor) {
            if (i <= _level) {//整星
                iconImg = DefaultFullIcon;
            }else if (i-_level < 1 && !_levelIntEnable) {//半星
                iconImg = DefaultHalfIcon;
            }else {//空星
                iconImg = DefaultEmptyIcon;
            }
        }
        else{
            if (i <= _level) {//整星
                if (_iconFull)  iconImg = _iconFull;
                else return;
            }else if (i-_level < 1 && !_levelIntEnable) {//半星
                if (_iconHalf) iconImg = _iconHalf;
                else return;
            }else if (_iconHalf) {//空星
                iconImg = _iconEmpty;
            }
        }
        
        //②计算绘制的位置尺寸
        CGSize size;
        if (_iconSize.width != 0 && _iconSize.height != 0) {
            size = _iconSize;
        }else if (_iconColor) {
            size = DefaultIconSize;
        }else {
            size = CGSizeMake(_iconFull.size.width * _iconSizeScale, _iconFull.size.height * _iconSizeScale);
        }
        CGFloat y = self.bounds.size.height/2.l - size.height/2.l;
        CGRect frame = CGRectMake(iconX, y, size.width, size.height);
        
        //③绘制
        [iconImg drawInRect:frame];
        
        //④横坐标右移，以便绘制下一个图标
        iconX += size.width + _iconSpacing;
    }
}


#pragma mark - 评分
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_canScore) {
        UITouch *touch = [touches anyObject];
        CGFloat touchX = [touch locationInView:self].x;
        CGFloat wide = [self widthPerIcon];
        if (touchX > wide * _maxLevel) return;
        
        if (_levelIntEnable) {
            self.level = (int)(touchX/wide) + 1;
        }else{
            self.level = ((int)(2 * touchX/wide) + 1) / 2.l;
        }
        
        if (_animated) [self scoreAnimation];
        if (_completeScoreBlock) _completeScoreBlock(_level);
    }
}
//评分动画
- (void)scoreAnimation
{
    //初始化
    if (!animateLabel) {
        animateLabel = [UILabel new];
        animateLabel.bounds = CGRectMake(0, 0, 50, 20);
        animateLabel.textColor = _animateColor?:(_iconColor?:DefaultAnimateColor);
        animateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:animateLabel];
    }
    //数值
    if (_level == (int)_level) {
        animateLabel.text = [NSString stringWithFormat:@"%.0f", _level];
    }else{
        animateLabel.text = [NSString stringWithFormat:@"%.1f", _level];
    }
    //动画
    CGFloat x = (ceilf(_level) - .5) * [self widthPerIcon];
    animateLabel.center = CGPointMake(x, -10);
    animateLabel.alpha = 1;
    [UIView animateWithDuration:0.7 animations:^{
        animateLabel.center = CGPointMake(x, -40);
        animateLabel.alpha = 0;
    }];
}
//每个badge占的宽度
- (CGFloat)widthPerIcon
{
    if (_iconSize.width != 0 && _iconSize.height != 0) {
        return _iconSize.width + _iconSpacing;
    }else if (_iconColor) {
        return DefaultIconSize.width + _iconSpacing;
    }else{
        return _iconFull.size.width*_iconSizeScale + _iconSpacing;
    }
}



@end
