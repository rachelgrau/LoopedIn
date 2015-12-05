//
//  RewardViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/25/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "RewardViewController.h"
#import "DBKeys.h"
#import "StudentTeacherViewController.h"
#import "LoadingView.h"
#import <Parse/Parse.h>

@interface RewardViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property BOOL hasLoadedStudents;
@property NSArray *earnedStudents;
@property NSMutableArray *wantsStudents;
@property NSIndexPath *selectedIndexPath;
@property BOOL earnedLoaded;
@property BOOL wantsLoaded;
@end

#define EARNED_REWARD_SECTION 0
#define WANTS_REWARD_SECTION 1

#define DELETE_TASK_TAG 6

@implementation RewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSNumber *pointsRequired = [self.reward objectForKey:REWARD_POINTS];
    self.hasLoadedStudents = NO;
    self.pointsLabel.text = [pointsRequired stringValue];
    self.descriptionLabel.text = [self.reward objectForKey:REWARD_DESCRIPTION];
    self.title = [self.reward objectForKey:REWARD_TITLE];
    self.earnedStudents = [[NSMutableArray alloc] init];
    self.wantsStudents = [[NSMutableArray alloc] init];
    
    self.earnedLoaded = NO;
    self.wantsLoaded = NO;
    
    PFRelation *earnedStudents = [self.reward relationForKey:REWARD_USERS_WHO_EANRED];
    PFQuery *relationQuery = [earnedStudents query];
    [relationQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        self.earnedStudents = results;
        self.earnedLoaded = YES;
        if (self.wantsLoaded) {
            self.hasLoadedStudents = YES;
            self.hasLoadedStudents = YES;
            [self.tableView reloadData];
        }
    }];
    
    PFQuery *query = [PFQuery queryWithClassName:CLASS_MEMBER_CLASS_NAME];
    [query whereKey:CLASS_MEMBER_CLASS equalTo:self.myClass];
    [query whereKey:CLASS_MEMBER_DESIRED_REWARD equalTo:self.reward];
    [query findObjectsInBackgroundWithBlock:^(NSArray *classMembers, NSError *error) {
        for (PFObject *classMember in classMembers) {
            PFUser *user = [classMember objectForKey:CLASS_MEMBER_STUDENT];
            [user fetchInBackgroundWithBlock:^(PFObject *fetched, NSError *error) {
                PFUser *fetchedUser = (PFUser *)fetched;
                [fetchedUser setObject:[classMember objectForKey:CLASS_MEMBER_POINTS_EARNED] forKey:POINTS];
                [self.wantsStudents addObject:fetchedUser];
                
                if (self.wantsStudents.count == classMembers.count) {
                    self.wantsLoaded = YES;
                    if (self.earnedLoaded) {
                        self.hasLoadedStudents = YES;
                        self.hasLoadedStudents = YES;
                        [self.tableView reloadData];
                    }
                }
            }];
        }
        if (classMembers.count == 0) {
            self.wantsLoaded = YES;
            if (self.earnedLoaded) {
                self.hasLoadedStudents = YES;
                self.hasLoadedStudents = YES;
                [self.tableView reloadData];
            }
        }
    }];
    
    /* Delete button */
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteReward)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)deleteReward {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Reward" message:@"Are you sure you want to delete this reward? Students and parents will no longer see it." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = DELETE_TASK_TAG;
    [alert show];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hasLoadedStudents) {
        return 2;
    } else {
        return 1;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.hasLoadedStudents) return @"";
    else if (section == EARNED_REWARD_SECTION) {
        return @"Claimed Reward";
    } else if (section == WANTS_REWARD_SECTION) {
        return @"Wants Reward";
    } else return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.hasLoadedStudents) return 1;
    else if (section == EARNED_REWARD_SECTION) {
        if (self.earnedStudents.count == 0) return 1;
        else return self.earnedStudents.count;
    } else if (section == WANTS_REWARD_SECTION) {
        return self.wantsStudents.count;
    } else return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    if (self.hasLoadedStudents) {
        PFUser *user;
        if (indexPath.section == EARNED_REWARD_SECTION) {
            if (self.earnedStudents.count == 0) {
                cell.textLabel.text = @"None.";
                cell.detailTextLabel.text = @"";
                return cell;
            } else {
                user = [self.earnedStudents objectAtIndex:indexPath.row];
                cell.detailTextLabel.text = @"";
            }
        } else if (indexPath.section == WANTS_REWARD_SECTION) {
            user = [self.wantsStudents objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ pts", [[user objectForKey:POINTS] stringValue]];
        }
        cell.textLabel.text = [user objectForKey:FULL_NAME];
    } else {
        cell.textLabel.text = @"Loading students...";
    }
    return cell;
}

/* If you select a student, segue to the student's profile. If you select a parent, do nothing. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedStudents) {
        self.selectedIndexPath = indexPath;
        PFUser *selectedUser;
        if (self.selectedIndexPath.section == WANTS_REWARD_SECTION) {
            selectedUser = [self.wantsStudents objectAtIndex:indexPath.row];
        } else if (self.selectedIndexPath.section == EARNED_REWARD_SECTION) {
            if (self.earnedStudents.count > 0) {
                selectedUser = [self.earnedStudents objectAtIndex:indexPath.row];
            } else {
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
        }
        if ([[selectedUser objectForKey:ROLE] isEqualToString: PARENT_ROLE]) {
            /* Parents don't have profiles */
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            [self performSegueWithIdentifier:@"toStudentView" sender:self];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toStudentView"]) {
        StudentTeacherViewController *dest = segue.destinationViewController;
        if (self.selectedIndexPath.section == WANTS_REWARD_SECTION) {
            dest.student = [self.wantsStudents objectAtIndex:self.selectedIndexPath.row];
        } else if (self.selectedIndexPath.section == EARNED_REWARD_SECTION) {
            dest.student = [self.earnedStudents objectAtIndex:self.selectedIndexPath.row];
        }
    }
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == DELETE_TASK_TAG) {
        if (buttonIndex == 1) {
            LoadingView *loadingView = [[LoadingView alloc] initWithLoadingText:@"Deleting..." hasNavBar:YES];
            [self.view addSubview:loadingView];
            [loadingView startLoading];
            /* Delete all task completion objects associated with this task */
            /* Make sure any users who are working towards this reward are no longer doing so */
            PFQuery *userQuery = [PFUser query];
            [userQuery whereKey:DESIRED_REWARD equalTo:self.reward];
            [userQuery findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
                if (!error) {
                    for (PFUser *user in users) {
                        [user setObject:[NSNull null] forKey:DESIRED_REWARD];
                        [user saveInBackground];
                    }
                }
            }];
            /* Delete reward */
            [self.reward deleteInBackgroundWithBlock:^(BOOL success, NSError *error) {
                [loadingView displayDoneAndPopToViewController:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
        }
    }
}

@end
