//
//  ViewController.m
//  KKHeartFlyAnimation
//
//  Created by 我是MT on 16/8/31.
//  Copyright © 2016年 馒头科技. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) UIButton *applauseBtn;
@property (strong, nonatomic) UILabel *applauseNumLbl;
@property (assign, nonatomic) NSInteger applauseNum;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    //鼓掌按钮
    self.applauseBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-60, self.view.frame.size.height-80-60, 60, 60)];
    self.applauseBtn.contentMode = UIViewContentModeScaleToFill;
    [self.applauseBtn setImage:[UIImage imageNamed:@"applause"] forState:UIControlStateNormal];
    [self.applauseBtn setImage:[UIImage imageNamed:@"applause"] forState:UIControlStateHighlighted];
    [self.applauseBtn addTarget:self action:@selector(applauseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.applauseBtn];
    //鼓掌数
    self.applauseNumLbl = [[UILabel alloc]init];
    self.applauseNumLbl.textColor = [UIColor whiteColor];
    self.applauseNumLbl.font = [UIFont systemFontOfSize:12];
    self.applauseNumLbl.text = @"0";
    [self.applauseBtn addSubview:self.applauseNumLbl];
    self.applauseNumLbl.textAlignment = NSTextAlignmentCenter;
    self.applauseNumLbl.frame = CGRectMake(6, 43, 50, 12);
}
- (void)applauseBtnClick {
    self.applauseNum++;
    self.applauseNumLbl.text = [NSString stringWithFormat:@"%zd",self.applauseNum];
    [self showTheApplauseInView:self.view belowView:self.applauseBtn];
}
//鼓掌动画
- (void)showTheApplauseInView:(UIView *)view belowView:(UIButton *)v{
    NSInteger index = arc4random_uniform(7); //取随机图片
    NSString *image = [NSString stringWithFormat:@"applause_%zd",index];
    UIImageView *applauseView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-50, self.view.frame.size.height - 150, 40, 40)];//增大y值可隐藏弹出动画
    [view insertSubview:applauseView belowSubview:v];
    applauseView.image = [UIImage imageNamed:image];
    
    CGFloat AnimH = 350; //动画路径高度,
    applauseView.transform = CGAffineTransformMakeScale(0, 0);
    applauseView.alpha = 0;
    
    //弹出动画
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        applauseView.transform = CGAffineTransformIdentity;
        applauseView.alpha = 0.9;
    } completion:NULL];
    
    //随机偏转角度
    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1- (2*i);// -1 OR 1,随机方向
    NSInteger rotationFraction = arc4random_uniform(10); //随机角度
    //图片在上升过程中旋转
    [UIView animateWithDuration:4 animations:^{
        applauseView.transform = CGAffineTransformMakeRotation(rotationDirection * M_PI/(4 + rotationFraction*0.2));
    } completion:NULL];
    
    //动画路径
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:applauseView.center];
    
    //随机终点
    CGFloat ViewX = applauseView.center.x;
    CGFloat ViewY = applauseView.center.y;
    CGPoint endPoint = CGPointMake(ViewX + rotationDirection*10, ViewY - AnimH);
    
    //随机control点
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);//随机放向 -1 OR 1
    
    NSInteger m1 = ViewX + travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n1 = ViewY - 60 + travelDirection*arc4random_uniform(20);
    NSInteger m2 = ViewX - travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n2 = ViewY - 90 + travelDirection*arc4random_uniform(20);
    CGPoint controlPoint1 = CGPointMake(m1, n1);//control根据自己动画想要的效果做灵活的调整
    CGPoint controlPoint2 = CGPointMake(m2, n2);
    //根据贝塞尔曲线添加动画
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    //关键帧动画,实现整体图片位移
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyFrameAnimation.duration = 3 ;//往上飘动画时长,可控制速度
    [applauseView.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        applauseView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [applauseView removeFromSuperview];
    }];
}
@end
