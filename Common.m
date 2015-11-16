//
//  Common.m
//  
//
//  Created by Rachel on 11/10/15.
//
//

#import "Common.h"

@implementation Common

+ (void)setBorder:(UIView *)view withColor:(UIColor *)color {
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 1.0f;
}

+ (void)setUpNavBar:(UIViewController *)vc {
    vc.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:88.0/255.0 green:227.0/255.0 blue:195.0/255.0 alpha:1.0];
    vc.navigationController.navigationBar.translucent = NO;
    vc.title = @"Looped In";
    [vc.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Book" size:21]}];
}

@end
