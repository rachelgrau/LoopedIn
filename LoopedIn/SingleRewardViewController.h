//
//  SingleRewardViewController.h
//  LoopedIn
//
//  Created by Rachel on 11/18/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SingleRewardViewController : UIViewController <UIAlertViewDelegate> 
@property PFObject *reward;
@property PFObject *classMember;
@end
