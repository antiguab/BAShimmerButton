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

#import <UIKit/UIKit.h>

/**
 Enum for different shimmering orientation and direction
 */
typedef NS_ENUM(NSInteger,BAShimmerDirection) {
    BAShimmerDirectionTopToBottom,
    BAShimmerDirectionBottomToTop,
    BAShimmerDirectionLeftToRight,
    BAShimmerDirectionDiagonalLeftToRight,
    BAShimmerDirectionRightToLeft,
    BAShimmerDirectionDiagonalRightToLeft
};

@interface BAShimmerButton : UIButton

/**
 UIColor for the Main portion of the gradient (goes from clear -> color -> clear)
 */
@property (strong, nonatomic) UIColor *shimmerColor;

/**
 Image that can be used in the center of the button, also used as the mask for the off state
 */
@property (strong, nonatomic) UIImage *iconImage;

/**
 UIColor for the off state mask, if available
 */
@property (strong, nonatomic) UIColor *iconOffImageColor;

/**
 Duration for one shimmer
 */
@property (assign, nonatomic) CGFloat shimmerDuration;

/**
Enum value for shimmering orientation and direction
 */
@property (assign, nonatomic) BAShimmerDirection shimmerDirection;

/**
 CGFloat to determine the total width of the gradient (between 0 - 1)
 */
@property (assign, nonatomic) CGFloat gradientSize;

/**
Turns the button from the on position to off or vice versa. The off -> on state involves turning off the shimmer and animating an icon if avaiable. The off -> on state involved turning on the shimmer and animating the icon in the reverse diretion
*/
- (void)toggleButton;

/**
Starts a growing animation for showing the button. You can choose to skip the animation
 
 @param animated
 Boolean for determining whether to animate and show or just show the button
 */
- (void)showButtonWithAnimation:(bool)animated;

/**
 Starts a shrinking animation for hiding the button. You can choose to skip the animation
 
 @param animated
 Boolean for determining whether to animate and hide or hide show the button
 */
- (void)hideButtonWithAnimation:(bool)animated;

/**
 Animation that makes the button wiggle up and down
 */
- (void)wiggleButton;
@end
