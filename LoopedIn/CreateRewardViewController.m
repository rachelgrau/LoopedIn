//
//  CreateRewardViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/25/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "CreateRewardViewController.h"
#import <Parse/Parse.h>
#import "DBKeys.h"
#import "LoadingView.h"

@interface CreateRewardViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *pointsTextField;
@end

@implementation CreateRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createRewardPressed:(id)sender {
    if (self.nameTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title Missing" message:@"Please give your reward a title." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else if (self.descriptionTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Description Missing" message:@"Please give your reward a description." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else if (self.pointsTextField.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Points Missing" message:@"Please enter the number of points needed to win this reward." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    } else {
        /* Check if they entered a number for points */
        NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        if ([self.pointsTextField.text rangeOfCharacterFromSet:notDigits].location != NSNotFound)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid # of Points" message:@"Please enter a number for the points value." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alert show];
        } else {
            LoadingView *loadingView = [[LoadingView alloc] initWithLoadingText:@"Creating reward..." hasNavBar:YES];
            [self.view addSubview:loadingView];
            [loadingView startLoading];
            /* Save reward! */
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
            NSNumber *pointsNum = [f numberFromString:self.pointsTextField.text];
            
            PFObject *reward = [PFObject objectWithClassName:@"Reward"];
            [reward setObject:self.nameTextField.text forKey:REWARD_TITLE];
            [reward setObject:self.descriptionTextField.text forKey:REWARD_DESCRIPTION];
            [reward setObject:pointsNum forKey:REWARD_POINTS];
            [reward setObject:self.myClass forKey:REWARD_CLASS];
            [reward saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                [loadingView displayDoneAndPopToViewController:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }];
        }
    }
    
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
