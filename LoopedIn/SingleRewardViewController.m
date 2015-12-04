//
//  SingleRewardViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/18/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "SingleRewardViewController.h"
#import "StudentRewardViewController.h"
#import "SingleClassTaskViewController.h"
#import "Common.h"
#import "DBKeys.h"

@interface SingleRewardViewController ()
@property (strong, nonatomic) IBOutlet UILabel *pointsLabel;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation SingleRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Common setUpNavBar:self];
    self.title = [self.reward objectForKey:REWARD_TITLE];
    self.descriptionLabel.text = [self.reward objectForKey:REWARD_DESCRIPTION];
    NSNumber *points = [self.reward objectForKey:REWARD_POINTS];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@", points];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        /* Save reward, then set change reward button to be enabled */
        [self.classMember setObject:self.reward forKey:CLASS_MEMBER_DESIRED_REWARD];
        [self.classMember saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            SingleClassTaskViewController *popTo = [self.navigationController.viewControllers objectAtIndex:1];
            [self.navigationController popToViewController:popTo animated:YES];
        }];
    }
}

- (IBAction)clickedChangeReward:(id)sender {
    NSString *message = [NSString stringWithFormat:@"Are you sure you want to change your reward to %@?", [self.reward objectForKey:REWARD_TITLE]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change Reward?"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes", nil];
    [alert show];
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
