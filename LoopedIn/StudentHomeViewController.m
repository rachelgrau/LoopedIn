//
//  StudentHomeViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentHomeViewController.h"
#import <Parse/Parse.h>
#import "DBKeys.h"
#import "Common.h"

@interface StudentHomeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *myTasksButton;
@property (strong, nonatomic) IBOutlet UIButton *myRewardsButton;
@property (strong, nonatomic) IBOutlet UILabel *progressDescription;
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
    
    /* Get points */
    NSNumber *pointsEarned = [[PFUser currentUser] objectForKey:POINTS];
    NSNumber *pointsNeeded = @150;
    NSString *rewardName = @"Ice Cream Party";
    NSString *progressDescText = [NSString stringWithFormat:@"%@/%@ points earned towards %@!", pointsEarned, pointsNeeded, rewardName];
    self.progressDescription.text = progressDescText;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
