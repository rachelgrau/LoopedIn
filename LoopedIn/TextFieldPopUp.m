//
//  CustomAlertView.m
//  mensajeria
//
//  Created by Rachel on 8/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//


#import "TextFieldPopUp.h"
#import "Common.h"

#define ALERT_WIDTH 250
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
@property UIButton *button;
@property UIButton *backgroundButton;
@property UILabel *errorMessageLabel;
@property UIImageView *successImageView;
@end

@implementation TextFieldPopUp

- (void)centerViewHorizontallyInAlert:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat newX = (ALERT_WIDTH / 2) - (frame.size.width / 2);
    frame.origin.x = newX;
    view.frame = frame;
}

- (void)centerVerticallyInAlert:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat newY = (alertView.frame.size.height/2) - (frame.size.height / 2);
    frame.origin.y = newY;
    view.frame = frame;
}

/* Sets up the view with the alert. It has an image, a title, a message, and buttons. If any of these are "nil" or the empty string, they will be left out. */
- (void)setUpAlertViewWithPlaceholder:(NSString *)placeholder buttonTitles:(NSArray *)buttonTitles errorMessage:(NSString *)errorMessage {
    /* Button that covers background; if you tap on it, pop up dies */
    if (!self.backgroundButton) {
        self.backgroundButton = [[UIButton alloc] initWithFrame:self.frame];
        [self.backgroundButton setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]];
        [self.backgroundButton addTarget:self action:@selector(tappedBackground) forControlEvents:UIControlEventAllTouchEvents];
        [self addSubview:self.backgroundButton];
        
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
        CGFloat startX = (screenWidth / 2) - (ALERT_WIDTH / 2);
        CGFloat startY = (screenHeight / 2) - (ALERT_HEIGHT / 2);
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, ALERT_WIDTH, ALERT_HEIGHT)];
        [alertView setBackgroundColor:[UIColor whiteColor]];
    }
    
    CGFloat currentY = PADDING;
    
    /* ERROR MESSAGE */
    if (!self.errorMessageLabel && errorMessage) {
        self.errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY, 0, 0)];
        self.errorMessageLabel.text = errorMessage;
        self.errorMessageLabel.font = [UIFont fontWithName:@"Avenir Book" size:14.0];
        self.errorMessageLabel.textColor = [UIColor redColor];
        [self.errorMessageLabel sizeToFit];
    }
    if (errorMessage) {
        currentY += self.errorMessageLabel.frame.size.height;
    }
    
    /* TEXT FIELD */
    if (!self.textField) {
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(30, currentY, ALERT_WIDTH - 60, 40)];
        [Common setBorder:self.textField withColor:[UIColor blackColor]];
        self.textField.placeholder = placeholder;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:placeholder
                                        attributes:@{
                                                     NSForegroundColorAttributeName: [UIColor grayColor],
                                                     NSFontAttributeName : [UIFont fontWithName:@"Avenir Book" size:16.0]
                                                     }
         ];
        self.textField.delegate = self.delegate;
    }
    CGRect textFieldFrame = self.textField.frame;
    textFieldFrame.origin.y = currentY;
    self.textField.frame = textFieldFrame;
    currentY += textFieldFrame.size.height;

    /* BUTTON */
    if (!self.button) {
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, currentY + TOP_BUTTON_MARGIN, 0, BUTTON_HEIGHT)];
        [self.button setTitle:[buttonTitles objectAtIndex:0] forState:UIControlStateNormal];
        self.button.tag = 0;
        [self.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.button.layer.cornerRadius = 2;
        self.button.layer.masksToBounds = YES;
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.button.enabled = YES;
        CGRect buttonFrame = self.button.frame;
        buttonFrame.size.width = self.textField.frame.size.width;
        buttonFrame.size.height = self.textField.frame.size.height;
        buttonFrame.origin.y = currentY;
        self.button.frame = buttonFrame;
        self.button.titleLabel.font = [UIFont fontWithName:@"Avenir Book" size:16.0];
        self.button.backgroundColor = [UIColor colorWithRed:68.f/255.f green:216.f/255.f blue:175.f/255.f alpha:1.0];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    }
    CGRect buttonFrame = self.button.frame;
    buttonFrame.origin.y = currentY + TOP_BUTTON_MARGIN;
    self.button.frame = buttonFrame;
    
    currentY = (self.button.frame.origin.y + self.button.frame.size.height + PADDING);
    
    if (errorMessage) {
        [self centerViewHorizontallyInAlert:self.errorMessageLabel];
    }
    [self centerViewHorizontallyInAlert:self.textField];
    [self centerViewHorizontallyInAlert:self.button];
    if (errorMessage) {
        [alertView addSubview:self.errorMessageLabel];
    }
    [alertView addSubview:self.textField];
    [alertView addSubview:self.button];
    
    alertView.layer.cornerRadius = 2;
    alertView.layer.masksToBounds = YES;
    
    CGRect alertViewFrame = alertView.frame;
    alertViewFrame.size.height = currentY;
    alertView.frame = alertViewFrame;
    
    [self addSubview:alertView];
}

/* If they touch the button, let the delegate know (and tell them the text that's in the text field) */
-(void)buttonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:withTextFieldText:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:sender.tag withTextFieldText:self.textField.text];
    }
}

/* If they tap the background, dieeeeee! */
- (void)tappedBackground {
    [self removeFromSuperview];
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
        [self setUpAlertViewWithPlaceholder:placeHolderText buttonTitles:buttonTitles errorMessage:nil];
        return self;
    } else {
        return nil;
    }
}

- (void)displayErrorMessage:(NSString *)errorMessage {
    [self setUpAlertViewWithPlaceholder:nil buttonTitles:nil errorMessage:errorMessage];
}

- (void)displaySuccessAndDisappear {
    self.backgroundButton.enabled = NO;
    if (self.errorMessageLabel) {
        [self.errorMessageLabel removeFromSuperview];
    }
    [self.textField removeFromSuperview];
    [self.button removeFromSuperview];
    
    self.successImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    [self.successImageView setImage:[UIImage imageNamed:@"checkBullitenBoard.png"]];
    [self centerViewHorizontallyInAlert:self.successImageView];
    [self centerVerticallyInAlert:self.successImageView];
    
    CGRect finalFrame = self.successImageView.frame;
    CGRect startFrame = CGRectZero;
    self.successImageView.frame = startFrame;
    [alertView addSubview:self.successImageView];
    
    [UIView animateWithDuration:.5f animations:^(void){
        self.successImageView.frame = finalFrame;
    }completion:^(BOOL finished) {
        [self performSelector:@selector(disappear) withObject:nil afterDelay:2.0f];
    }];
}

- (void)showInView:(UIView*)view {
    if ([view isKindOfClass:[UIView class]]) {
        [view addSubview:self];
    }
}

- (void)enableButton {
    self.button.enabled = YES;
    self.backgroundButton.enabled = YES;
}

- (void)disableButton {
    self.button.enabled = NO;
    self.backgroundButton.enabled = NO;
}

- (void) disappear {
    [self removeFromSuperview];
}
- (void) dealloc {
    if (self.button) {
        [self.button removeFromSuperview];
    }
    if (self.textField) {
        [self.textField removeFromSuperview];
    }
    self.delegate = nil;
}

@end
