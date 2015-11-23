//
//  ChooseRoleViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "ChooseRoleViewController.h"
#import "DBKeys.h"
#import "Common.h"
#import <Parse/Parse.h>
#import "TeacherHomeViewController.h"

@interface ChooseRoleViewController ()
@property (strong, nonatomic) IBOutlet UIButton *studentButton;
@property (strong, nonatomic) IBOutlet UIButton *parentButton;
@property (strong, nonatomic) IBOutlet UIButton *teacherButton;
/* If student selected, this will prompt user to type in parent's email; if parent selected, this will prompt user to type in child's email; if teacher is selected, it will prompt user to type in their class name. */
@property (strong, nonatomic) IBOutlet UITextField *parenthoodTextfield;
@property NSString *username;

/* used to store a class that the teacher creates, if user chooses the teacher role */
@property PFObject *myClass;
@end

@implementation ChooseRoleViewController

- (void)hideParenthoodTextfield:(NSString *)prevRole {
    [self.parenthoodTextfield setHidden:YES];
    
    CGRect parenthoodTextFieldFrame = self.parenthoodTextfield.frame;
    
    /* Move parent text field and teacher text field up */
    CGRect parentTextFieldFrame = self.parentButton.frame;
    CGRect teacherTextFieldFrame = self.teacherButton.frame;
    
    CGFloat dy = parenthoodTextFieldFrame.size.height + 5;
    parentTextFieldFrame.origin.y -= dy;
    teacherTextFieldFrame.origin.y -= dy;
    
    if ([prevRole isEqualToString:STUDENT_ROLE]) {
        self.parentButton.frame = parentTextFieldFrame;
        self.teacherButton.frame = teacherTextFieldFrame;
    } if ([prevRole isEqualToString:PARENT_ROLE]) {
        self.teacherButton.frame = teacherTextFieldFrame;
    }
}

