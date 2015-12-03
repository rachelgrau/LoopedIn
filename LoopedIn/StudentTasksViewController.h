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
/* If you only want to show tasks for a given class, set classToShow to that class. Otherwise set it to nil. */
@property PFObject *classToShow;
@end
