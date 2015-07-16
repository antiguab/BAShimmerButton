//
//  BAViewController.m
//  BAShimmerButton
//
//  Created by Bryan Antigua on 07/12/2015.
//  Copyright (c) 2015 Bryan Antigua. All rights reserved.
//

#import "BAViewController.h"
#import <BAShimmerButton/BAShimmerButton.h>
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface BAViewController ()

@end

@implementation BAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        //1.a make a circle layer for the button outline
        CAShapeLayer *circle = [CAShapeLayer layer];
    
        //1.b create a circular path
        UIBezierPath *circularPath=[UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.button.frame.size.width,self.button.frame.size.height) cornerRadius:MAX(self.button.frame.size.width/2,self.button.frame.size.height/2)];
    
        //1.c set the circles path to the  UIBezierPath's path
        circle.path = circularPath.CGPath;
        self.button.layer.mask = circle;
    
//    self.button.shimmerDuration = 5.0f;
    self.button.backgroundColor = [self colorWithHex:0x22313F];
    self.button.shimmerColor = [self colorWithHex:0x3498db];
    self.button.iconImage = [UIImage imageNamed:@"icon"];
    [self.button showButtonWithAnimation:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor*)colorWithHex:(int)hex
{
    return UIColorFromRGB(hex);
}

- (IBAction)buttonPressed:(id)sender {
    [self.button toggleButton];
}

@end
