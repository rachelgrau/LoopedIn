//
//  ChooseRoleViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "ChooseRoleViewController.h"
#import "DBKeys.h"
#import <Parse/Parse.h>

@interface ChooseRoleViewController ()
@property (strong, nonatomic) IBOutlet UIButton *studentButton;
@property (strong, nonatomic) IBOutlet UIButton *parentButton;
@property (strong, nonatomic) IBOutlet UIButton *teacherButton;
@end

@implementation ChooseRoleViewController

@synthesize username;
@synthesize password;

- (void)setBorderOfView:(UIView *)view toColor:(UIColor *)color {
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [[UIColor whiteColor]CGColor];
    view.layer.borderWidth = 1.0f;
}

- (IBAction)studentButtonPressed:(id)sender {
    if (self.studentButton.isSelected) {
        self.studentButton.backgroundColor = [UIColor clearColor];
        [self.studentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.studentButton setSelected:NO];

    } else {
        self.studentButton.backgroundColor = [UIColor whiteColor];
        [self.studentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.studentButton setSelected:YES];
        /* Deselect other selected buttons */
        if (self.parentButton.isSelected) {
            [self parentButtonPressed:self];
        }
        if (self.teacherButton.isSelected) {
            [self teacherButtonPressed:self];
        }
    }
}

- (IBAction)parentButtonPressed:(id)sender {
    if (self.parentButton.isSelected) {
        self.parentButton.backgroundColor = [UIColor clearColor];
        [self.parentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.parentButton setSelected:NO];
        
    } else {
        self.parentButton.backgroundColor = [UIColor whiteColor];
        [self.parentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.parentButton setSelected:YES];
        /* Deselect other selected buttons */
        if (self.studentButton.isSelected) {
            [self studentButtonPressed:self];
        }
        if (self.teacherButton.isSelected) {
            [self teacherButtonPressed:self];
        }
    }
}

- (IBAction)teacherButtonPressed:(id)sender {
    if (self.teacherButton.isSelected) {
        self.teacherButton.backgroundColor = [UIColor clearColor];
        [self.teacherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.teacherButton setSelected:NO];
        
    } else {
        self.teacherButton.backgroundColor = [UIColor whiteColor];
        [self.teacherButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.teacherButton setSelected:YES];
        /* Deselect other selected buttons */
        if (self.studentButton.isSelected) {
            [self studentButtonPressed:self];
        }
        if (self.parentButton.isSelected) {
            [self parentButtonPressed:self];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    
    /* Set borders of buttons to white */
    [self setBorderOfView:self.studentButton toColor:[UIColor whiteColor]];
    [self setBorderOfView:self.teacherButton toColor:[UIColor whiteColor]];
    [self setBorderOfView:self.parentButton toColor:[UIColor whiteColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpPressed:(id)sender {
    NSString *role = @"";
    if (self.studentButton.isSelected) {
        role = STUDENT_ROLE;
    } else if (self.teacherButton.isSelected) {
        role = TEACHER_ROLE;
    } else if (self.parentButton.isSelected) {
        role = PARENT_ROLE;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please select a role." message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    PFUser *user = [PFUser user];
    user.username = self.username;
    user.password = self.password;
    user[ROLE] = role;
    user[FULL_NAME] = self.fullName;
    user[POINTS] = @0;

    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            if ([role isEqualToString:STUDENT_ROLE]) {
                [self performSegueWithIdentifier:@"toStudentHome" sender:self];
            } else if ([role isEqualToString:TEACHER_ROLE]) {
                [self performSegueWithIdentifier:@"toTeacherHome" sender:self];
            } else {
                [self performSegueWithIdentifier:@"toParentHome" sender:self];
            }
        } else {
            NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
            NSLog(@"%@", errorString);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];

}

- (IBAction)backButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
