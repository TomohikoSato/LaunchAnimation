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

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    _context = transitionContext;
    UIView *containerView = transitionContext.containerView;
    _fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    _toView = toView;

    [containerView addSubview:toView];


    // create mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.contents = (id)[UIImage imageNamed:@"twitter"].CGImage;
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    CGFloat iconSize = 96;
    maskLayer.frame = CGRectMake(toView.center.x - iconSize/2 , toView.center.y - iconSize / 2, iconSize, iconSize);
    toView.layer.mask = maskLayer;


    // create animation
    CAKeyframeAnimation *animation= [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.keyTimes = @[@0.0, @0.3, @1.0];
    animation.values = @[
            [NSValue valueWithCATransform3D:CATransform3DIdentity],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
            [NSValue valueWithCATransform3D:CATransform3DMakeScale(70, 70, 1.0)]
    ];
    CAMediaTimingFunction *linear= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    CAMediaTimingFunction *easein= [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    animation.timingFunctions = @[linear, linear, easein];
    animation.delegate = self;
    animation.duration = 1.3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = false;


    // add animation to mask
    [toView.layer.mask addAnimation:animation forKey:@"scale"];
}

- (void)animationDidStart:(CAAnimation *)animation{
    [self p_setTwitterButtonAppearance:NO]; //遷移前ページのtwitterアイコンが邪魔なので隠す
}

- (void)animationDidStop:(CAAnimation *)animation finished:(BOOL)flag {
    [self p_setTwitterButtonAppearance:YES];
    _toView.layer.mask = nil;
    [_context completeTransition:YES];
}


- (void) p_setTwitterButtonAppearance: (BOOL) appearance {
    [[_fromView subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *fromViewTwitterIcon= obj;
            fromViewTwitterIcon.hidden = !appearance;
        }
    }];
}



@end
