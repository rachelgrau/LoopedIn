//
//  ViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "SignUpViewController.h"
#import "TeacherHomeViewController.h"
#import "ChooseRoleViewController.h"
#import <Parse/Parse.h>
#import "DBKeys.h"

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;
@property (strong, nonatomic) IBOutlet UIView *containerView; // holds all the text fields
@property NSString *username;
@property NSString *password;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    
    /* Tap gesture recognizer for when we bring up keyboard; want a tap on view to dismiss the keyboard */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    /* Set border of text field to white */
    self.usernameTextField.layer.masksToBounds = YES;
    self.usernameTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.usernameTextField.layer.borderWidth = 1.0f;
    if ([self.usernameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
    }

    /* Set border of text field to white */
    self.nameTextField.layer.masksToBounds = YES;
    self.nameTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.nameTextField.layer.borderWidth = 1.0f;
    if ([self.nameTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"full name" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    /* Set border of text field to white */
    self.passwordTextField.layer.masksToBounds = YES;
    self.passwordTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.passwordTextField.layer.borderWidth = 1.0f;
    if ([self.passwordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    /* Set border of text field to white */
    self.confirmPasswordTextField.layer.masksToBounds = YES;
    self.confirmPasswordTextField.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.confirmPasswordTextField.layer.borderWidth = 1.0f;
    if ([self.confirmPasswordTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        self.confirmPasswordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"confirm password" attributes:@{NSForegroundColorAttributeName: color}];
    }
}

- (void)viewDidAppear:(BOOL)animated {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.usernameTextField resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}


/* Returns YES if password matches the confirmation password and NO otherwise. */
- (BOOL) passwordIsValid {
    NSString *confirmedPassword = self.confirmPasswordTextField.text;
    if ([self.passwordTextField.text isEqualToString:confirmedPassword]) {
        return YES;
    } else {
        return NO;
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
        } else if (textField == self.nameTextField) {
            placeholder = @"full name";
        } else if (textField == self.confirmPasswordTextField) {
            placeholder = @"confirm password";
        }
    }
    if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        textField.placeholder = placeholder;
    }
}

/* Creates a user with the given credentials & segues to choose role, or displays an error message. */
- (IBAction)signUpButtonPressed:(id)sender {
    if (![PFUser currentUser]) {
        /* CREATE NEW USER */
        if (self.nameTextField.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please enter your name." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        } else if (self.passwordTextField.text.length < 4) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password must be of length 4 or greater." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        } else if (![self passwordIsValid]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password doesn't match." message:@"" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            PFUser *user = [PFUser user];
            user.username = self.usernameTextField.text;
            user.password = self.passwordTextField.text;
            user[FULL_NAME] = self.nameTextField.text;
            user[POINTS] = @0;
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {   // Hooray! Let them use the app now.
                    [self performSegueWithIdentifier:@"toChooseRole" sender:self];
                } else {
                    NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
                    NSLog(@"%@", errorString);
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:errorString message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [alert show];
                }
            }];
        }
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toLogIn"]) {
        if ([PFUser currentUser]) {
            [PFUser logOut];
        }
    }
}

@end
