//
//  AllRewardsTableViewController.m
//  LoopedIn
//
//  Created by Rachel on 12/4/15.
//  Copyright © 2015 Rachel. All rights reserved.
//

#import "AllRewardsTableViewController.h"
#import "SingleRewardViewController.h"
#import "DBKeys.h"

@interface AllRewardsTableViewController ()
@property NSMutableArray *rewards;
@property NSIndexPath *selectedRowIndexPath;
@property BOOL hasLoadedRewards;
@property NSIndexPath *selectedIndexPath;
@end

@implementation AllRewardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Rewards";
    self.hasLoadedRewards = NO;
    self.rewards = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.rewards removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:REWARD_CLASS_NAME];
    [query whereKey:REWARD_CLASS equalTo:self.theClass];
    [query findObjectsInBackgroundWithBlock:^(NSArray *rewards, NSError *error) {
        for (PFObject *reward in rewards) {
            if (reward != self.desiredReward) {
                [self.rewards addObject:reward];
            }
        }
        self.hasLoadedRewards = YES;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasLoadedRewards) {
        return self.rewards.count;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rewardCell" forIndexPath:indexPath];
    if (self.hasLoadedRewards) {
        PFObject *reward = [self.rewards objectAtIndex:indexPath.row];
        cell.textLabel.text = [reward objectForKey:REWARD_TITLE];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@ pts >", self.studentsCurrentPoints, [reward objectForKey:REWARD_POINTS]];
    } else {
        cell.textLabel.text = @"Loading...";
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.hasLoadedRewards) {
        self.selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:@"toSingleReward" sender:self];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toSingleReward"]) {
        SingleRewardViewController *dest = segue.destinationViewController;
        dest.reward = [self.rewards objectAtIndex:self.selectedIndexPath.row];
        dest.classMember = self.classMember;
    }
}


@end
