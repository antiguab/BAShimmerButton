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

#import "BAViewController.h"
#import "BAShimmerButton.h"
#import "UIColor+ColorWithHex.h"

@interface BAViewController ()

@property(assign, nonatomic) BOOL firstLoad;
@property(strong, nonatomic) NSMutableArray *buttonArray;

@end

@implementation BAViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.buttonArray = [NSMutableArray array];
    self.firstLoad = YES;
    
    [self configureTitle];
    
    self.OuterContainerView.backgroundColor = [UIColor colorWithHex:0xebbf69];
    self.InnerContainerView.backgroundColor = [UIColor clearColor];
    self.InnerContainerView.layer.borderColor = [UIColor colorWithHex:0xe49642].CGColor;
    self.InnerContainerView.layer.borderWidth = 5.0f;
    
}

//- (void)hidebut {
//    BAShimmerButton * button = (BAShimmerButton*)[self.view viewWithTag:105];
//    [self addCircularMask:button];
//    [button wiggleButton];//@NO skips the animation
//}
- (void)viewDidLayoutSubviews {
    if(self.firstLoad && [self.buttonExamples count] > 0){
//        NSInteger tag = 105;
//        BAShimmerButton * button = (BAShimmerButton*)[self.view viewWithTag:tag];
//        [self addCircularMask:button];
//        button.backgroundColor = [UIColor colorWithHex:0x22313F];
//        button.shimmerColor = [UIColor colorWithHex:0x3498db];
//        button.iconOffImageColor = [UIColor colorWithHex:0xfffffff];
//        button.iconImage = [UIImage imageNamed:@"icon"];
//        [button showButtonWithAnimation:@NO];//@NO skips the animation

        for(int i = 0; i < [self.buttonExamples count]; i++) {
            NSInteger tag = 101 + i;
            BAShimmerButton * button = (BAShimmerButton*)[self.view viewWithTag:tag];
            NSArray *params= @[button,@YES];
            switch (tag) {
                case 101:
                {
                    [self addCircularMask:button];
                    break;
                }
                    
                case 102:
                {
                    [self addRoundedSquareMask:button];
                    button.backgroundColor = [UIColor colorWithHex:0x420013];
                    button.shimmerColor = [UIColor colorWithHex:0xe33550];
                    button.shimmerDirection = BAShimmerDirectionLeftToRight;
                    break;
                }
                    
                case 103:
                {
                    [self addCircularMask:button];
                    button.backgroundColor = [UIColor colorWithHex:0x22313F];
                    button.shimmerColor = [UIColor colorWithHex:0x3498db];
                    button.shimmerDirection = BAShimmerDirectionTopToBottom;
                    button.shimmerDuration = 1.0f;
                    break;
                }
                    
                case 104:
                {
                    [self addCircularMask:button];
                    button.iconImage = [UIImage imageNamed:@"icon"];
                    break;
                }
                    
                case 105:
                {
                    [self addRoundedSquareMask:button];
                    button.backgroundColor = [UIColor colorWithHex:0x420013];
                    button.shimmerColor = [UIColor colorWithHex:0xe33550];
                    button.iconImage = [UIImage imageNamed:@"icon"];
                    button.shimmerDirection = BAShimmerDirectionLeftToRight;
                    break;
                }
                    
                case 106:
                {
                    [self addCircularMask:button];
                    button.backgroundColor = [UIColor colorWithHex:0x22313F];
                    button.shimmerColor = [UIColor colorWithHex:0x3498db];
                    button.iconImage = [UIImage imageNamed:@"icon"];
                    button.shimmerDirection = BAShimmerDirectionTopToBottom;
                    button.shimmerDuration = 1.0f;
                    
                    break;
                }
                    
                case 107:
                {
                    [self addCircularMask:button];
                    button.iconImage = [UIImage imageNamed:@"icon"];
                    break;
                }
                    
                case 108:
                {
                    [self addRoundedSquareMask:button];
                    button.backgroundColor = [UIColor colorWithHex:0x420013];
                    button.shimmerColor = [UIColor colorWithHex:0xe33550];
                    button.iconImage = [UIImage imageNamed:@"icon"];
                    button.shimmerDirection = BAShimmerDirectionLeftToRight;
                    break;
                }
                    
                case 109:
                {
                    [self addCircularMask:button];
                    button.backgroundColor = [UIColor colorWithHex:0x22313F];
                    button.shimmerColor = [UIColor colorWithHex:0x3498db];
                    button.iconImage = [UIImage imageNamed:@"icon"];
                    button.shimmerDirection = BAShimmerDirectionTopToBottom;
                    button.shimmerDuration = 1.0f;
                    break;
                }
                    
                default:
                    break;
            }
            [self performSelector:@selector(showButtonWithAnimation:) withObject:params afterDelay:0.02*i];
        }
        
        [NSTimer scheduledTimerWithTimeInterval:2.0
                                         target:self
                                       selector:@selector(wiggleButtons)
                                       userInfo:nil
                                        repeats:YES];
        self.firstLoad = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions

- (IBAction)buttonPressed:(id)sender {
    BAShimmerButton *button = (BAShimmerButton*)sender;
    [button toggleButton];
}

#pragma mark - Private

- (void)configureTitle {
    
    //adding two fonts to one text label (Makes shimmer bolder)
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    [title addAttribute:NSFontAttributeName
                  value:[UIFont fontWithName:@"BebasNeueBold" size:self.titleLabel.font.pointSize]
                  range:NSMakeRange(2, 7)];
    self.titleLabel.attributedText = title;
    self.titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.titleLabel.layer.shadowOffset = CGSizeMake(1.0f,1.0f);
    self.titleLabel.layer.masksToBounds = NO;
    self.titleLabel.layer.shadowRadius = 3.0f;
    self.titleLabel.layer.shadowOpacity = 0.5;
    
}

- (void)addCircularMask:(BAShimmerButton*)button {
    //make a circle layer for the button outline
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    //create a circular path
    UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, button.frame.size.width,button.frame.size.height) cornerRadius:MAX(button.frame.size.width/2,button.frame.size.height/2)];
    
    //set the circles path to the  UIBezierPath's path
    circle.path = circularPath.CGPath;
    button.layer.mask = circle;
}

- (void)addRoundedSquareMask:(BAShimmerButton*)button {
    //make a rounded square layer for the button outline
    CAShapeLayer *roudedSquare = [CAShapeLayer layer];
    
    //create a rounded square path
    UIBezierPath *roudedSquarePath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, button.frame.size.width,button.frame.size.height) cornerRadius:5];
    
    //set the square path to the  UIBezierPath's path
    roudedSquare.path = roudedSquarePath.CGPath;
    button.layer.mask = roudedSquare;
}

- (void)showButtonWithAnimation:(NSArray*)params {
    
    //show all buttons
    BAShimmerButton *button = (BAShimmerButton*)[params objectAtIndex:0];
    BOOL animate = [[params objectAtIndex:1] boolValue];
    [button showButtonWithAnimation:animate];
}

- (void)wiggleButtons {
    
    BAShimmerButton * firstButton = (BAShimmerButton*)[self.view viewWithTag:107];
    [firstButton wiggleButton];
    BAShimmerButton * secondButton = (BAShimmerButton*)[self.view viewWithTag:108];
    [NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:secondButton
                                   selector:@selector(wiggleButton)
                                   userInfo:nil
                                    repeats:NO];
    BAShimmerButton * thirdButton = (BAShimmerButton*)[self.view viewWithTag:109];
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:thirdButton
                                   selector:@selector(wiggleButton)
                                   userInfo:nil
                                    repeats:NO];
}
@end



