## LPLevelView
类似AppStore评分等级条

下载地址：https://github.com/SwiftLiu/LPLevelView.git

![评级示图](http://f.picphotos.baidu.com/album/s%3D900%3Bq%3D90/sign=6c73e249f403738dda4a00228320c16c/3801213fb80e7bec81959e082d2eb9389a506b88.jpg)

####1.支持打分手动评级，点击即可打分，同时回调打分完成block：

    @property (strong, nonatomic) void (^scoreBlock)(float level);
    
####2.采用绘图渲染界面，高效流畅，可自定义图标和尺寸等：

    ///整星图标，半星和空星尺寸以整星为准
    @property (strong, nonatomic) UIImage *iconFull;
    ///半星图标
    @property (strong, nonatomic) UIImage *iconHalf;
    ///空星图标
    @property (strong, nonatomic) UIImage *iconEmpty;
    ///图片尺寸，默认为iconFull图标的尺寸，同时自适应self尺寸
    @property (assign, nonatomic) CGSize iconSize;
    
*绘制图标到画布

    - (void)drawIcons
    {
        //计算绘制的图标尺寸
        CGSize size = [self sizeOfIcon];
        //纵坐标
        CGFloat y = (self.bounds.size.height - size.height) / 2.l;
        //图标间距
        CGFloat spacing = (self.bounds.size.width - size.width*_maxLevel)/(CGFloat)_maxLevel;
        //横坐标
        CGFloat x = spacing/2.l;
        
        for (int i=1; i<=_maxLevel; i++) {
            //①获取图标
            UIImage *iconImg;
            if (i <= _level) {//整星
                iconImg = _iconFull;
            }else if (i-_level < 1 && !_levelInt) {//半星
                if (_iconHalf) iconImg = _iconHalf;
                else return;
            }else if (_iconHalf) {//空星
                iconImg = _iconEmpty;
            }
        
            //③绘制
            [iconImg drawInRect:CGRectMake(x, y, size.width, size.height)];
        
            //④横坐标右移，以便绘制下一个图标
            x += size.width + spacing;
        }
    }
    
*计算绘制的图标尺寸

    - (CGSize)sizeOfIcon
    {
        //最大宽度
        CGFloat width = self.bounds.size.width/(CGFloat)_maxLevel;
        width = MIN(width, _iconFull.size.width);
        if (_iconSize.width != 0) width = MIN(width, _iconSize.width);
        //宽度伸缩比
        CGFloat wScale = width / _iconFull.size.width;
        //最大高度
        CGFloat height = self.bounds.size.height;
        height = MIN(height, _iconFull.size.height);
        if (_iconSize.height != 0) height = MIN(height, _iconSize.height);
        //高度伸缩比
        CGFloat hScale = height / _iconFull.size.height;
    
        //实际伸缩比
        CGFloat scale = MIN(wScale, hScale);
        //实际尺寸
        CGSize size = CGSizeMake(_iconFull.size.width * scale, _iconFull.size.height * scale);
        return size;
    }

####3.蒙版剪切自定义图标颜色：

    @property (strong, nonatomic) UIColor *iconColor;
*剪切

    - (void)drawRect:(CGRect)rect
    {
        //绘制默认图标
        if (_iconColor) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSaveGState(context);
            CGContextClipToMask(context, rect, [self clipPathImage]);//按蒙版图像路径剪切
            CGContextSetFillColorWithColor(context, _iconColor.CGColor);
            CGContextFillRect(context, rect);
            CGContextRestoreGState(context);
        }
        //绘制自定义图标
        else {
            [self drawIcons];//绘制
        }
    }
*绘制蒙版图像，即剪切路径

    - (CGImageRef)clipPathImage
    {
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
    }

    
