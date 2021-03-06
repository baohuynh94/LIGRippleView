//
//  LIGRippleView.m
//  Pods
//
//  Created by WEIHAN LI on 3/7/15.
//
//

#import "LIGRippleView.h"

@interface LIGRippleView()

@property(nonatomic, strong) CAShapeLayer *circleLayer;

@property(nonatomic, assign) BOOL animating;

@end

@implementation LIGRippleView


- (void)commonInit
{
    self.rippleColor = [UIColor whiteColor];
    self.finalOffset = CGRectGetWidth(self.bounds)*0.3;
    self.finalAlpha = 1.0;
    self.fadeoutDuration = 0.2;
    self.expandDuration = 0.3;

    [self _addCircleLayer];
    
}

#pragma mark - public methods

- (void)startAnimation{
    self.animating = YES;
    self.circleLayer.strokeColor = self.rippleColor.CGColor;
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    CABasicAnimation *animateLineWidth = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animateLineWidth.fromValue = @(0);
    animateLineWidth.toValue = @(width/2.0);
    
    CABasicAnimation *animatePath = [CABasicAnimation animationWithKeyPath:@"path"];
    
    
    animatePath.fromValue = (id)self.circleLayer.path;
    CGRect fromRect = CGRectMake(width/2.0, width/2.0, 0, 0);
    CGFloat fromRadius = 0;
    animatePath.fromValue = (id)[UIBezierPath bezierPathWithRoundedRect:fromRect cornerRadius:fromRadius].CGPath;
    
    CGRect toRect = CGRectMake(width/4.0, width/4.0, width/2.0, width/2.0);
    CGFloat toRadius = width/2.0;
    animatePath.toValue = (id)[UIBezierPath bezierPathWithRoundedRect:toRect cornerRadius:toRadius].CGPath;
    
    CABasicAnimation *animateOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateOpacity.fromValue = @(0.0);
    animateOpacity.toValue = @(1.0);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = self.expandDuration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[animateLineWidth, animatePath, animateOpacity];
    group.removedOnCompletion = NO;
    group.fillMode  = kCAFillModeForwards;
    group.delegate = self;
    [self.circleLayer addAnimation:group forKey:@"allMyAnimations"];
}

- (void)finishAnimation
{
    if (self.animating) {
        self.animating = NO;
        return;
    }
    
    CGFloat width = CGRectGetWidth(self.bounds);
    
    CABasicAnimation *animateLineWidth = [CABasicAnimation animationWithKeyPath:@"lineWidth"];
    animateLineWidth.fromValue = @(width/2.0);
    animateLineWidth.toValue = @(0);
    
    CABasicAnimation *animatePath = [CABasicAnimation animationWithKeyPath:@"path"];
    CGRect fromRect = CGRectMake(width/4.0, width/4.0, width/2.0, width/2.0);
    CGFloat fromRadius = width/2.0;
    animatePath.fromValue = (id)[UIBezierPath bezierPathWithRoundedRect:fromRect cornerRadius:fromRadius].CGPath;
    
    CGFloat offset = self.finalOffset;
    CGRect toRect = CGRectMake(-offset/2.0, -offset/2.0, width+offset, width+offset);
    CGFloat toRadius = width/2.0 + offset;
    animatePath.toValue = (id)[UIBezierPath bezierPathWithRoundedRect:toRect cornerRadius:toRadius].CGPath;
    
    CABasicAnimation *animateOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animateOpacity.fromValue = @(1.0);
    animateOpacity.toValue = @(self.finalAlpha);
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = self.fadeoutDuration;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.animations = @[animateLineWidth, animatePath, animateOpacity];
    group.removedOnCompletion = NO;
    //    group.fillMode  = kCAFillModeForwards;
    [self.circleLayer addAnimation:group forKey:@"allMyAnimations"];
    
}


#pragma mark - Private Instance methods

- (void)_addCircleLayer
{

    self.circleLayer = [CAShapeLayer layer];
   
    self.circleLayer.fillColor = nil;
    self.circleLayer.lineWidth = 0;

    [self.layer addSublayer:self.circleLayer];
}

#pragma mark - animation delegate methods

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished{

    if (!self.animating) {
        [self finishAnimation];
    }
    
    self.animating = NO;

}


- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder])) {
        [self commonInit];
    }
    return self;
}
@end
