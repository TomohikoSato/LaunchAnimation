//
//  ViewController.m
//  myAnimatedMaskTransition
//
//  Created by tomohiko_sato on 2015/02/27.
//  Copyright (c) 2015年 tomohiko_sato. All rights reserved.
//

#import "ViewController.h"
#import "AnimationController.h"

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *toVC = segue.destinationViewController;
    toVC.transitioningDelegate = self;
}


- (IBAction)firstViewReturnActionForSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"First view return action invoked.");
}

# pragma mark - transitioning delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    return [AnimationController new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return nil;
}


@end
