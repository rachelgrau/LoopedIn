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
@property (strong, nonatomic) IBOutlet UITextField *parenthoodTextfield;
@property (strong, nonatomic) IBOutlet UIButton *backButtonLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backButtonArrow;

@property NSString *username;
@end

@implementation ChooseRoleViewController

- (void)setBorderOfView:(UIView *)view toColor:(UIColor *)color {
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [[UIColor whiteColor]CGColor];
    view.layer.borderWidth = 1.0f;
}

- (void)hideParenthoodTextfield:(BOOL)wasStudent {
    [self.parenthoodTextfield setHidden:YES];
    
    /* Move parenthood text field below student or parent text field */
    CGRect parenthoodTextFieldFrame = self.parenthoodTextfield.frame;
    
    /* Move parent text field, teacher text field, and back button down */
    CGRect parentTextFieldFrame = self.parentButton.frame;
    CGRect teacherTextFieldFrame = self.teacherButton.frame;
    CGRect backButtonLabelFrame = self.backButtonLabel.frame;
    CGRect backButtonArrowFrame = self.backButtonArrow.frame;
    
    CGFloat dy = parenthoodTextFieldFrame.size.height + 5;
    parentTextFieldFrame.origin.y -= dy;
    teacherTextFieldFrame.origin.y -= dy;
    backButtonLabelFrame.origin.y -= dy;
    backButtonArrowFrame.origin.y -= dy;
    
    if (wasStudent) {
        self.parentButton.frame = parentTextFieldFrame;
    }
    self.teacherButton.frame = teacherTextFieldFrame;
    self.backButtonLabel.frame = backButtonLabelFrame;
    self.backButtonArrow.frame = backButtonArrowFrame;
}

/* This method displays the parenthood text field (which asks a parent to type in their child's email, or a child to type in their parent's email) and adjusts other views accordingly. It also updates the placeholder text of the parenthood text field depending on |isStudent|  */
- (void)showParenthoodTextfield:(BOOL)isStudent {
    [self.parenthoodTextfield setHidden:NO];
    
    if (isStudent) {
        self.parenthoodTextfield.placeholder = @"your parent's email";
    } else {
        self.parenthoodTextfield.placeholder = @"your child's email";
    }
    
    /* Move parenthood text field below student or parent text field */
    CGRect parenthoodTextFieldFrame = self.parenthoodTextfield.frame;
    if (isStudent) {
        CGRect studentTextFieldFrame = self.studentButton.frame;
        parenthoodTextFieldFrame.origin.y = studentTextFieldFrame.origin.y + studentTextFieldFrame.size.height + 5;
    } else {
        CGRect parentTextFieldFrame = self.parentButton.frame;
        parenthoodTextFieldFrame.origin.y = parentTextFieldFrame.origin.y + parentTextFieldFrame.size.height + 5;
    }
    self.parenthoodTextfield.frame = parenthoodTextFieldFrame;
    
    /* Move parent text field, teacher text field, and back button down */
    CGRect parentTextFieldFrame = self.parentButton.frame;
    CGRect teacherTextFieldFrame = self.teacherButton.frame;
    CGRect backButtonLabelFrame = self.backButtonLabel.frame;
    CGRect backButtonArrowFrame = self.backButtonArrow.frame;
    
    CGFloat dy = parenthoodTextFieldFrame.size.height + 5;
    parentTextFieldFrame.origin.y += dy;
    teacherTextFieldFrame.origin.y += dy;
    backButtonLabelFrame.origin.y += dy;
    backButtonArrowFrame.origin.y += dy;

    if (isStudent) {
        self.parentButton.frame = parentTextFieldFrame;
    }
    self.teacherButton.frame = teacherTextFieldFrame;
    self.backButtonLabel.frame = backButtonLabelFrame;
    self.backButtonArrow.frame = backButtonArrowFrame;
}

- (IBAction)studentButtonPressed:(id)sender {
    if (self.studentButton.isSelected) {
        /* Deselecting student button */
        self.studentButton.backgroundColor = [UIColor clearColor];
        [self.studentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.studentButton setSelected:NO];
        [self hideParenthoodTextfield:YES];
    } else {
        /* Selecting student button */
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
        [self showParenthoodTextfield:YES];
    }
}

- (IBAction)parentButtonPressed:(id)sender {
    if (self.parentButton.isSelected) {
        /* Deselecting parent button */
        self.parentButton.backgroundColor = [UIColor clearColor];
        [self.parentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.parentButton setSelected:NO];
        [self hideParenthoodTextfield:NO];
    } else {
        /* Selecting parent button */
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
        [self showParenthoodTextfield:NO];
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
    
    if ([PFUser currentUser]) {
        self.username = [PFUser currentUser].username;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createParenthoodRelation:(PFUser *)user {
    if (self.studentButton.isSelected) {
        NSString *parentEmail = self.parenthoodTextfield.text;
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:parentEmail];
        PFObject *parent = [query getFirstObject];
        if (parent) {
            NSString *studentEmail = [parent objectForKey:PARENTHOOD_EMAIL];
            if ([studentEmail isEqualToString:self.username]) {
                PFObject *parenthoodRelation = [PFObject objectWithClassName:PARENTHOOD_CLASS_NAME];
                [parenthoodRelation setObject:user forKey:CHILD];
                [parenthoodRelation setObject:parent forKey:PARENT];
                [parenthoodRelation saveInBackground];
            }
        }
        user[PARENTHOOD_EMAIL] = parentEmail;
        [user saveInBackground];
    } else if (self.parentButton.isSelected) {
        NSString *studentEmail = self.parenthoodTextfield.text;
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:studentEmail];
        PFObject *student = [query getFirstObject];
        if (student) {
            NSString *parentEmail = [student objectForKey:PARENTHOOD_EMAIL];
            if ([parentEmail isEqualToString:self.username]) {
                PFObject *parenthoodRelation = [PFObject objectWithClassName:PARENTHOOD_CLASS_NAME];
                [parenthoodRelation setObject:user forKey:PARENT];
                [parenthoodRelation setObject:student forKey:CHILD];
                [parenthoodRelation saveInBackground];
            }
        }
        user[PARENTHOOD_EMAIL] = studentEmail;
        [user saveInBackground];
    }
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
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[ROLE] = role;
    if ([role isEqualToString:STUDENT_ROLE] || [role isEqualToString:PARENT_ROLE]) {
        [self createParenthoodRelation:currentUser];
    }
    
    if ([role isEqualToString:STUDENT_ROLE]) {
        [self performSegueWithIdentifier:@"toStudentHome" sender:self];
    } else if ([role isEqualToString:TEACHER_ROLE]) {
        [self performSegueWithIdentifier:@"toTeacherHome" sender:self];
    } else {
        [self performSegueWithIdentifier:@"toParentHome" sender:self];
    }
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
