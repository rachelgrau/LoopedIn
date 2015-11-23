//
//  TextFieldPopUp.h
//  LoopedIn
//
//  Created by Rachel on 11/22/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//
//  A pop up that contains a text field and a single button. Uses a protocol to notify the delegate of this class when the button is clicked (and tells them what text is in the text field). If you click outside the pop up, the pop up will disappear.

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>

/* Image names */
#define IPAD_IMG_INTERESTING @"Interesting.png"
#define IPAD_HAPPY @"happy.png"

@interface TextFieldPopUp : UIView {
    id delegate;
    UIView *alertView;
}
@property id delegate;

- (id)initWithPlaceholder:(NSString *)placeHolderText delegate:(id)alertDelegate buttonTitles:(NSArray *)buttonTitles;
- (void)showInView:(UIView*)view;
/* Disables the single button on this popup */
- (void)disableButton;
/* Enables the single button on this popup */
- (void)enableButton;
/* Displays a red error message right above the text field */
- (void)displayErrorMessage:(NSString *)errorMessage;
/* Displays a success message and disappears */
- (void)displaySuccessAndDisappear;
@end

@protocol CustomAlertDelegate
/* Alerts the delegate when the user clicks on a button on this pop up. |buttonIndex| is the index of the button they clicked on. |text| is whatever text is currently in the text field. */
- (void)customAlertView:(TextFieldPopUp *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withTextFieldText:(NSString *)text;
@end