//
//  RewardsTableViewController.m
//  
//
//  Created by Rachel on 11/25/15.
//
//

#import "RewardsTableViewController.h"
#import "CreateRewardViewController.h"
#import "RewardViewController.h"
#import "DBKeys.h"

@interface RewardsTableViewController ()
@property BOOL hasLoadedRewards;
@property NSArray *rewards;
@property PFObject *selectedReward;
@end

@implementation RewardsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Rewards";
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addReward)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)viewWillAppear:(BOOL)animated {
    self.hasLoadedRewards = NO;
    /* Load tasks that this teacher has assigned */
    PFQuery *rewardQuery = [PFQuery queryWithClassName:REWARD_CLASS_NAME];
    [rewardQuery whereKey:REWARD_CLASS equalTo:self.myClass];
    [rewardQuery findObjectsInBackgroundWithBlock:^(NSArray *rewards, NSError *error) {
        self.rewards = rewards;
        self.hasLoadedRewards = YES;
        [self.tableView reloadData];
    }];
}

- (void)addReward {
    [self performSegueWithIdentifier:@"toCreateReward" sender:self];
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
        cell.detailTextLabel.text = [[reward objectForKey:POINTS] stringValue];
    } else {
        cell.textLabel.text = @"Loading rewards...";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedRewards) {
        self.selectedReward = [self.rewards objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"toReward" sender:self];
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
    if ([segue.identifier isEqualToString:@"toCreateReward"]) {
        CreateRewardViewController *dest = segue.destinationViewController;
        dest.myClass = self.myClass;
    } else if ([segue.identifier isEqualToString:@"toReward"]) {
        RewardViewController *dest = segue.destinationViewController;
        dest.reward = self.selectedReward;
    }
}


@end
