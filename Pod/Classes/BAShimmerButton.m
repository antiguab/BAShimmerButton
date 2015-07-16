//The MIT License (MIT)
//
//Copyright (c) 2015 Bryan Antigua <antigua.b@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

#import "BAShimmerButton.h"
#import "UIColor+ColorWithHex.h"

@interface BAShimmerButton ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property (strong, nonatomic) CALayer *iconOffLayer;
@property (strong, nonatomic) CALayer *iconOnLayer;
@property (strong, nonatomic) CAShapeLayer *innerOnIconLayer;
@property (strong, nonatomic) CABasicAnimation *shimmerAnimation;

@property (strong, nonatomic) CAAnimationGroup *groupShowAnimation;
@property (strong, nonatomic) CAAnimationGroup *groupHideAnimation;

@property (assign, nonatomic) bool OnState;

@property(strong, nonatomic) UIDynamicAnimator *animator;


@end

@implementation BAShimmerButton

#pragma mark - Lifecycle

-  (id)initWithFrame:(CGRect)aRect
{
    self = [super initWithFrame:aRect];
    
    if (self)
    {
        [self initialize];
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initialize];
    }
    return self;
}

#pragma mark - Custom Accessors

- (void)setShimmerDuration:(CGFloat)shimmerDuration {
    _shimmerDuration = shimmerDuration;
    [self shimmerOff];
    self.shimmerAnimation.duration = shimmerDuration;
    [self shimmerOn];
}

- (void)setShimmerColor:(UIColor *)shimmerColor {
    _shimmerColor = shimmerColor;
    [self shimmerOff];
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)_shimmerColor.CGColor,(id)[UIColor clearColor].CGColor];
    [self shimmerOn];
}

- (void)setShimmerDirection:(BAShimmerDirection)shimmerDirection {
   _shimmerDirection = shimmerDirection;
    [self setGradientDirection];
    [self createShimmerAnimation];
}

- (void)setGradientSize:(CGFloat)gradientSize {
    _gradientSize = gradientSize;
    [self setGradientDirection];
    [self createShimmerAnimation];
    
}

- (void)setIconOffImageColor:(UIColor *)iconOffImageColor {
    _iconOffImageColor = iconOffImageColor;
}

- (void)setIconImage:(UIImage *)iconImage {
    _iconImage = iconImage;
    [self createIconImages];
    [self.layer addSublayer:self.iconOffLayer];
    [self.layer addSublayer:self.iconOnLayer];
    if (!self.OnState) {
//        self.innerOnIconLayer.transform = CATransform3DMakeScale(0.0, 0.0, 1.0);
        self.innerOnIconLayer.opacity = 0.0;
        CABasicAnimation *shrinkAnimation;
        shrinkAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.duration=0.0f;
        shrinkAnimation.fillMode = kCAFillModeForwards;
        shrinkAnimation.removedOnCompletion = NO;
        shrinkAnimation.toValue= @0.0;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.innerOnIconLayer.opacity = 1.0;
        }];
        [self.innerOnIconLayer addAnimation:shrinkAnimation forKey:@"shrinkingInner"];
        [CATransaction commit];
    }
}

#pragma mark - Private

- (void)createIconImages {
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = CGRectMake(0,0, self.iconImage.size.width, self.iconImage.size.height);
    maskLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2,CGRectGetHeight(self.bounds)/2);
    maskLayer.contents = (id)self.iconImage.CGImage;
    
    //creating off icon
    self.iconOffLayer = [CAShapeLayer layer];
    self.iconOffLayer.frame = CGRectMake(0,0, self.iconImage.size.width, self.iconImage.size.height);
    self.iconOffLayer.backgroundColor = [UIColor blackColor].CGColor;

    if (self.iconOffImageColor) {
        self.iconOffLayer.backgroundColor = self.iconOffImageColor.CGColor;
    }
    self.iconOffLayer.mask = maskLayer;
    
    
    //creating on icon
    self.iconOnLayer = [CAShapeLayer layer];
    self.iconOnLayer.frame =  CGRectMake(0,0, self.iconImage.size.width, self.iconImage.size.height);
    self.iconOnLayer.position = CGPointMake(CGRectGetWidth(self.bounds)/2,CGRectGetHeight(self.bounds)/2);
    self.iconOnLayer.contents = (id)self.iconImage.CGImage;

    self.innerOnIconLayer = [CAShapeLayer layer];
    UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height) cornerRadius:MAX(self.frame.size.width/2,self.frame.size.height/2)];
    self.innerOnIconLayer.path = circularPath.CGPath;
    self.innerOnIconLayer.frame = self.frame;
    self.innerOnIconLayer.position = CGPointMake(self.bounds.size.width/2,self.bounds.size.height/2);
    
    
    self.innerOnIconLayer.frame = self.frame;
    self.innerOnIconLayer.position = CGPointMake(self.iconOnLayer.frame.size.width/2,self.iconOnLayer.frame.size.height/2);
    self.iconOnLayer.mask = self.innerOnIconLayer;
}

