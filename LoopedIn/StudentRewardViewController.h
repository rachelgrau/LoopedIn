//
//  StudentRewardViewController.h
//  LoopedIn
//
//  Created by Rachel on 11/17/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudentRewardViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property PFObject *desiredReward;
/* Call this to change the current student's desired reward to |newDesiredReward| */
-(void)desiredRewardChangedTo:(PFObject *)newDesiredReward;
@end
