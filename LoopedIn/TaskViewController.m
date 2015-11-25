//
//  TaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/24/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "TaskViewController.h"
#import "DBKeys.h"

#define INCOMPLETE_SECTION 0
#define COMPLETE_SECTION 1

@interface TaskViewController ()
@property (strong, nonatomic) IBOutlet UILabel *taskDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *numPointsLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *students;
@property NSMutableArray *incompleteStudents;
@property NSMutableArray *completedStudents;
@property BOOL hasLoadedStudents;
@end

@implementation TaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hasLoadedStudents = NO;
    self.title = [self.task objectForKey:TASK_NAME];
    self.taskDescriptionLabel.text = [self.task objectForKey:TASK_DESC];
    [self.taskDescriptionLabel sizeToFit];
    self.numPointsLabel.text = [[self.task objectForKey:TASK_POINTS] stringValue];
    self.incompleteStudents = [[NSMutableArray alloc] init];
    self.completedStudents = [[NSMutableArray alloc] init];
    
    /* Edit button */
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTask)];
    
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

    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)editTask {
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
        cell.textLabel.text = @"Loading tasks...";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedStudents) {
//        self.selectedTask = [self.tasks objectAtIndex:indexPath.row];
//        [self performSegueWithIdentifier:@"toSingleTask" sender:self];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
