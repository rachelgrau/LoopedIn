//
//  CustomAlertView.m
//  mensajeria
//
//  Created by Rachel on 8/28/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//


#import "CustomAlertView.h"

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

@implementation CustomAlertView

- (void)centerViewHorizontallyInAlert:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat newX = (ALERT_WIDTH / 2) - (frame.size.width / 2);
    frame.origin.x = newX;
    view.frame = frame;
}

/* Sets up the view with the alert. It has an image, a title, a message, and buttons. If any of these are "nil" or the empty string, they will be left out. */
- (void)setUpAlertViewWithImage:(NSString *)imageName title:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)buttonTitles {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat startX = (screenWidth / 2) - (ALERT_WIDTH / 2);
    CGFloat startY = (screenHeight / 2) - (ALERT_HEIGHT / 2);
    
    alertView = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, ALERT_WIDTH, ALERT_HEIGHT)];
    [alertView setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat currentY = 0;
    
    /* Image */
    UIImage *alertImage = [UIImage imageNamed:imageName];
    UIImageView *alertImageView = [[UIImageView alloc] initWithImage:alertImage];
    [alertImageView setImage:alertImage];
    [alertView addSubview:alertImageView];
    CGRect imgFrame = alertImageView.frame;
    imgFrame.origin.y = PADDING;
    alertImageView.frame = imgFrame;
    [self centerViewHorizontallyInAlert:alertImageView];
    
    currentY += alertImageView.frame.size.height + PADDING;
    
    /* Main title */
    if (title && (![title isEqualToString:@""])) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY + TOP_TITLE_MARGIN, 0, 0)];
        titleLabel.text = title;
        [titleLabel sizeToFit];
        [self centerViewHorizontallyInAlert:titleLabel];
        [alertView addSubview:titleLabel];
        
        currentY += titleLabel.frame.size.height + TOP_TITLE_MARGIN;
    }
    
    /* Subtitle */
    if (message && (![message isEqualToString:@""])) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, currentY + TOP_MESSAGE_MARGIN, ALERT_WIDTH, 0)];
        [messageLabel setFont:[UIFont systemFontOfSize:14.0]];
        messageLabel.text = message;
        
        CGSize labelSize = [messageLabel.text sizeWithFont:messageLabel.font constrainedToSize:CGSizeMake(ALERT_WIDTH - (2*PADDING), 300000) lineBreakMode:NSLineBreakByWordWrapping];
        messageLabel.numberOfLines = 0;
        
        [messageLabel sizeToFit];
        
        CGRect messageFrame = messageLabel.frame;
        messageFrame.size = labelSize;
        messageLabel.frame = messageFrame;
        
        [self centerViewHorizontallyInAlert:messageLabel];
        [alertView addSubview:messageLabel];
        
        currentY += messageLabel.frame.size.height + TOP_MESSAGE_MARGIN;
    }
    
    /* Buttons */
    
    if ([buttonTitles count] == 1) {
        /* If only one button, make it sized to fit, and just add it directly to alert view */
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
    } else {
        /* If multiple buttons, add them to a container "buttonView" that we can center in the alert. Each button has same width. */
        UIView *buttonView = [[UIView alloc] init];
        NSInteger widthPerButton = (ALERT_WIDTH - (PADDING * 2) - (([buttonTitles count] - 1) * SPACE_BETWEEN_BUTTONS)) / [buttonTitles count];
        
        CGFloat currentX = 0;
        for (NSInteger i = 0; i < [buttonTitles count]; i++) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(currentX, 0, widthPerButton, BUTTON_HEIGHT)];
            [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
            button.tag = i;
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.layer.cornerRadius = 2;
            button.layer.masksToBounds = YES;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            if (i == 0) {
                /* First button is white. */
                button.backgroundColor = [UIColor whiteColor];
                [[button layer] setBorderWidth:1.0f];
                [[button layer] setBorderColor:[[UIColor colorWithRed:52.0/255 green:185.0/255 blue:200.0/255 alpha:1.0] CGColor]];
                [button setTitleColor:[UIColor colorWithRed:52.0/255 green:185.0/255 blue:200.0/255 alpha:1.0] forState:UIControlStateNormal];
            } else {
                /* Rest of buttons are teal. */
                button.backgroundColor = [UIColor colorWithRed:52.0/255 green:185.0/255 blue:200.0/255 alpha:1.0];
                button.titleLabel.textColor = [UIColor whiteColor];
            }
            [buttonView addSubview:button];
            
            currentX += SPACE_BETWEEN_BUTTONS + widthPerButton;
        }
        /* Make sure buttonView container is big enough to hold all buttons, then add it to alert. */
        CGRect buttonViewFrame = buttonView.frame;
        buttonViewFrame.size.width = ALERT_WIDTH - (PADDING * 2);
        buttonViewFrame.size.height = BUTTON_HEIGHT;
        buttonViewFrame.origin.y = currentY + TOP_BUTTON_MARGIN;
        buttonView.frame = buttonViewFrame;
        [self centerViewHorizontallyInAlert:buttonView];
        currentY += buttonViewFrame.size.height + PADDING;
        
        [alertView addSubview:buttonView];
    }
    
    alertView.layer.cornerRadius = 2;
    alertView.layer.masksToBounds = YES;
    
    CGRect alertViewFrame = alertView.frame;
    alertViewFrame.size.height = currentY;
    alertView.frame = alertViewFrame;
    
    [self addSubview:alertView];
}

-(void)buttonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customAlertView:clickedButtonAtIndex:)]) {
        [self.delegate customAlertView:self clickedButtonAtIndex:sender.tag];
    }
}

- (id)initWithImage:(NSString *)imageName title:(NSString *)title message:(NSString *)message delegate:(id)alertDelegate buttonTitles:(NSArray *)buttonTitles {
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
        
        [self setUpAlertViewWithImage:imageName title:title message:message buttonTitles:buttonTitles];
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
