//
//  CreateTaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "CreateTaskViewController.h"
#import <Parse/Parse.h>
#import "FinishCreateTaskViewController.h"
#import "DBKeys.h"

#define DELETE_TASK_TAG 0

@interface CreateTaskViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSString *selectedDate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@end

@implementation CreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEditing) {
        self.title = @"Edit Task";
        self.nameTextField.text = [self.task objectForKey:TASK_NAME];
        self.descriptionTextField.text = [self.task objectForKey:TASK_DESC];
        [self.datePicker setDate:[self.task objectForKey:TASK_DUE_DATE]];
        /* X button */
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelEdit)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        /* Trash button */
        UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTask)];
        self.navigationItem.rightBarButtonItem = trashButton;
    } else {
         self.title = @"Create Task";
    }
}

- (void)cancelEdit {
    [self.navigationController popViewControllerAnimated:YES];
}


/* Prompts the user to see if they really want to delete the task */
- (void)deleteTask {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Task" message:@"Are you sure you want to delete this task? Students and parents will no longer see it." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = DELETE_TASK_TAG;
    [alert show];
}

- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    
    self.selectedDate = formatedDate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender {
    if (!self.task) {
        self.task = [PFObject objectWithClassName:TASK_CLASS_NAME];
    }
    [self.task setObject:self.nameTextField.text forKey:TASK_NAME];
    [self.task setObject:self.descriptionTextField.text forKey:TASK_DESC];
    [self.task setObject:self.datePicker.date forKey:TASK_DUE_DATE];
    [self performSegueWithIdentifier:@"finishCreateTask" sender:self];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == DELETE_TASK_TAG) {
        if (buttonIndex == 1) {
            /* They actually are deleting */
            if (self.isEditing) {
                /* Delete all task completion objects associated with this task */
                PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
                [query whereKey:TASK_COMPLETION_TASK equalTo:self.task];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for (PFObject *obj in objects) {
                        [obj deleteInBackground];
                    }
                    /* Delete the task itself */
                    [self.task deleteInBackgroundWithBlock:^(BOOL success, NSError *error) {
                        UIViewController *dest = [self.navigationController.viewControllers objectAtIndex:1];
                        [self.navigationController popToViewController:dest animated:YES];
                    }];
                }];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"finishCreateTask"]) {
        FinishCreateTaskViewController *dest = segue.destinationViewController;
        dest.task = self.task;
        dest.myClass = self.myClass;
        dest.isEditing = self.isEditing;
    }
}


@end
