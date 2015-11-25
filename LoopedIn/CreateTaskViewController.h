//
//  CreateTaskViewController.h
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CreateTaskViewController : UIViewController <UIAlertViewDelegate>
/* This view can be used for creating OR editing a task */
@property BOOL isEditing;
@property PFObject *myClass;
@property PFObject *task;
@end
