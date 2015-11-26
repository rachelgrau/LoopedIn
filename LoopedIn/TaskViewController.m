//
//  TaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/24/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "TaskViewController.h"
#import "StudentTeacherViewController.h"
#import "CreateTaskViewController.h"
#import "DBKeys.h"
#import "LoadingView.h"

#define INCOMPLETE_SECTION 0
#define COMPLETE_SECTION 1

#define DELETE_TASK_TAG 0

@interface TaskViewController ()
@property (strong, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *numPointsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *students;
@property NSMutableArray *incompleteStudents;
@property NSMutableArray *completedStudents;
@property BOOL hasLoadedStudents;
@property NSIndexPath *selectedIndexPath;
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasLoadedStudents = NO;
    self.title = [self.task objectForKey:TASK_NAME];
    self.taskDescriptionLabel.text = [self.task objectForKey:TASK_DESC];
    [self.taskDescriptionLabel sizeToFit];
    self.numPointsLabel.text = [self.task objectForKey:TASK_POINTS];
    self.incompleteStudents = [[NSMutableArray alloc] init];
    self.completedStudents = [[NSMutableArray alloc] init];
    
    /* Load students */
    PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
    [query whereKey:TASK_COMPLETION_TASK equalTo:self.task];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        for (PFObject *taskCompletion in results) {
            PFUser *asignee = [taskCompletion objectForKey:TASK_COMPLETION_ASIGNEE];
            [asignee fetchIfNeeded];
            NSNumber *isCompleted = [taskCompletion objectForKey:TASK_IS_COMPLETED];
            if ([isCompleted boolValue]) {
                [self.completedStudents addObject:asignee];
            } else {
                [self.incompleteStudents addObject:asignee];
            }
        }
        self.hasLoadedStudents = YES;
        [self.tableView reloadData];
    }];

    /* Edit button */
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTask)];
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (IBAction)deleteTask:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete Task" message:@"Are you sure you want to delete this task? Students and parents will no longer see it." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alert.tag = DELETE_TASK_TAG;
    [alert show];
}

- (void)editTask {
    [self performSegueWithIdentifier:@"toEditTask" sender:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.hasLoadedStudents) return 1;
    else return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.hasLoadedStudents) {
        return 1;
    } else if (section == INCOMPLETE_SECTION) {
        return self.incompleteStudents.count;
    } else if (section == COMPLETE_SECTION) {
        return self.completedStudents.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.hasLoadedStudents) return @"";
    else if (section == INCOMPLETE_SECTION) {
        return @"Incomplete";
    } else if (section == COMPLETE_SECTION) {
        return @"Completed";
    } else return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    if (self.hasLoadedStudents) {
        PFUser *student;
        if (indexPath.section == INCOMPLETE_SECTION) {
            student = [self.incompleteStudents objectAtIndex:indexPath.row];
        } else if (indexPath.section == COMPLETE_SECTION) {
            student = [self.completedStudents objectAtIndex:indexPath.row];
        }
        cell.textLabel.text = student.username;
    } else {
        cell.textLabel.text = @"Loading task asignees...";
    }
    return cell;
}

/* If you select a student, segue to the student's profile. If you select a parent, do nothing. */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedStudents) {
        self.selectedIndexPath = indexPath;
        PFUser *selectedUser;
        if (self.selectedIndexPath.section == INCOMPLETE_SECTION) {
            selectedUser = [self.incompleteStudents objectAtIndex:indexPath.row];
        } else if (self.selectedIndexPath.section == COMPLETE_SECTION) {
            selectedUser = [self.completedStudents objectAtIndex:indexPath.row];
        }
        if ([[selectedUser objectForKey:ROLE] isEqualToString: PARENT_ROLE]) {
            /* Parents don't have profiles */
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            [self performSegueWithIdentifier:@"toStudentView" sender:self];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == DELETE_TASK_TAG) {
        if (buttonIndex == 1) {
            LoadingView *loadingView = [[LoadingView alloc] initWithLoadingText:@"Deleting..." hasNavBar:YES];
            [self.view addSubview:loadingView];
            [loadingView startLoading];
            /* Delete all task completion objects associated with this task */
            PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
            [query whereKey:TASK_COMPLETION_TASK equalTo:self.task];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *obj in objects) {
                    [obj deleteInBackground];
                }
                /* Delete the task itself */
                [self.task deleteInBackgroundWithBlock:^(BOOL success, NSError *error) {
                    [loadingView displayDoneAndPopToViewController:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }];
            }];
        }
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toStudentView"]) {
        StudentTeacherViewController *dest = segue.destinationViewController;
        if (self.selectedIndexPath.section == INCOMPLETE_SECTION) {
            dest.student = [self.incompleteStudents objectAtIndex:self.selectedIndexPath.row];
        } else if (self.selectedIndexPath.section == COMPLETE_SECTION) {
            dest.student = [self.completedStudents objectAtIndex:self.selectedIndexPath.row];
        }
    } else if ([segue.identifier isEqualToString:@"toEditTask"]) {
        CreateTaskViewController *dest = segue.destinationViewController;
        dest.isEditing = YES;
        dest.task = self.task;
    }
}


@end
