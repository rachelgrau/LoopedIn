//
//  LoadingView.h
//  
//
//  Created by Rachel on 11/25/15.
//
//  A pop up that will display itself when startLoading is called. It will display |loadingText| until displayDoneAndperformCallback is called, at which point it will display a done message and then disappear.

#import <UIKit/UIKit.h>

@interface LoadingView : UIView
/* |loadingText| is the text you want to display on the popup. |hasNavBar| indicates whether the view you are displaying this pop up in has a nav bar (affects vertical centering). */
- (id)initWithLoadingText:(NSString *)loadingText hasNavBar:(BOOL)hasNavBar;
- (void)startLoading;
/* Displays the done loading icon for a couple seconds, then makes this popup view disappear and calls |callbackBlock| (e.g. callbackBlock might want to pop the view controller) */
- (void)displayDoneAndPopToViewController:(void (^)())callbackBlock;
@end
