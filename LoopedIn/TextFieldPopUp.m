//
//  CustomAlertView.m
//  mensajeria
//
//  Created by Rachel on 8/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//


#import "TextFieldPopUp.h"

#define ALERT_WIDTH 300
#define ALERT_HEIGHT 300

#define BUTTON_HEIGHT 30

/* margins */
#define PADDING 20
#define TOP_TITLE_MARGIN 10
#define TOP_MESSAGE_MARGIN 10
#define TOP_BUTTON_MARGIN 10

#define SPACE_BETWEEN_BUTTONS 15
#define BUTTON_PADDING 10f

@interface TextFieldPopUp ()
@property UITextField *textField;
@end

@implementation TextFieldPopUp

- (void)centerViewHorizontallyInAlert:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat newX = (ALERT_WIDTH / 2) - (frame.size.width / 2);
    frame.origin.x = newX;
    view.frame = frame;
}

/* Sets up the view with the alert. It has an image, a title, a message, and buttons. If any of these are "nil" or the empty string, they will be left out. */
- (void)setUpAlertViewWithPlaceholder:(NSString *)placeholder buttonTitles:(NSArray *)buttonTitles {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat startX = (screenWidth / 2) - (ALERT_WIDTH / 2);
    CGFloat startY = (screenHeight / 2) - (ALERT_HEIGHT / 2);
    
    alertView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, ALERT_WIDTH, ALERT_HEIGHT)];
    [alertView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat currentY = 0;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, ALERT_WIDTH - 20, 40)];
    self.textField.placeholder = placeholder;
    currentY += 40;
    [alertView addSubview:self.textField];
    self.textField.delegate = self.delegate;
    
    /* Button */

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, currentY + TOP_BUTTON_MARGIN, 0, BUTTON_HEIGHT)];
    [button setTitle:[buttonTitles objectAtIndex:0] forState:UIControlStateNormal];
    button.tag = 0;
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 2;
    button.layer.masksToBounds = YES;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button sizeToFit];
        
    /* Add padding */
    CGRect buttonFrame = button.frame;
    buttonFrame.size.width += (2 * PADDING);
    button.frame = buttonFrame;
        
    /* Teal button with white font */
    button.backgroundColor = [UIColor colorWithRed:52.0/255 green:185.0/255 blue:200.0/255 alpha:1.0];
    button.titleLabel.textColor = [UIColor whiteColor];
        
    currentY += button.frame.size.height + PADDING;
        
    [self centerViewHorizontallyInAlert:button];
    [alertView addSubview:button];
    
    
    alertView.layer.cornerRadius = 2;
    alertView.layer.masksToBounds = YES;
    
    CGRect alertViewFrame = alertView.frame;
    alertViewFrame.size.height = currentY;
    alertView.frame = alertViewFrame;
    
    [self addSubview:alertView];
}

-(void)buttonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:withTextFieldText:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:sender.tag withTextFieldText:self.textField.text];
    }
}

- (id)initWithPlaceholder:(NSString *)placeHolderText delegate:(id)alertDelegate buttonTitles:(NSArray *)buttonTitles {
    self.delegate = alertDelegate;
    CGRect frame;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationLandscapeRight) {
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    }
    else {
        frame = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    }
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        [self setUpAlertViewWithPlaceholder:placeHolderText buttonTitles:buttonTitles];
        return self;
    } else {
        return nil;
    }
}

- (void)showInView:(UIView*)view {
    if ([view isKindOfClass:[UIView class]]) {
        [view addSubview:self];
    }
}

- (void) dealloc {
}

@end
