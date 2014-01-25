//
//  ViewController.m
//  CoreGraphicsTest
//
//  Created by Josh Grant on 1/25/14.
//  Copyright (c) 2014 Josh Grant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UIView *firstView;
@property (nonatomic, strong) UIView *secondView;
@property (nonatomic, strong) UIView *thirdView;

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.panGestureRecognizer];
    [self.view addSubview:self.firstView];
    [self.view addSubview:self.secondView];
    
    [self panGestureRecognizerDidPan:self.panGestureRecognizer];
}

#pragma mark - Gesture recognizer

- (void)panGestureRecognizerDidPan:(UIPanGestureRecognizer *)sender
{
    NSLog(@"%f", [sender locationInView:self.view].x);

    CGFloat percentage = [sender locationInView:self.view].x / 320;
    
    [self animateFirstViewWithPercentage:percentage];
    [self animateSecondViewWithPercentage:percentage];
}

#pragma mark - Animations

- (void)animateFirstViewWithPercentage:(CGFloat)percentage
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    
    transform = CATransform3DRotate(transform, M_PI_2 * percentage, 0, 1, 0);
    transform = CATransform3DTranslate(transform, 0 + 160 * percentage, 0, 0 + 160 * percentage);
    
    self.firstView.layer.transform = transform;
}

- (void)animateSecondViewWithPercentage:(CGFloat)percentage
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500;
    
    transform = CATransform3DRotate(transform, M_PI_2 * percentage - M_PI_2, 0, 1, 0);
    transform = CATransform3DTranslate(transform, -160 + 160 * percentage, 0, 160 - 160 * percentage);
    
    self.secondView.layer.transform = transform;
}

#pragma mark - Overridden properties

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (_panGestureRecognizer == nil) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDidPan:)];
    }
    return _panGestureRecognizer;
}

- (UIView *)firstView
{
    if (_firstView == nil) {
        _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        [_firstView setBackgroundColor:[UIColor redColor]];
    }
    return _firstView;
}

- (UIView *)secondView
{
    if (_secondView == nil) {
        _secondView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        [_secondView setBackgroundColor:[UIColor greenColor]];
    }
    return _secondView;
}

- (UIView *)thirdView
{
    if (_thirdView == nil) {
        _thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        [_thirdView setBackgroundColor:[UIColor blueColor]];
    }
    return _thirdView;
}

@end
