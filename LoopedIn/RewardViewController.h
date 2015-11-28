//
//  RewardViewController.h
//  LoopedIn
//
//  Created by Rachel on 11/25/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RewardViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
@property PFObject *reward;
@end
