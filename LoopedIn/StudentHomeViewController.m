//
//  StudentHomeViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentHomeViewController.h"
#import "StudentRewardViewController.h"
#import <Parse/Parse.h>
#import "DBKeys.h"
#import "Common.h"

@interface StudentHomeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *myTasksButton;
@property (strong, nonatomic) IBOutlet UIButton *myRewardsButton;
@property (strong, nonatomic) IBOutlet UILabel *progressDescription;
@property PFObject *desiredReward; // reward user currently is working towards; must be loaded
@end

@implementation StudentHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Set navigation title */
    [Common setUpNavBar:self];
    
    /* Add settings button */
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsButtonImage = [UIImage imageNamed:@"settings.png"];
    [settingsButton setBackgroundImage:settingsButtonImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *settingsNavButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsNavButton;
    
    /* Set name label */
    NSString *fullName = [[PFUser currentUser] objectForKey:FULL_NAME];
    NSString *firstName = [Common getFirstNameFromFullName:fullName];
    self.title = firstName;
    UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:32.0f];
    UIFont *normalFont = [UIFont fontWithName:@"Avenir-Book" size:32.0f];

    NSDictionary *boldAttr = @{
                            NSFontAttributeName:boldFont
                            };
    NSDictionary *normalAttr = @{
                               NSFontAttributeName:normalFont
                               };
    const NSRange range = NSMakeRange(0, firstName.length);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullName
                                           attributes:normalAttr];
    [attributedText setAttributes:boldAttr range:range];
    [self.nameLabel setAttributedText:attributedText];
    
    /* Set border of tasks and rewards button */
    [Common setBorder:self.myTasksButton withColor:[UIColor blackColor]];
    [Common setBorder:self.myRewardsButton withColor:[UIColor blackColor]];
    
}

- (void) viewWillAppear:(BOOL)animated {
    /* Get points */
    NSNumber *pointsEarned = [[PFUser currentUser] objectForKey:POINTS];
    PFObject *reward = [[PFUser currentUser] objectForKey:DESIRED_REWARD];
    if (!reward) {
        self.progressDescription.text = @"No reward to work towards.";
    } else {
        [reward fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSString *progressDescText = @"No reward to work towards.";
            if (object) {
                self.desiredReward = object;
                NSString *rewardTitle = [object objectForKey:REWARD_TITLE];
                NSNumber *pointsNeeded = [object objectForKey:REWARD_POINTS];
                progressDescText = [NSString stringWithFormat:@"%@/%@ points earned towards %@!", pointsEarned, pointsNeeded, rewardTitle];
            }
            self.progressDescription.text = progressDescText;
        }];
    }
}

- (void)goToSettings:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}

- (IBAction)myTasksPressed:(id)sender {
}

- (IBAction)myRewardsPressed:(id)sender {
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toRewards"]) {
        StudentRewardViewController *dest = segue.destinationViewController;
        if (self.desiredReward) {
            dest.desiredReward = self.desiredReward;
        }
    }
}


@end
