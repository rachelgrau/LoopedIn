//
//  StudentTaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 12/2/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentTaskViewController.h"
#import "DBKeys.h"
#import "LoadingView.h"

#define MARK_COMPLETE_ALERT_TAG 1

@interface StudentTaskViewController ()
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIButton *markCompleteButton;
@end

@implementation StudentTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.task objectForKey:TASK_NAME];
    if (self.isCompleted) {
        [self.markCompleteButton setTitle:@"Mark Incomplete" forState:UIControlStateNormal];
    } else {
        [self.markCompleteButton setTitle:@"Mark Complete" forState:UIControlStateNormal];
    }
    
    /* Description */
    NSString *descText = [self.task objectForKey:TASK_DESC];
    if (descText.length == 0) {
        self.descriptionLabel.text = @"No description.";
    } else {
        self.descriptionLabel.text = [self.task objectForKey:TASK_DESC];
    }
    
    /* Due date */
    NSDate *date = [self.task objectForKey:TASK_DUE_DATE];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd"];
    NSString *theDate = [dateFormat stringFromDate:date];
    self.dateLabel.text = theDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)markCompleted:(id)sender {
    NSString *title;
    NSString *message;
    if (self.isCompleted) {
        title = @"Mark Incomplete?";
        message = @"You previously marked this task as complete. Are you sure you want to mark it as incomplete now?";
    } else {
        title = @"Mark Complete?";
        message = @"Are you sure you want to mark this task as complete?";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = MARK_COMPLETE_ALERT_TAG;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == MARK_COMPLETE_ALERT_TAG) {
        if (buttonIndex == 1) {
            /* Marking assignment as complete */
            NSString *loadingText;
            if (self.isCompleted) {
                loadingText = @"Marking complete...";
            } else {
                loadingText = @"Marking incomplete...";
            }
            LoadingView *loader = [[LoadingView alloc] initWithLoadingText:loadingText hasNavBar:YES];
            [self.view addSubview:loader];
            [loader startLoading];
            PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
            [query whereKey:TASK_COMPLETION_TASK equalTo:self.task];
            [query whereKey:TASK_COMPLETION_ASIGNEE equalTo:[PFUser currentUser]];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
                if (obj && !error) {
                    [obj setObject:[NSNumber numberWithBool:(!self.isCompleted)] forKey:TASK_IS_COMPLETED];
                    [obj saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                        /* Load ClassMember object to update points */
                        PFQuery *classMemberQuery = [PFQuery queryWithClassName:CLASS_MEMBER_CLASS_NAME];
                        [classMemberQuery whereKey:CLASS_MEMBER_CLASS equalTo:[self.task objectForKey:TASK_CLASS]];
                        [classMemberQuery whereKey:CLASS_MEMBER_STUDENT equalTo:[PFUser currentUser]];
                        [classMemberQuery getFirstObjectInBackgroundWithBlock:^(PFObject *classMember, NSError *err) {
                            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
                            f.numberStyle = NSNumberFormatterDecimalStyle;
                            NSNumber *taskPoints = [f numberFromString:[self.task objectForKey:TASK_POINTS]];
                            NSNumber *points = [classMember objectForKey:CLASS_MEMBER_POINTS_EARNED];
                            NSNumber *newPoints =  [NSNumber numberWithInt:([taskPoints intValue] + [points intValue])];
                            [classMember setObject:newPoints forKey:CLASS_MEMBER_POINTS_EARNED];
                            [classMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                [loader displayDoneAndPopToViewController:^{
                                    if (self.isCompleted) {
                                        // pop back to my tasks page (not completed tasks page)
                                        UIViewController *tasksViewController = [self.navigationController.viewControllers objectAtIndex:1];
                                        [self.navigationController popToViewController:tasksViewController animated:YES];
                                    } else {
                                        // pop back to my tasks page
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
                            }];
                        }];
                    }];
                } else {
                    [loader displayDoneAndPopToViewController:^{
                        if (self.isCompleted) {
                            // pop back to my tasks page (not completed tasks page)
                            UIViewController *tasksViewController = [self.navigationController.viewControllers objectAtIndex:1];
                            [self.navigationController popToViewController:tasksViewController animated:YES];
                        } else {
                            // pop back to my tasks page
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                }
            }];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
