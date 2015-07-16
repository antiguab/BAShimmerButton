//
//  BAViewController.h
//  BAShimmerButton
//
//  Created by Bryan Antigua on 07/12/2015.
//  Copyright (c) 2015 Bryan Antigua. All rights reserved.
//

@import UIKit;
#import <BAShimmerButton/BAShimmerButton.h>

@interface BAViewController : UIViewController
@property (strong, nonatomic) IBOutlet BAShimmerButton *button;
- (IBAction)buttonPressed:(id)sender;
@end
