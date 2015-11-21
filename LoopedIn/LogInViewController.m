//
//  LogInViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "LogInViewController.h"
#import "DBKeys.h"
#import "Common.h"
#import <Parse/Parse.h>

@interface LogInViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Set border of text field to white */
    [Common setBorder:self.usernameTextField withColor:[UIColor whiteColor]];
    if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    /* Set border of text field to white */
    [Common setBorder:self.passwordTextField withColor:[UIColor whiteColor]];
    if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if ([PFUser currentUser]) {
        NSString *role = [[PFUser currentUser] objectForKey:ROLE];
        if ([role isEqualToString:TEACHER_ROLE]) {
            [self performSegueWithIdentifier:@"toTeacherHome" sender:self];
        } else if ([role isEqualToString:STUDENT_ROLE]) {
            [self performSegueWithIdentifier:@"toStudentHome" sender:self];
        } else if ([role isEqualToString:PARENT_ROLE]){
            [self performSegueWithIdentifier:@"toParentHome" sender:self];
        } else {
            [self performSegueWithIdentifier:@"toChooseRole" sender:self];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    /* Clear placeholder text */
    textField.placeholder = nil;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    /* If text field is empty, put the placeholder back */
    NSString *placeholder = @"";
    if ([textField.text isEqualToString:@""]) {
        if (textField == self.usernameTextField) {
           placeholder = @"email";
        } else if (textField == self.passwordTextField) {
            placeholder = @"password";
        }
    }
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        textField.placeholder = placeholder;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logInPressed:(id)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        if (user) {
            NSString *role = [user objectForKey:ROLE];
            NSString *segueIdentifier = @"";
            if ([role isEqualToString:TEACHER_ROLE]) {
                segueIdentifier = @"toTeacherHome";
            } else if ([role isEqualToString:STUDENT_ROLE]) {
                segueIdentifier = @"toStudentHome";
            } else if ([role isEqualToString:PARENT_ROLE]) {
                segueIdentifier = @"toParentHome";
            } else {
                [self performSegueWithIdentifier:@"toChooseRole" sender:self];
            }
            [self performSegueWithIdentifier:segueIdentifier sender:self];
        }
        else {
            [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                        message:@"Incorrect username or password."
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
            
        }
    }];
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
