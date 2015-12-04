//
//  SingleClassTaskViewController.h
//  LoopedIn
//
//  Created by Rachel on 12/4/15.
//  Copyright © 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SingleClassTaskViewController : UIViewController
@property PFUser *student;
@property PFObject *classToShow;
/* Call this to change the current student's desired reward to |newDesiredReward| */
-(void)desiredRewardChangedTo:(PFObject *)newDesiredReward;
@end
