//
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

#import "BABackgroundUIView.h"
#import "UIColor+colorWithHex.h"

@implementation BABackgroundUIView

#pragma mark - Lifecycle

- (void)layoutSubviews {
    
    [super layoutSubviews];
    //creates a neat gradient
    CAGradientLayer *tempLayer = [CAGradientLayer layer];
    tempLayer.frame = self.bounds;
    tempLayer.colors = @[(id)[UIColor colorWithHex:0x61f5e3].CGColor, (id)[UIColor colorWithHex:0x74bfd4].CGColor,(id)[UIColor colorWithHex:0x79b6d2].CGColor,(id)[UIColor colorWithHex:0xa94eb8].CGColor];
    tempLayer.locations = @[[NSNumber numberWithFloat:0.5f], [NSNumber numberWithFloat:0.7f], [NSNumber numberWithFloat:0.8f],[NSNumber numberWithFloat:1.0f]];
    tempLayer.startPoint = CGPointMake(0, 0);
    tempLayer.endPoint = CGPointMake(0, 1);
    [self.layer insertSublayer:tempLayer atIndex:0];
}
@end
