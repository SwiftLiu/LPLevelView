//
//  BadgeView.m
//  FineExAPP
//
//  Created by FineexMac on 15/8/26.
//  Copyright (c) 2015年 FineEX-LF. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView ()
{
    CGFloat imgX;         //绘图时当前横着标
    UILabel *animateLabel;//评分时动画显示分数
}
@end


@implementation BadgeView

- (void)setScoreEnable:(BOOL)scoreEnable
{
    _scoreEnable = scoreEnable;
    self.userInteractionEnabled = scoreEnable;
    self.clipsToBounds = NO;
}

#pragma mark - 设置分数
- (void)setLevel:(float)level
{
    _level = level;
    [self setNeedsDisplay];
}

#pragma mark - 评分
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_scoreEnable) {
        UITouch *touch = [touches anyObject];
        CGFloat touchX = [touch locationInView:self].x;
        CGFloat wide = [self widthPerImg];
        if (touchX > wide * _maxLevel) return;
        
        if (_levelIntEnable) {
            self.level = (int)(touchX/wide) + 1;
        }else{
            self.level = ((int)(2 * touchX/wide) + 1) * 0.5;
        }
        if (_scoreAnimated) {
            [self levelAnimation];
        }
        if (_completeScoreBlock) _completeScoreBlock(_level);
    }
}
//评分动画
- (void)levelAnimation
{
    //初始化
    if (!animateLabel) {
        animateLabel = [UILabel new];
        animateLabel.bounds = CGRectMake(0, 0, 50, 20);
        animateLabel.textColor = [UIColor orangeColor];
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
    CGFloat x = (ceilf(_level) - .5) * [self widthPerImg];
    animateLabel.center = CGPointMake(x, -10);
    animateLabel.alpha = 1;
    [UIView animateWithDuration:0.7 animations:^{
        animateLabel.center = CGPointMake(x, -40);
        animateLabel.alpha = 0;
    }];
}
//每个badge占的宽度
- (CGFloat)widthPerImg
{
    if (_imgSizeScale==0) _imgSizeScale=1;
    if (_imgSize.width != 0 && _imgSize.height != 0) {
        return _imgSize.width + _imgSpacing;
    }else{
        return _image.size.width*_imgSizeScale + _imgSpacing;
    }
}


#pragma mark - 绘图
- (void)drawRect:(CGRect)rect
{
    if (_maxLevel == 0) _maxLevel = 5;
    if (_imgSizeScale==0) _imgSizeScale=1;
    
    imgX = _scoreEnable ? _imgSpacing*.5 : 0;
    for (int i=1; i<=_maxLevel; i++) {
        if (i <= _level) {
            if (!_image) return;
            [self drawImg:_image];
        }
        else if (i-_level < 1 && !_levelIntEnable && _imageHalf) {
            [self drawImg:_imageHalf];
        }
        else if (_imageEmpty) {
            [self drawImg:_imageEmpty];
        }
    }
}
- (void)drawImg:(UIImage *)img
{
    CGSize size;
    if (_imgSize.width != 0 && _imgSize.height != 0) {
        size = _imgSize;
    }else {
        if (_scoreEnable) {
            size = CGSizeMake(_image.size.width * _imgSizeScale, _image.size.height * _imgSizeScale);
        }else{
            size = CGSizeMake(img.size.width * _imgSizeScale, img.size.height * _imgSizeScale);
        }
    }
    
    CGFloat y = self.bounds.size.height*.5 - size.height*.5;
    [img drawInRect:CGRectMake(imgX, y, size.width, size.height)];
    imgX += size.width + _imgSpacing;
}

#pragma mark - 获取有效宽度
- (CGFloat)vaildWidth
{
    if (_scoreEnable) {
        return imgX;
    }else{
        return imgX - _imgSpacing*.5;
    }
}

#pragma mark - 
- (void)addSubview:(UIView *)view
{
    if (view == animateLabel) {
        [super addSubview:view];
    }
}
@end
