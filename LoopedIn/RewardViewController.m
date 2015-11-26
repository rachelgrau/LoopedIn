//
//  RewardViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/25/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "RewardViewController.h"
#import "DBKeys.h"
#import <Parse/Parse.h>

@interface RewardViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property BOOL hasLoadedStudents;
@property NSMutableArray *earnedStudents;
@property NSMutableArray *wantsStudents;
@end

#define EARNED_REWARD_SECTION 0
#define WANTS_REWARD_SECTION 1

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
    
    PFQuery *query = [PFUser query];
    [query whereKey:DESIRED_REWARD equalTo:self.reward];
    [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
        for (PFObject *user in users) {
            BOOL hasEarned = [[user objectForKey:BOUGHT_REWARD] boolValue];
            if (hasEarned) {
                [self.earnedStudents addObject:user];
            } else {
                [self.wantsStudents addObject:user];
            }
        }
        self.hasLoadedStudents = YES;
        [self.tableView reloadData];
    }];
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
        return @"Earned Reward";
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
            }
        } else if (indexPath.section == WANTS_REWARD_SECTION) {
            user = [self.wantsStudents objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = user.username;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ pts", [[user objectForKey:POINTS] stringValue]];
    } else {
        cell.textLabel.text = @"Loading students...";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