- (void)setGradientDirection {
    switch (self.shimmerDirection) {
        case BAShimmerDirectionTopToBottom:
        {
            self.gradientLayer.startPoint = CGPointMake(0 ,-(self.gradientSize * 2));
            self.gradientLayer.endPoint = CGPointMake(0, 2);
            break;
        }
        case BAShimmerDirectionBottomToTop:
        {
            self.gradientLayer.startPoint = CGPointMake(0 ,2);
            self.gradientLayer.endPoint = CGPointMake(0, -(self.gradientSize * 2));
            break;
        }
        case BAShimmerDirectionLeftToRight:
        {
            self.gradientLayer.startPoint = CGPointMake(-(self.gradientSize * 2), 0);
            self.gradientLayer.endPoint = CGPointMake(2, 0);
            break;
        }
        case BAShimmerDirectionDiagonalLeftToRight:
        {
            self.gradientLayer.startPoint = CGPointMake(-(self.gradientSize * 2), 0);
            self.gradientLayer.endPoint = CGPointMake(1 + self.gradientSize, 1.5);
            break;
        }
        case BAShimmerDirectionRightToLeft:
        {
            self.gradientLayer.startPoint = CGPointMake(2, 0);
            self.gradientLayer.endPoint =CGPointMake(-(self.gradientSize * 2), 0);
            break;
        }
        case BAShimmerDirectionDiagonalRightToLeft:
        {
            self.gradientLayer.startPoint = CGPointMake(1 + self.gradientSize, 1.5);
            self.gradientLayer.endPoint = CGPointMake(-(self.gradientSize * 2), 0);
            break;
        }
            
        default:
        {
            break;
        }
    }
}

- (void)createShimmerAnimation {
    
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)self.shimmerColor.CGColor, (id)[UIColor clearColor].CGColor];
    
    //2.b spaces out the gradient based on width
    NSArray *startLocations = @[@0.0f, @(self.gradientSize / 2), @(self.gradientSize)];
    NSArray *endLocations = @[@(1.0f - self.gradientSize), @(1.0f - (self.gradientSize / 2)), @1.0f];
    
    [self setGradientDirection];
    
    //2.c add rest of location properties to gradient layer
    self.gradientLayer.locations = startLocations;
    
    //2.d animate the shimmering to occur until the button is pressed
    self.shimmerAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    self.shimmerAnimation.fromValue = startLocations;
    self.shimmerAnimation.toValue = endLocations;
    self.shimmerAnimation.duration  = self.shimmerDuration;
    self.shimmerAnimation.repeatCount = HUGE_VALF;
    [self.gradientLayer addAnimation:self.shimmerAnimation forKey:@"animateGradient"];
}

