//
//  TextFieldPopUp.h
//  LoopedIn
//
//  Created by Rachel on 11/22/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

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

@end

@protocol CustomAlertDelegate
/* Alerts the delegate when the user clicks on a button on this pop up. |buttonIndex| is the index of the button they clicked on. |text| is whatever text is currently in the text field. */
- (void)customAlertView:(TextFieldPopUp *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withTextFieldText:(NSString *)text;
@end