//
//  TeacherHomeViewController.m
//  
//
//  Created by Rachel on 11/2/15.
//
//

#import "TeacherHomeViewController.h"
#import "SignUpViewController.h"
#import "TasksTableViewController.h"
#import "StudentListTableViewController.h"
#import "RewardsTableViewController.h"
#import "LoadingView.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "DBKeys.h"

@interface TeacherHomeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *studentsButton;
@property (strong, nonatomic) IBOutlet UIButton *tasksButton;
@property (strong, nonatomic) IBOutlet UILabel *classCodeLabel;
@property (strong, nonatomic) IBOutlet UIButton *rewardsButton;
@end

#define LOGOUT_TAG 1

@implementation TeacherHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.myClass) {
        self.classCodeLabel.text = [NSString stringWithFormat:@"Class code: %@", [self.myClass objectForKey:CLASS_CODE]];
    } else {
        self.studentsButton.enabled = NO;
        PFQuery *query = [PFQuery queryWithClassName:CLASS_CLASS_NAME];
        [query whereKey:CLASS_TEACHER equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
            if (obj) {
                self.myClass = obj;
                self.classCodeLabel.text = [NSString stringWithFormat:@"Class code: %@", [self.myClass objectForKey:CLASS_CODE]];
            }
            self.studentsButton.enabled = YES;
        }];
    }
    
    /* Set class code label */
    self.classCodeLabel.layer.masksToBounds = YES;
    self.classCodeLabel.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    self.classCodeLabel.layer.borderWidth = 3.0f;
    self.classCodeLabel.layer.cornerRadius = 2.0f;
    
    /* Set navigation title */
    [Common setUpNavBar:self];
    PFQuery *classQuery = [PFQuery queryWithClassName:CLASS_CLASS_NAME];
    [classQuery whereKey:CLASS_TEACHER equalTo:[PFUser currentUser]];
    [classQuery getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
        if (obj) {
            self.myClass = obj;
            self.title = [obj objectForKey:CLASS_NAME];
        }
    }];
    
    /* Add settings button */
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsButtonImage = [UIImage imageNamed:@"settings.png"];
    [settingsButton setBackgroundImage:settingsButtonImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *settingsNavButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsNavButton;
}

- (void)goToSettings:(id)sender {
    /* TEMP: just log the user out */
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log out" message:@"Are you sure you want to log out?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = LOGOUT_TAG;
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutPressed:(id)sender {
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}

- (IBAction)clickedStudents:(id)sender {
    [self performSegueWithIdentifier:@"toStudentList" sender:self];
}

- (IBAction)clickedRewards:(id)sender {
    [self performSegueWithIdentifier:@"toRewardsList" sender:self];
}

- (IBAction)clickedTasks:(id)sender {
    [self performSegueWithIdentifier:@"toTaskList" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toStudentList"]) {
        StudentListTableViewController *dest = segue.destinationViewController;
        dest.myClass = self.myClass;
    } else if ([segue.identifier isEqualToString:@"toTaskList"]) {
        TasksTableViewController *dest = segue.destinationViewController;
        dest.myClass = self.myClass;
    } else if ([segue.identifier isEqualToString:@"toRewardsList"]) {
        RewardsTableViewController *dest = segue.destinationViewController;
        dest.myClass = self.myClass;
    }
}

#pragma mark - Alert View Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == LOGOUT_TAG) {
        if (buttonIndex == 1) {
            [PFUser logOut];
            [self performSegueWithIdentifier:@"toLogIn" sender:self];
        }
    }
}


@end