- (void)initialize {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;

    //default values
    _shimmerDuration = 1.0f;
    _shimmerDirection = BAShimmerDirectionDiagonalLeftToRight;
    _shimmerColor = [UIColor colorWithHex:0x5A6363];
    _gradientSize = 30.0f / CGRectGetWidth(self.frame);
    [self setGradientDirection];
    
    [self createShimmerAnimation];
    [self.layer addSublayer:self.gradientLayer];
    
    //3.a Configure outline of Off button image
    self.OnState = NO;
    
    //hide initially
    self.alpha = 0.0f;
    
    //showButton Animations
    CABasicAnimation *growAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    growAnimation.duration=0.2f;
    growAnimation.beginTime = 0.0f;
    growAnimation.fromValue= @0.2;
    growAnimation.fillMode = kCAFillModeForwards;
    growAnimation.toValue=@1.0;
    
    CABasicAnimation *popGrowAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    popGrowAnimation.duration=0.2f;
    popGrowAnimation.beginTime = growAnimation.duration;
    popGrowAnimation.fromValue=@1.0;
    popGrowAnimation.toValue=@1.4;
    popGrowAnimation.autoreverses = YES;
    
    self.groupShowAnimation = [CAAnimationGroup animation];
    self.groupShowAnimation.duration = growAnimation.duration + popGrowAnimation.duration*2.0f;
    self.groupShowAnimation.removedOnCompletion = NO;
    self.groupShowAnimation.fillMode = kCAFillModeForwards;
    self.groupShowAnimation.animations = @[growAnimation,popGrowAnimation];
    
    //hideButton Animations
    CABasicAnimation *popShrinkAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    popShrinkAnimation.duration=0.2f;
    popShrinkAnimation.beginTime = 0.0f;
    popShrinkAnimation.fromValue=@1.0;
    popShrinkAnimation.toValue=@1.4;
    popShrinkAnimation.autoreverses = YES;
    
    CABasicAnimation *shrinkAnimation;
    shrinkAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.duration=0.2f;
    shrinkAnimation.beginTime = popShrinkAnimation.duration*2;
    shrinkAnimation.fromValue= @1.0;
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.toValue= @0.1;
    
    
    self.groupHideAnimation = [CAAnimationGroup animation];
    self.groupHideAnimation.duration = popShrinkAnimation.duration*2.0f + shrinkAnimation.duration;
    self.groupHideAnimation.removedOnCompletion = YES;
    self.groupHideAnimation.fillMode = kCAFillModeForwards;
    self.groupHideAnimation.animations = @[popShrinkAnimation,shrinkAnimation];

}


- (void)toggleButton {
    
    CGFloat currentScaleValue = [[self.innerOnIconLayer.presentationLayer valueForKeyPath: @"transform.scale"] floatValue];

    //if on, turn off
    if (self.OnState) {
        
        [self.innerOnIconLayer removeAnimationForKey:@"growingInner"];
        CABasicAnimation *shrinkAnimation;
        shrinkAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.duration=1.0f;
        shrinkAnimation.fromValue= @(currentScaleValue);
        shrinkAnimation.fillMode = kCAFillModeForwards;
        shrinkAnimation.removedOnCompletion = NO;
        shrinkAnimation.toValue= @0.0;
        [self.innerOnIconLayer addAnimation:shrinkAnimation forKey:@"shrinkingInner"];
        self.OnState = NO;
        [self shimmerOn];
    }
    
    //if off turn on
    else {
        [self shimmerOff];
        CABasicAnimation *growAnimation;
        [self.innerOnIconLayer removeAnimationForKey:@"shrinkingInner"];
        growAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        growAnimation.duration=1.0f;
        growAnimation.fromValue= @(currentScaleValue);
        growAnimation.fillMode = kCAFillModeForwards;
        growAnimation.removedOnCompletion = NO;
        growAnimation.toValue= @1.0;
        
        self.OnState = YES;
        [self.innerOnIconLayer addAnimation:growAnimation forKey:@"growingInner"];
    }
    
  
}

- (void)shimmerOn {
    [self.gradientLayer addAnimation:self.shimmerAnimation forKey:@"animateGradient"];
}

- (void)shimmerOff {
    [self.gradientLayer removeAnimationForKey:@"animateGradient"];
}

- (void)showButtonWithAnimation:(bool)animated {
    self.alpha = 1.0f;
    if(animated){
    [self.layer addAnimation:self.groupShowAnimation forKey:@"showButton"];
    }
}

- (void)hideButtonWithAnimation:(bool)animated {
    if(animated){
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.alpha = 0.0f;
        }];
        [self.layer addAnimation:self.groupHideAnimation forKey:@"hideButton"];
        [CATransaction commit];
    }
    else {
        self.alpha = 0.0f;
    }
}

- (void)wiggleButton {
    self.animator = [[UIDynamicAnimator alloc] init];
    UIAttachmentBehavior *buttonAnchor = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:self.center];
    buttonAnchor.damping = 0.2f;
    buttonAnchor.frequency = 2.0f;
    [self.animator addBehavior:buttonAnchor];
    UIPushBehavior *buttonPushBehavior = [[UIPushBehavior alloc] initWithItems:@[self] mode:UIPushBehaviorModeInstantaneous];
    buttonPushBehavior.pushDirection = CGVectorMake(0.0f, -1.5f);
    [self.animator addBehavior:buttonPushBehavior];
    
    UIDynamicItemBehavior *buttonProperties = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    buttonProperties.resistance = 1.3f;
    [self.animator addBehavior:buttonProperties];
}

@end
