//
//  LXGDynamicsViewController.m
//  Notes
//
//  Created by 龙兴国 on 2019/9/12.
//  Copyright © 2019 龙兴国. All rights reserved.
//

#import "LXGDynamicsViewController.h"

@interface LXGDynamicsViewController ()<UICollisionBehaviorDelegate>
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIView *orangeBall;


@property (strong, nonatomic) UIImageView * blimage;
@end

@implementation LXGDynamicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.初始化、配置orangeBall
    self.orangeBall                    = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2-25, 100, 50, 50)];
    self.orangeBall.backgroundColor    = [UIColor orangeColor];
    self.orangeBall.layer.cornerRadius = 25;
    [self.view addSubview:self.orangeBall];
    // 2.初始化animator
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self testGravity];
    
    //
    self.blimage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 50, 100, 40, 40)];
    self.blimage.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.blimage];
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue         = [NSValue valueWithCGPoint:self.blimage.layer.position];
    moveAnimation.toValue           = [NSValue valueWithCGPoint:CGPointMake(self.blimage.layer.position.x, self.blimage.layer.position.y + 50)];
    
    
    moveAnimation.duration          = 2;
    moveAnimation.repeatCount       = HUGE_VALF;
    moveAnimation.autoreverses      = NO;
    moveAnimation.removedOnCompletion= NO;
    moveAnimation.fillMode          = kCAFillModeForwards;
    [self.blimage.layer addAnimation:moveAnimation forKey:@"moveAnimation1"];
}
- (void)testGravity {
    // 1.初始化重力行为
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self.orangeBall]];
    // 2.添加重力行为到UIDynamicAnimator
    [self.animator addBehavior:gravity];
    //
    UICollisionBehavior * collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.orangeBall]];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
    collisionBehavior.collisionDelegate = self;
}
@end
