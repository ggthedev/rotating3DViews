//
//  ViewController.m
//  CoreGraphicsTest
//
//  Created by Josh Grant on 1/25/14.
//  Copyright (c) 2014 Josh Grant. All rights reserved.
//

#import "ViewController.h"

#define TRANSPARENCY 1.0

@interface ViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, assign) CGFloat delta;
@property (nonatomic, assign) CGFloat offset;

@end

@implementation ViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createViewWithColor:[UIColor redColor]];
    [self createViewWithColor:[UIColor greenColor]];
    [self createViewWithColor:[UIColor blueColor]];
    [self createViewWithColor:[UIColor whiteColor]];
    
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

#pragma mark - Utility methods

- (void)createViewWithColor:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [view setBackgroundColor:color];
    [view setAlpha:TRANSPARENCY];
    [self.view addSubview:view];
}

#pragma mark - Gesture recognizers

- (void)panGestureRecognizerDidPan:(UIPanGestureRecognizer *)sender
{
    CGFloat percentage = [sender locationInView:self.view].x / self.view.bounds.size.width * 4;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        // Reset the delta so it doesn't jump
        self.delta = percentage;
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        // See if the views should rotate right or left (only matters at start)
        NSInteger sign = self.offset > 0 ? 1 : -1;
        
        // Determine where the views should snap to
        self.offset = (int)(self.offset + 0.5 * sign);
        
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self animateViews];
        } completion:nil];
    }
    else if (sender.state == UIGestureRecognizerStateChanged ||
               sender.state == UIGestureRecognizerStatePossible)
    {
        self.offset += percentage - self.delta;
        self.delta = percentage;
        
        [self animateViews];
    }
}

#pragma mark - Animations

- (void)animateViews
{
    // The four possible orientations (while not rotating) are 1, 2, 3, 4
    // 1 -> right, 2 -> back, 3-> left, 4 -> front
    [self animateView:self.view.subviews[0] withPercentage:self.offset + 1];
    [self animateView:self.view.subviews[1] withPercentage:self.offset + 2];
    [self animateView:self.view.subviews[2] withPercentage:self.offset + 3];
    [self animateView:self.view.subviews[3] withPercentage:self.offset + 4];
}

- (void)animateView:(UIView *)view withPercentage:(CGFloat)percentage
{
    CGFloat width = view.bounds.size.width / 2;
    
    // Sine function that modifies the x offset (x1: 0, x2: 160, x3: 0, x4: -160)
    CGFloat modX = sin(percentage / 2 * M_PI) * width;
    
    // Cosine function that modifies the z offset (z1: 0, z2: 160, z3: 320, z4: 160)
    CGFloat modZ = -cos(percentage / 2 * M_PI) * width + width;
    
    // Create a 3D transform and give it some perspective
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -(width * 3);
    
    // Rotate the view and translate it around its center
    transform = CATransform3DRotate(transform, M_PI_2 * percentage, 0, 1, 0);
    transform = CATransform3DTranslate(transform, modX, 0, modZ);
    
    view.layer.transform = transform;
}

#pragma mark - Interface orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    for (UIView *view in self.view.subviews)
    {
        [view setFrame:self.view.bounds];
    }
    [self panGestureRecognizerDidPan:self.panGestureRecognizer];
}

#pragma mark - Overridden properties

- (UIPanGestureRecognizer *)panGestureRecognizer
{
    if (_panGestureRecognizer == nil)
    {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDidPan:)];
        
        // Set the first state of the views
        [self panGestureRecognizerDidPan:_panGestureRecognizer];
    }
    return _panGestureRecognizer;
}

@end
