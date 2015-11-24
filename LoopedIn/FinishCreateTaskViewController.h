//
//  FinishCreateTaskViewController.h
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FinishCreateTaskViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property PFObject *task;
@property PFObject *myClass;
@end
