//
//  CustomAlertView.h
//  mensajeria
//
//  Created by Rachel on 8/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//


/* This type of alert has an image (optional), title (optional), message (optional), and a list of buttons. The image is centered on the top of the alert. Below the image is the title, centered as well. Then, below the title is the message in slightly smaller font. Finally, below the message is a list buttons. If there is only one button, it will be teal. If there are 2, then the first button will be white and the second will be teal. Any others will be teal. When a button is clicked, the delegate method "clickedButtonAtIndex:" is called, letting the delegate know which button was pressed (by index). */

#import <UIKit/UIKit.h>

/* Image names */
#define IPAD_IMG_INTERESTING @"Interesting.png"
#define IPAD_HAPPY @"happy.png"

@interface CustomAlertView : UIView {
    id delegate;
    UIView *alertView;
}
@property id delegate;

- (id)initWithImage:(NSString *)imageName title:(NSString *)title message:(NSString *)message delegate:(id)alertDelegate buttonTitles:(NSArray *)buttonTitles;
- (void)showInView:(UIView*)view;

@end

@protocol CustomAlertDelegate
- (void)customAlertView:(CustomAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end