# BAShimmerButton

[![CI Status](http://img.shields.io/travis/Bryan Antigua/BAShimmerButton.svg?style=flat)](https://travis-ci.org/Bryan Antigua/BAShimmerButton)
[![Version](https://img.shields.io/cocoapods/v/BAShimmerButton.svg?style=flat)](http://cocoapods.org/pods/BAShimmerButton)
[![License](https://img.shields.io/cocoapods/l/BAShimmerButton.svg?style=flat)](http://cocoapods.org/pods/BAShimmerButton)
[![Platform](https://img.shields.io/cocoapods/p/BAShimmerButton.svg?style=flat)](http://cocoapods.org/pods/BAShimmerButton)


## Overview
![examplea](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/examplea.gif)
![example1](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example1.gif)
![exampleb](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/exampleb.gif)

A call-to-action button that offers shimmer, movement, and off/on functionality. Great for getting a users attention in multiple ways!

<br/>

## Requirements
* Works on any iOS device

<br/>

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

<br/>

## Getting Started
### Installation

BAShimmerButton is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "BAShimmerButton"
```

### Simple Usage


#### Basic
To add a `BAShimmerButton` to your app, add the line:

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
[self addCircularMask:button];
[button showButtonWithAnimation:@YES];//@NO skips the animation
```
**Note: circular mask added beforehand**
**Note: You can skip the first line, if you added the button in IB**

This creates the following animation/button:

![example1](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example1.gif)


### Advanced Usage
Listed below are examples of several properties that you can control. 

#### Init
You can use `initWithFrame:` or simply adding the view in Interface Builder to use this button. 

####showButtonWithAnimation:(bool)animated
Calling this method shows the button, by passing in `@NO`, you will simply show the button. If you pass `@YES`, you'll see the following animation (same code in the **basic** section):

![example1](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example1.gif)

####hideButtonWithAnimation:(bool)animated
Similar to the one above, but the reverse:

![example2](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example2.gif)

####toggleButton
This will transiton the button from the on to off state, or vice versa. The IB action can be done like the example below:

```objc
- (IBAction)buttonPressed:(id)sender {
    BAShimmerButton *button = (BAShimmerButton*)sender;
    [button toggleButton];
}
```

You can then produce the following:

![example3](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example3.gif)
![example4](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example4.gif)


####wiggleButton
To draw attention to your button, try this method:
```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
[self addCircularMask:button];
[button showButtonWithAnimation:@NO];
[button wiggleButton];
```
which results in the following:
![example5](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example5.gif)


#### Icon Image

An icon image can be set for the button with the `iconImage` property. This also results in a mask of the image for the off state (color of your choosing).

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
[self addCircularMask:button];
button.backgroundColor = [UIColor colorWithHex:0x420013];
button.shimmerColor = [UIColor colorWithHex:0xe33550];
button.iconImage = [UIImage imageNamed:@"icon"];
[button showButtonWithAnimation:@NO];//@NO skips the animation
```
This creates this button:

![example10](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example10.gif)

#### IconOff ImageColor

For the off state of the icon above, you can set different off colors:

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
button.gradientSize = 0.3f;
button.backgroundColor = [UIColor colorWithHex:0x420013];
button.shimmerColor = [UIColor colorWithHex:0xe33550];
button.iconOffImageColor = [UIColor colorWithHex:0xfffffff];
button.iconImage = [UIImage imageNamed:@"icon"];
[button showButtonWithAnimation:@NO];
```
**Note: Set before you set iconImage**
This creates the following view:

![example11](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example11.gif)

#### Shimmer Duration
If you want the shimmering to last longer/shorter, you can edit the `shimmerDuration` property:

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
button.shimmerDuration = 1.0f;
[button showButtonWithAnimation:@NO];
```

This results in the following:

![example6](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example6.gif)

#### Shimmer Color
You can also change the overall color of the shimmer by editing the `shimmerColor` property:

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
[self addRoundedSquareMask:button];
button.backgroundColor = [UIColor colorWithHex:0x22313F];
button.shimmerColor = [UIColor colorWithHex:0x3498db];
[button showButtonWithAnimation:@NO];
```

This creates the following effect:

![example7](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example7.gif)

#### Shimmer Direction

By default, the animation goes from left to right in a diagonal direction. You can change the direction by setting the `shimmerDirection` property with any of the following:

* BAShimmerDirectionTopToBottom
* BAShimmerDirectionBottomToTop
* BAShimmerDirectionLeftToRight
* BAShimmerDirectionDiagonalLeftToRight
* BAShimmerDirectionRightToLeft
* BAShimmerDirectionDiagonalRightToLeft
   
Setting a new direction can be done like so:

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
button.shimmerDuration = BAShimmerDirectionTopToBottom;
[button showButtonWithAnimation:@NO];
```
This creates the following view:

![example8](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example8.gif)

#### Gradient Size

the gradient size can be adjust with the `gradientSize` property. This value is betwee 0 and 1 and determines how wide the entire shimmer should be:

```objc
BAShimmerButton *button = [[BAShimmerButton alloc] initWithFrame:self.view.frame];
button.gradientSize = 0.3f;
[button showButtonWithAnimation:@NO];
```
This creates the following button:

![example9](https://github.com/antiguab/BAShimmerButton/blob/master/readmeAssets/example9.gif)

## Author

Bryan Antigua, antigua.B@gmail.com - [bryanantigua.com](bryanantigua.com)


## License

BAShimmerButton is available under the MIT license. See the LICENSE file for more info.

