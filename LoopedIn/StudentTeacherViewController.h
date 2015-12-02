//
//  StudentTeacherViewController.h
//  LoopedIn
//
//  Created by Rachel on 11/24/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudentTeacherViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property PFUser *student;
@end
