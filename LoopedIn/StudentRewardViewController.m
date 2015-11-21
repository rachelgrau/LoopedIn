//
//  StudentRewardViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/17/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentRewardViewController.h"
#import "SingleRewardViewController.h"
#import "DBKeys.h"
#import <Parse/Parse.h>

@interface StudentRewardViewController ()
@property (strong, nonatomic) IBOutlet UILabel *desiredRewardLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *rewards;
@property NSIndexPath *selectedRowIndexPath;
@end

@implementation StudentRewardViewController

/* Removes the desired reward from the list of options of other rewards. */
- (void)removeDesiredRewardFromOtherRewards {
    NSMutableArray *mutableRewards = [NSMutableArray arrayWithArray:self.rewards];
    for (PFObject *reward in mutableRewards) {
        if (reward == self.desiredReward) {
            [mutableRewards removeObject:reward];
            break;
        }
    }
    self.rewards = mutableRewards;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"Rewards";
    
    NSNumber *pointsEarned = [[PFUser currentUser] objectForKey:POINTS];
    /* Load desired reward if it wasn't passed from previous view controller. */
    if (!self.desiredReward) {
        PFObject *reward = [[PFUser currentUser] objectForKey:DESIRED_REWARD];
        if (!reward) {
            self.desiredRewardLabel.text = @"No reward to work towards.";
        } else {
            [reward fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (object) {
                    self.desiredReward = object;
                    [self removeDesiredRewardFromOtherRewards];
                    NSString *rewardTitle = [object objectForKey:REWARD_TITLE];
                    NSNumber *pointsNeeded = [object objectForKey:REWARD_POINTS];
                    NSString *progressDescText = [NSString stringWithFormat:@"%@/%@ points earned towards %@!", pointsEarned, pointsNeeded, rewardTitle];
                    self.desiredRewardLabel.text = progressDescText;
                }
            }];

        }
    }
    
    /* TEMP */
    PFQuery *query = [PFQuery queryWithClassName:REWARD_CLASS_NAME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.rewards = objects;
            [self removeDesiredRewardFromOtherRewards];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    // Do any additional setup after loading the view.
}

/* Called when the desired reward is changed. Updates the label that displays the student's progress towards their desired reward. Also, adds the old desired reward to the list of other options of rewards, and removes the new desired reward from this list of options. */
-(void)desiredRewardChangedTo:(PFObject *)newDesiredReward {
    NSMutableArray *mutableRewards = [NSMutableArray arrayWithArray:self.rewards];
    [mutableRewards addObject:self.desiredReward];
    self.rewards = mutableRewards;
    self.desiredReward = newDesiredReward;
    [self removeDesiredRewardFromOtherRewards];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    if (self.desiredReward) {
        NSNumber *pointsEarned = [[PFUser currentUser] objectForKey:POINTS];
        NSString *progressDescText = [NSString stringWithFormat:@"%@/%@ points earned towards %@!", pointsEarned, [self.desiredReward objectForKey:REWARD_POINTS], [self.desiredReward objectForKey:REWARD_TITLE]];
        self.desiredRewardLabel.text = progressDescText;
    } else {
        self.desiredRewardLabel.text = @"No reward to work towards.";
    }
}

-(void)viewDidAppear:(BOOL)animated {
    if (self.selectedRowIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedRowIndexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate and Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.rewards.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Or work towards a different reward...";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        [self performSegueWithIdentifier:@"showReward" sender:indexPath];
        self.selectedRowIndexPath = indexPath;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"rewardCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    PFObject *reward = [self.rewards objectAtIndex:indexPath.row];
    cell.textLabel.text = [reward objectForKey:REWARD_TITLE];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@/%@ pts >", [[PFUser currentUser] objectForKey:POINTS], [reward objectForKey:REWARD_POINTS]];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showReward"]) {
        SingleRewardViewController *dest = [segue destinationViewController];
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        PFObject *rewardSelected = [self.rewards objectAtIndex:indexPath.row];
        dest.reward = rewardSelected;
    }
}


@end
