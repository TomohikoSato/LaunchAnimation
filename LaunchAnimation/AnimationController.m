//
//  AnimationController.m
//  myAnimatedMaskTransition
//
//  Created by tomohiko_sato on 2015/02/27.
//  Copyright (c) 2015年 tomohiko_sato. All rights reserved.
//

#import "AnimationController.h"


@implementation AnimationController {
    id<UIViewControllerContextTransitioning> _context;
    UIView *_fromView;
    UIView *_toView;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 2.0f;
};


// This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    _context = transitionContext;
    UIView *containerView = transitionContext.containerView;
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    _fromView = fromViewController.view;
    
    
    
    UIView *toView = toViewController.view;
    _toView = toView;
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = toView.frame;
    UIImage *twitter= [UIImage imageNamed:@"twitter"];
    maskLayer.contents = (id)twitter.CGImage;
    maskLayer.contentsScale = 2.0;
    CGFloat iconSize = 96;
    maskLayer.frame = CGRectMake(toView.center.x - iconSize/2 , toView.center.y - iconSize / 2, iconSize, iconSize);
    toView.layer.mask = maskLayer;
    
    [containerView addSubview:toView];
    
    
    CGFloat animationDuration = 1.3;
    CAKeyframeAnimation *animation= [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.keyTimes = @[@0.0, @0.3, @1.0];
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DIdentity], [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(70, 70, 1.0)]];
    
    CAMediaTimingFunction *linear= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    CAMediaTimingFunction *easein= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[linear, linear, easein];
    animation.delegate = self;
    animation.duration = animationDuration;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = false;
    
    
    /*    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
     opacityAnimation.duration = animationDuration;
     opacityAnimation.fromValue = @0;
     opacityAnimation.toValue = @1;*/
    
    [toView.layer.mask addAnimation:animation forKey:@"scale"];
    //    [toView.layer.mask addAnimation:opacityAnimation forKey:@"opacity"];
    
}

- (void)animationDidStart:(CAAnimation *)animation{
    [[_fromView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *fromViewTwitterIcon= obj;
            fromViewTwitterIcon.hidden = YES;
        }
    }];
    
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    [[_fromView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *fromViewTwitterIcon= obj;
            fromViewTwitterIcon.hidden = NO;
        }
    }];
    
    _toView.layer.mask = nil;
    [_context completeTransition:YES];
}



@end
