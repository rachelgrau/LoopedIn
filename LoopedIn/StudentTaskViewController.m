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

@interface StudentTaskViewController ()
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@end

@implementation StudentTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [self.task objectForKey:TASK_NAME];
    
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
    LoadingView *loader = [[LoadingView alloc] initWithLoadingText:@"Marking complete..." hasNavBar:YES];
    [self.view addSubview:loader];
    [loader startLoading];
    PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
    [query whereKey:TASK_COMPLETION_TASK equalTo:self.task];
    [query whereKey:TASK_COMPLETION_ASIGNEE equalTo:[PFUser currentUser]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        if (obj && !error) {
            [obj setObject:[NSNumber numberWithBool:YES] forKey:TASK_IS_COMPLETED];
            [obj saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                [loader displayDoneAndPopToViewController:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
        } else {
            [loader displayDoneAndPopToViewController:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
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
