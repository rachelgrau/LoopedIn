//
//  LoadingView.m
//  
//
//  Created by Rachel on 11/25/15.
//
//

#import "LoadingView.h"

@interface LoadingView()
@property NSString *loadingText;
@property UILabel *loadingLabel;
@property UIView *popUp;
@property UIImageView *doneImageView;
@property BOOL hasNavBar;
@end

#define ALERT_WIDTH 250
#define ALERT_HEIGHT 150

@implementation LoadingView

- (id)initWithLoadingText:(NSString *)loadingText hasNavBar:(BOOL)hasNavBar {
    self.loadingText = loadingText;
    self.hasNavBar = hasNavBar;
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
    }
    return self;
}

- (void)centerViewHorizontallyInAlert:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat newX = (ALERT_WIDTH / 2) - (frame.size.width / 2);
    frame.origin.x = newX;
    view.frame = frame;
}

- (void)centerVerticallyInAlert:(UIView *)view {
    CGRect frame = view.frame;
    CGFloat newY = (self.popUp.frame.size.height/2) - (frame.size.height / 2);
    frame.origin.y = newY;
    view.frame = frame;
}

- (void)startLoading {
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGFloat startX = (screenWidth / 2) - (ALERT_WIDTH / 2);
    CGFloat startY = (screenHeight / 2) - (ALERT_HEIGHT / 2);
    if (self.hasNavBar) {
        startY -= 44;
    }
    self.popUp = [[UIView alloc] initWithFrame:CGRectMake(startX, startY, ALERT_WIDTH, ALERT_HEIGHT)];
    [self.popUp setBackgroundColor:[UIColor whiteColor]];
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.loadingLabel.text = self.loadingText;
    self.loadingLabel.font = [UIFont fontWithName:@"Avenir Book" size:24.0f];
    [self.loadingLabel sizeToFit];
    
    [self centerVerticallyInAlert:self.loadingLabel];
    [self centerViewHorizontallyInAlert:self.loadingLabel];
    [self.popUp addSubview:self.loadingLabel];
    
    
    [self addSubview:self.popUp];
}

- (void) displayDoneAndPopToViewController:(void (^)(void))callbackBlock {
    [self.loadingLabel removeFromSuperview];
    self.doneImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    [self.doneImageView setImage:[UIImage imageNamed:@"checkBullitenBoard.png"]];
    [self centerViewHorizontallyInAlert:self.doneImageView];
    [self centerVerticallyInAlert:self.doneImageView];
    CGRect finalFrame = self.doneImageView.frame;
    CGRect startFrame = CGRectZero;
    self.doneImageView.frame = startFrame;
    [self.popUp addSubview:self.doneImageView];
    
    [UIView animateWithDuration:.5f animations:^(void){
        self.doneImageView.frame = finalFrame;
    }completion:^(BOOL finished) {
        [self performSelector:@selector(disappearAndPerform:) withObject:callbackBlock afterDelay:2.0f];
    }];
}

- (void) disappearAndPerform:(void (^)(void))callbackBlock {
    [self removeFromSuperview];
    callbackBlock();
}

- (void) dealloc {
    if (self.doneImageView) {
        [self.doneImageView removeFromSuperview];
    }
}

@end

