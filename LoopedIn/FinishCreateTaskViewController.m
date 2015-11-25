//
//  FinishCreateTaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "FinishCreateTaskViewController.h"
#import "TasksTableViewController.h"
#import "DBKeys.h"
#import "LoadingView.h"

#define DELETE_TASK_TAG 0

@interface FinishCreateTaskViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *parentsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *studentsSwitch;
@property (strong, nonatomic) IBOutlet UIPickerView *pointPicker;
@property NSArray *pointOptions;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
@end

@implementation FinishCreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pointOptions = [NSArray arrayWithObjects:@"10", @"20", @"30", @"40", @"50", @"100", @"200", nil];
    // Do any additional setup after loading the view.
    self.pointPicker.delegate = self;
    self.pointPicker.dataSource = self;
    if (self.isEditing) {
        [self.submitButton setTitle:@"Save Edits" forState:UIControlStateNormal];
        self.title = @"Edit Task";
        NSString *points = [self.task objectForKey:TASK_POINTS];
        NSInteger index = -1;
        for (int i=0; i < self.pointOptions.count; i++) {
            NSString *currPoint = [self.pointOptions objectAtIndex:i];
            if ([currPoint isEqualToString:points]) {
                index = i;
                break;
            }
        }
        [self.pointPicker selectRow:index inComponent:0 animated:NO];
        [self.parentsSwitch setEnabled:NO];
        [self.studentsSwitch setEnabled:NO];
        /* Trash button */
        UIBarButtonItem *trashButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteTask)];
        self.navigationItem.rightBarButtonItem = trashButton;
    } else {
        [self.submitButton setTitle:@"Create Task!" forState:UIControlStateNormal];
        self.title = @"Create Task";
    }
}

/* Prompts the user to see if they really want to delete the task */
- (void)deleteTask {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Task" message:@"Are you sure you want to delete this task? Students and parents will no longer see it." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = DELETE_TASK_TAG;
    [alert show];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pointOptions.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber *points = [self.pointOptions objectAtIndex:row];
    return [NSString stringWithFormat:@"%@", points];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Create a single Task object for the task just created, and pop back to the list of all tasks once it's done saving. Create a TaskCompletion object that pairs this task with each asignee (one for each asignee) in the background. */
- (IBAction)createTask:(id)sender {
    NSString *loadingText = @"Creating task...";
    if (self.isEditing) loadingText = @"Updating task...";
    LoadingView *loadingView = [[LoadingView alloc] initWithLoadingText:loadingText hasNavBar:YES];
    [self.view addSubview:loadingView];
    [loadingView startLoading];
    
    NSString *points = [self pickerView:self.pointPicker titleForRow:[self.pointPicker selectedRowInComponent:0] forComponent:0];
    NSString *name = [self.task objectForKey:TASK_NAME];
    NSString *description = [self.task objectForKey:TASK_DESC];
    NSDate *dueDate = [self.task objectForKey:TASK_DUE_DATE];
    
    /* Create the task */
    PFObject *taskToSave;
    if (self.isEditing) {
        taskToSave = self.task;
    } else {
        taskToSave = [PFObject objectWithClassName:TASK_CLASS_NAME];
    }
    [taskToSave setObject:name forKey:TASK_NAME];
    [taskToSave setObject:description forKey:TASK_DESC];
    [taskToSave setObject:dueDate forKey:TASK_DUE_DATE];
    [taskToSave setObject:points forKey:TASK_POINTS];
    [taskToSave setObject:@NO forKey:TASK_IS_COMPLETED];
    [taskToSave setObject:[PFUser currentUser] forKey:TASK_TEACHER];
    [taskToSave saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        /* Once it's done loading, display the done loading popup thing and go back to the list of all tasks */
        [loadingView displayDoneAndPopToViewController:^ {
            TasksTableViewController *tasksVc = [[self.navigationController viewControllers] objectAtIndex:1];
            [self.navigationController popToViewController:tasksVc animated:YES];
        }];
    }];

    if (!self.isEditing) {
        /* Create TaskCreation objects; one for each asignee. Start by getting the list of students. */
        PFRelation *relation = [self.myClass relationForKey:CLASS_STUDENTS];
        PFQuery *query = [relation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray *students, NSError *err) {
            if (students) {
                if ([self.studentsSwitch isOn]) {
                    /* Create TaskCompletion object for each student */
                    for (PFUser *student in students) {
                        /* Task completion object keeps track of whether this task is completed */
                        PFObject *taskCompletion = [PFObject objectWithClassName:TASK_COMPLETION_CLASS_NAME];
                        [taskCompletion setObject:taskToSave forKey:TASK_COMPLETION_TASK];
                        [taskCompletion setObject:@NO forKey:TASK_IS_COMPLETED];
                        [taskCompletion setObject:student forKey:TASK_COMPLETION_ASIGNEE];
                        [taskCompletion saveInBackground];
                    }
                }
                if ([self.parentsSwitch isOn]) {
                    /* Add parent asignees to task's asignees */
                    for (PFUser *student in students) {
                        /* Find the parent of this student */
                        PFQuery *query = [PFQuery queryWithClassName:PARENTHOOD_CLASS_NAME];
                        [query whereKey:CHILD equalTo:student];
                        [query getFirstObjectInBackgroundWithBlock:^(PFObject *parenthood, NSError *error) {
                            PFUser *parent = [parenthood objectForKey:PARENT];
                            
                            /* Task completion object keeps track of whether this task is completed */
                            PFObject *taskCompletion = [PFObject objectWithClassName:TASK_COMPLETION_CLASS_NAME];
                            [taskCompletion setObject:taskToSave forKey:TASK_COMPLETION_TASK];
                            [taskCompletion setObject:@NO forKey:TASK_IS_COMPLETED];
                            [taskCompletion setObject:parent forKey:TASK_COMPLETION_ASIGNEE];
                            [taskCompletion saveInBackground];
                        }];
                    }
                }
            }
        }];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
