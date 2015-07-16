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

@property (assign, nonatomic) bool onState;

//Properties for icon on and off states
@property (strong, nonatomic) CALayer *iconOffLayer;
@property (strong, nonatomic) CALayer *iconOnLayer;
@property (strong, nonatomic) CAShapeLayer *innerOnIconLayer;

//Properties for button on and off states
@property (strong, nonatomic) CABasicAnimation *shimmerAnimation;
@property (strong, nonatomic) CAAnimationGroup *showButtonAnimationGroup;
@property (strong, nonatomic) CAAnimationGroup *groupHideAnimationGroup;

//Properties for wiggle
@property(strong, nonatomic) UIDynamicAnimator *animator;

@end

@implementation BAShimmerButton

#pragma mark - Lifecycle

-  (id)initWithFrame:(CGRect)aRect {
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
    
    //BUG
    //For some reason just  changing the transform causing the initial animation to glitch
    //Doesn't seem to be setting the correct tranform scale factor
    if (!self.onState) {
        self.innerOnIconLayer.opacity = 0.0f;
        CABasicAnimation *transformHotFix;
        transformHotFix=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        transformHotFix.duration=0.0f;
        transformHotFix.fillMode = kCAFillModeForwards;
        transformHotFix.removedOnCompletion = NO;
        transformHotFix.toValue= @0.0f;
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.innerOnIconLayer.opacity = 1.0f;
        }];
        [self.innerOnIconLayer addAnimation:transformHotFix forKey:@"shrinkingInner"];
        [CATransaction commit];
    }
}

#pragma mark - Private

- (void)createShimmerAnimation {
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    
    //set gradient for shimmer
    self.gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)self.shimmerColor.CGColor, (id)[UIColor clearColor].CGColor];
    
    //Space out the gradient based on width
    NSArray *startLocations = @[@0.0f, @(self.gradientSize / 2), @(self.gradientSize)];
    NSArray *endLocations = @[@(1.0f - self.gradientSize), @(1.0f - (self.gradientSize / 2)), @1.0f];
    
    self.gradientLayer.locations = startLocations;
    [self setGradientDirection];
    
    //Shimmering button properties
    self.shimmerAnimation = [CABasicAnimation animationWithKeyPath:@"locations"];
    self.shimmerAnimation.fromValue = startLocations;
    self.shimmerAnimation.toValue = endLocations;
    self.shimmerAnimation.duration  = self.shimmerDuration;
    self.shimmerAnimation.repeatCount = HUGE_VALF;
}

- (void)initialize {
    
    //default values
    _shimmerDuration = 1.0f;
    _shimmerDirection = BAShimmerDirectionDiagonalLeftToRight;
    _shimmerColor = [UIColor colorWithHex:0x5A6363];
    _gradientSize = 30.0f / CGRectGetWidth(self.frame);
    self.onState = NO;
    [self setGradientDirection];
    [self createShimmerAnimation];
    
    [self.layer addSublayer:self.gradientLayer];
    [self shimmerOn];

    
    //hide initially
    self.alpha = 0.0f;
    
    //showButton Animations
    CABasicAnimation *growAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    growAnimation.duration=0.2f;
    growAnimation.beginTime = 0.0f;
    growAnimation.fromValue= @0.2;
    growAnimation.fillMode = kCAFillModeForwards;
    growAnimation.toValue=@1.0;
    
    CABasicAnimation *growPopAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    growPopAnimation.duration=0.2f;
    growPopAnimation.beginTime = growAnimation.duration;
    growPopAnimation.fromValue=@1.0;
    growPopAnimation.toValue=@1.4;
    growPopAnimation.autoreverses = YES;
    
    self.showButtonAnimationGroup = [CAAnimationGroup animation];
    self.showButtonAnimationGroup.duration = growAnimation.duration + growPopAnimation.duration*2.0f;
    self.showButtonAnimationGroup.removedOnCompletion = NO;
    self.showButtonAnimationGroup.fillMode = kCAFillModeForwards;
    self.showButtonAnimationGroup.animations = @[growAnimation,growPopAnimation];
    
    //hideButton Animations
    CABasicAnimation *shrinkPopAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrinkPopAnimation.duration=0.2f;
    shrinkPopAnimation.beginTime = 0.0f;
    shrinkPopAnimation.fromValue=@1.0;
    shrinkPopAnimation.toValue=@1.4;
    shrinkPopAnimation.autoreverses = YES;
    
    CABasicAnimation *shrinkAnimation;
    shrinkAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    shrinkAnimation.duration=0.2f;
    shrinkAnimation.beginTime = shrinkPopAnimation.duration*2;
    shrinkAnimation.fromValue= @1.0;
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.toValue= @0.1;
    
    
    self.groupHideAnimationGroup = [CAAnimationGroup animation];
    self.groupHideAnimationGroup.duration = shrinkPopAnimation.duration*2.0f + shrinkAnimation.duration;
    self.groupHideAnimationGroup.removedOnCompletion = YES;
    self.groupHideAnimationGroup.fillMode = kCAFillModeForwards;
    self.groupHideAnimationGroup.animations = @[shrinkPopAnimation,shrinkAnimation];
    
}


- (void)toggleButton {
    
    //In case button gets pressed mid animation
    CGFloat currentScaleValue = [[self.innerOnIconLayer.presentationLayer valueForKeyPath: @"transform.scale"] floatValue];
    
    //if on, turn off
    if (self.onState) {
        [self.innerOnIconLayer removeAnimationForKey:@"growingInner"];
        CABasicAnimation *shrinkAnimation;
        shrinkAnimation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
        shrinkAnimation.duration=1.0f;
        shrinkAnimation.fromValue= @(currentScaleValue);
        shrinkAnimation.fillMode = kCAFillModeForwards;
        shrinkAnimation.removedOnCompletion = NO;
        shrinkAnimation.toValue= @0.0;
        [self.innerOnIconLayer addAnimation:shrinkAnimation forKey:@"shrinkingInner"];
        
        self.onState = NO;
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
        
        self.onState = YES;
        [self.innerOnIconLayer addAnimation:growAnimation forKey:@"growingInner"];
    }
    
    
}

- (void)shimmerOn {
    [self.gradientLayer addAnimation:self.shimmerAnimation forKey:@"animateGradient"];
}

- (void)shimmerOff {
    [self.gradientLayer removeAnimationForKey:@"animateGradient"];
}

#pragma mark - Public

- (void)showButtonWithAnimation:(bool)animated {
    self.alpha = 1.0f;
    if(animated){
        [self.layer addAnimation:self.showButtonAnimationGroup forKey:@"showButton"];
    }
}

- (void)hideButtonWithAnimation:(bool)animated {
    if(animated){
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            self.alpha = 0.0f;
        }];
        [self.layer addAnimation:self.groupHideAnimationGroup forKey:@"hideButton"];
        [CATransaction commit];
    }
    else {
        self.alpha = 0.0f;
    }
}


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
    UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)) cornerRadius:MAX(CGRectGetWidth(self.frame)/2,CGRectGetHeight(self.frame)/2)];
    self.innerOnIconLayer.path = circularPath.CGPath;

    self.innerOnIconLayer.frame = self.frame;
    self.innerOnIconLayer.position = CGPointMake(CGRectGetWidth(self.iconOnLayer.frame)/2,CGRectGetHeight(self.iconOnLayer.frame)/2);
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
