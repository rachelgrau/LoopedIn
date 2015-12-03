//
//  ParentHomeViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "ParentHomeViewController.h"
#import "StudentTasksViewController.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "DBKeys.h"

@interface ParentHomeViewController ()
@end

@implementation ParentHomeViewController

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

    
    NSString *myChildName = [[PFUser currentUser] objectForKey:PARENTHOOD_EMAIL];
    PFQuery *childQuery = [PFUser query];
    [childQuery whereKey:USERNAME equalTo:myChildName];
    PFUser *child = (PFUser *)[childQuery getFirstObject];
    NSString *firstName = [Common getFirstNameFromFullName:[child objectForKey:FULL_NAME]];
    NSString *lastName = [Common getLastNameFromFullName:[child objectForKey:FULL_NAME]];
}

- (IBAction)logoutPressed:(id)sender {
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    [self performSegueWithIdentifier:@"toLogIn" sender:self];

}

- (void)goToSettings:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
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
    if ([segue.identifier isEqualToString:@"toTasks"]) {
        StudentTasksViewController *dest = segue.destinationViewController;
        dest.classToShow = nil;
        dest.student = [PFUser currentUser];
    }
}


@end
