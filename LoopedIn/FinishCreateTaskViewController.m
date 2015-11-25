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

@interface FinishCreateTaskViewController ()
@property (strong, nonatomic) IBOutlet UISwitch *parentsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *studentsSwitch;
@property (strong, nonatomic) IBOutlet UIPickerView *pointPicker;
@property NSArray *pointOptions;
@end

@implementation FinishCreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pointOptions = [NSArray arrayWithObjects:@10, @20, @30, @40, @50, @100, @200, nil];
    // Do any additional setup after loading the view.
    self.pointPicker.delegate = self;
    self.pointPicker.dataSource = self;
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
    /* TO DO: Loading icon / disable buttons while we store this stuff */
    NSString *pointsStr = [self pickerView:self.pointPicker titleForRow:[self.pointPicker selectedRowInComponent:0] forComponent:0];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *points = [f numberFromString:pointsStr];
    NSString *name = [self.task objectForKey:TASK_NAME];
    NSString *description = [self.task objectForKey:TASK_DESC];
    NSDate *dueDate = [self.task objectForKey:TASK_DUE_DATE];
    
    /* Create the task */
    PFObject *currTask = [PFObject objectWithClassName:TASK_CLASS_NAME];
    [currTask setObject:name forKey:TASK_NAME];
    [currTask setObject:description forKey:TASK_DESC];
    [currTask setObject:dueDate forKey:TASK_DUE_DATE];
    [currTask setObject:points forKey:TASK_POINTS];
    [currTask setObject:@NO forKey:TASK_IS_COMPLETED];
    [currTask setObject:[PFUser currentUser] forKey:TASK_TEACHER];
    [currTask saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
        /* Once it's done loading, go back to list of all tasks */
        TasksTableViewController *tasksVc = [[self.navigationController viewControllers] objectAtIndex:1];
        [self.navigationController popToViewController:tasksVc animated:YES];
    }];

    /* Get list of students */
    PFRelation *relation = [self.myClass relationForKey:CLASS_STUDENTS];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *students, NSError *err) {
        if (students) {
            if ([self.studentsSwitch isOn]) {
                /* Create TaskCompletion object for each student */
                for (PFUser *student in students) {
                    /* Task completion object keeps track of whether this task is completed */
                    PFObject *taskCompletion = [PFObject objectWithClassName:TASK_COMPLETION_CLASS_NAME];
                    [taskCompletion setObject:currTask forKey:TASK_COMPLETION_TASK];
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
                        [taskCompletion setObject:currTask forKey:TASK_COMPLETION_TASK];
                        [taskCompletion setObject:@NO forKey:TASK_IS_COMPLETED];
                        [taskCompletion setObject:parent forKey:TASK_COMPLETION_ASIGNEE];
                        [taskCompletion saveInBackground];
                    }];
                }
            }
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
