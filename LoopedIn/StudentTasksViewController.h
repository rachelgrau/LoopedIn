//
//  StudentTasksViewController.h
//  LoopedIn
//
//  Created by Rachel on 12/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudentTasksViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property PFUser *student;
@end
