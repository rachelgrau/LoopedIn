//
//  AllRewardsTableViewController.h
//  LoopedIn
//
//  Created by Rachel on 12/4/15.
//  Copyright © 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AllRewardsTableViewController : UITableViewController
@property PFObject *theClass;
@property PFObject *desiredReward;
@property NSNumber *studentsCurrentPoints;
@property PFObject *classMember;
@end