/* This method displays the parenthood text field (which asks a parent to type in their child's email, or a child to type in their parent's email) and adjusts other views accordingly. It also updates the placeholder text of the parenthood text field depending on |isStudent|  */
- (void)showParenthoodTextfield:(NSString *)role {
    [self.parenthoodTextfield setHidden:NO];
    
    if ([self.parenthoodTextfield respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        NSString *placeholder = @"";
        if ([role isEqualToString:STUDENT_ROLE]) {
            placeholder = @"your parent's email";
        } else if ([role isEqualToString:PARENT_ROLE]) {
            placeholder = @"your child's email";
        } else if ([role isEqualToString:TEACHER_ROLE]) {
            placeholder = @"your class name (e.g. Algebra 1)";
        }
        self.parenthoodTextfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
    }
    
    /* Move parenthood text field below student or parent text field */
    CGRect parenthoodTextFieldFrame = self.parenthoodTextfield.frame;
    if ([role isEqualToString:STUDENT_ROLE]) {
        CGRect studentTextFieldFrame = self.studentButton.frame;
        parenthoodTextFieldFrame.origin.y = studentTextFieldFrame.origin.y + studentTextFieldFrame.size.height + 5;
    } else if ([role isEqualToString:PARENT_ROLE]) {
        CGRect parentTextFieldFrame = self.parentButton.frame;
        parenthoodTextFieldFrame.origin.y = parentTextFieldFrame.origin.y + parentTextFieldFrame.size.height + 5;
    } else if ([role isEqualToString:TEACHER_ROLE]) {
        CGRect teacherTextFieldFrame = self.teacherButton.frame;
        parenthoodTextFieldFrame.origin.y = teacherTextFieldFrame.origin.y + parenthoodTextFieldFrame.size.height + 5;
    }
    self.parenthoodTextfield.frame = parenthoodTextFieldFrame;
    
    /* Move parent text field and teacher text field down */
    CGRect parentTextFieldFrame = self.parentButton.frame;
    CGRect teacherTextFieldFrame = self.teacherButton.frame;
    
    CGFloat dy = parenthoodTextFieldFrame.size.height + 5;
    parentTextFieldFrame.origin.y += dy;
    teacherTextFieldFrame.origin.y += dy;

    if ([role isEqualToString:STUDENT_ROLE]) {
        self.parentButton.frame = parentTextFieldFrame;
        self.teacherButton.frame = teacherTextFieldFrame;
    } else if ([role isEqualToString:PARENT_ROLE]) {
        self.teacherButton.frame = teacherTextFieldFrame;
    }
}

- (IBAction)studentButtonPressed:(id)sender {
    if (self.studentButton.isSelected) {
        /* Deselecting student button */
        self.studentButton.backgroundColor = [UIColor clearColor];
        [self.studentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.studentButton setSelected:NO];
        [self hideParenthoodTextfield:STUDENT_ROLE];
        [self.teacherButton setHidden:NO];
        [self.parentButton setHidden:NO];
    } else {
        /* Selecting student button */
        self.studentButton.backgroundColor = [UIColor whiteColor];
        [self.studentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.studentButton setSelected:YES];
        /* Deselect and hide other selected buttons */
        if (self.parentButton.isSelected) {
            [self parentButtonPressed:self];
        }
        if (self.teacherButton.isSelected) {
            [self teacherButtonPressed:self];
        }
        [self.teacherButton setHidden:YES];
        [self.parentButton setHidden:YES];
        [self showParenthoodTextfield:STUDENT_ROLE];
    }
}

- (IBAction)parentButtonPressed:(id)sender {
    if (self.parentButton.isSelected) {
        /* Deselecting parent button */
        self.parentButton.backgroundColor = [UIColor clearColor];
        [self.parentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.parentButton setSelected:NO];
        [self hideParenthoodTextfield:PARENT_ROLE];
        [self.studentButton setHidden:NO];
        [self.teacherButton setHidden:NO];
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
        [self showParenthoodTextfield:PARENT_ROLE];
        [self.studentButton setHidden:YES];
        [self.teacherButton setHidden:YES];
    }
}

- (IBAction)teacherButtonPressed:(id)sender {
    if (self.teacherButton.isSelected) {
        self.teacherButton.backgroundColor = [UIColor clearColor];
        [self.teacherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.teacherButton setSelected:NO];
        [self hideParenthoodTextfield:TEACHER_ROLE];
        [self.studentButton setHidden:NO];
        [self.parentButton setHidden:NO];
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
        [self showParenthoodTextfield:TEACHER_ROLE];
        [self.studentButton setHidden:YES];
        [self.parentButton setHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES];
    
    /* Tap gesture recognizer for when we bring up keyboard; want a tap on view to dismiss the keyboard */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    /* Set borders of buttons to white */
    [Common setBorder:self.studentButton withColor:[UIColor whiteColor]];
    [Common setBorder:self.teacherButton withColor:[UIColor whiteColor]];
    [Common setBorder:self.parentButton withColor:[UIColor whiteColor]];
    [Common setBorder:self.parenthoodTextfield withColor:[UIColor whiteColor]];
    
    if ([PFUser currentUser]) {
        self.username = [PFUser currentUser].username;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.parenthoodTextfield resignFirstResponder];
}

/* Creates a class object in the DB for this teacher with the name he/she typed in. */
- (void)createClass {
    PFObject *class = [PFObject objectWithClassName:CLASS_CLASS_NAME];
    NSString *classCode = [Common randomStringWithLength:5];
    NSLog(@"%@", classCode);
    [class setObject:self.parenthoodTextfield.text forKey:CLASS_NAME];
    [class setObject:[PFUser currentUser] forKey:CLASS_TEACHER];
    [class setObject:classCode forKey:CLASS_CODE];
    [class saveInBackground];
    self.myClass = class;
}

/* Creates an object in the Parenthood DB table connecting this child/parent with his/her child/parent */
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

- (IBAction)getStartedPressed:(id)sender {
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
    
    if (self.parenthoodTextfield.text.length == 0) {
        NSString *title = @"";
        if ([role isEqualToString:STUDENT_ROLE]) {
            title = @"Please enter your parent's email.";
        } else if ([role isEqualToString:PARENT_ROLE]) {
            title = @"Please enter your child's email.";
        } else if ([role isEqualToString:TEACHER_ROLE]) {
            title = @"Please enter your class name.";
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    PFUser *currentUser = [PFUser currentUser];
    currentUser[ROLE] = role;
    if ([role isEqualToString:STUDENT_ROLE] || [role isEqualToString:PARENT_ROLE]) {
        [self createParenthoodRelation:currentUser];
    } else {
        [self createClass];
    }
    if ([role isEqualToString:STUDENT_ROLE]) {
        [self performSegueWithIdentifier:@"toStudentHome" sender:self];
    } else if ([role isEqualToString:TEACHER_ROLE]) {
        NSString *title = [NSString stringWithFormat:@"Your class code: %@", [self.myClass objectForKey:CLASS_CODE]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        alert.tag = 0;
    } else {
        [self performSegueWithIdentifier:@"toParentHome" sender:self];
    }
}

#pragma mark - UIAlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 0) {
        [self performSegueWithIdentifier:@"toTeacherHome" sender:self];
    }
}

#pragma mark - UITextField

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    /* Clear placeholder text */
    textField.placeholder = nil;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    /* If text field is empty, put the placeholder back */
    NSString *placeholder = @"";
    
    if (textField == self.parenthoodTextfield) {
        if (textField.text.length == 0) {
            if (self.studentButton.isSelected) {
                placeholder = @"your parent's email";
            } else if (self.parentButton.isSelected) {
                placeholder = @"your child's email";
            } else if (self.teacherButton.isSelected) {
                placeholder = @"your class name (e.g. Algebra 1)";
            }
        }
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}];
        } else {
            textField.placeholder = placeholder;
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTeacherHome"]) {
        UINavigationController *nav = segue.destinationViewController;
        TeacherHomeViewController *dest = [nav.viewControllers objectAtIndex:0];
        dest.myClass = self.myClass;
    }
}


@end
