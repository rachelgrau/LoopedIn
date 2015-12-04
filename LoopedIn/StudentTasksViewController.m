//
//  StudentTasksViewController.m
//  LoopedIn
//
//  Created by Rachel on 12/1/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentTasksViewController.h"
#import "StudentTaskViewController.h"
#import "DBKeys.h"
#import "Common.h"
#import "CompletedTasksTableViewController.h"
#import <Parse/Parse.h>

@interface StudentTasksViewController ()
@property NSMutableArray *overdueTasks; // tasks that are uncompleted and overdue
@property NSMutableArray *uncompletedTasks; // tasks that are uncompleted but not overdue
@property NSMutableArray *completedTasks; // tasks that are completed
@property NSMutableArray *other; // used for keeping track of # of tasks
@property BOOL hasLoadedTasks;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) IBOutlet UIButton *completedTasksButton;
@end

#define OVERDUE_SECTION 0
#define UNCOMPLETED_SECTION 1

@implementation StudentTasksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.classToShow) {
        self.title = [self.classToShow objectForKey:CLASS_NAME];
    } else {
        self.title = @"My Tasks";
    }
    
    self.hasLoadedTasks = NO;
    
    [self.completedTasksButton setEnabled:NO];
    
    self.overdueTasks = [[NSMutableArray alloc] init];
    self.uncompletedTasks = [[NSMutableArray alloc] init];
    self.completedTasks = [[NSMutableArray alloc] init];
    self.other = [[NSMutableArray alloc] init];
}

/* Sorts the task arrays by due date */
- (void)sortTaskArrays {
    NSArray *sortedOverdue = [[NSArray alloc] init];
    sortedOverdue = [self.overdueTasks sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(PFObject *)a objectForKey:TASK_DUE_DATE];
        NSDate *second = [(PFObject *)b objectForKey:TASK_DUE_DATE];
        return [first compare:second];
    }];
    self.overdueTasks = [sortedOverdue mutableCopy];
    
    NSArray *sortedUncompleted = [[NSArray alloc] init];
    sortedUncompleted = [self.uncompletedTasks sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(PFObject *)a objectForKey:TASK_DUE_DATE];
        NSDate *second = [(PFObject *)b objectForKey:TASK_DUE_DATE];
        return [first compare:second];
    }];
    self.uncompletedTasks = [sortedUncompleted mutableCopy];

    NSArray *sortedCompleted = [[NSArray alloc] init];
    sortedCompleted = [self.completedTasks sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(PFObject *)a objectForKey:TASK_DUE_DATE];
        NSDate *second = [(PFObject *)b objectForKey:TASK_DUE_DATE];
        return [first compare:second];
    }];
    self.completedTasks = [sortedCompleted mutableCopy];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
    [self.overdueTasks removeAllObjects];
    [self.uncompletedTasks removeAllObjects];
    [self.completedTasks removeAllObjects];
    [self.other removeAllObjects];
    
    self.hasLoadedTasks = NO;
    PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
    [query whereKey:TASK_COMPLETION_ASIGNEE equalTo:self.student];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *error) {
        if ((objs.count == 0) || error) {
            self.hasLoadedTasks = YES;
            [self.completedTasksButton setEnabled:YES];
            [self.tableView reloadData];
        } else {
            for (PFObject *taskCompletion in objs) {
                PFObject *task = [taskCompletion objectForKey:TASK_COMPLETION_TASK];
                [task fetchIfNeededInBackgroundWithBlock:^(PFObject *taskFetched, NSError *error) {
                    PFObject *thisTaskClass = [taskFetched objectForKey:TASK_CLASS];
                    if ((thisTaskClass == self.classToShow) || (self.classToShow == nil)) {
                        if ([[taskCompletion objectForKey:TASK_IS_COMPLETED] boolValue]) {
                            [self.completedTasks addObject:task];
                        } else {
                            NSDate *dueDate = [task objectForKey:TASK_DUE_DATE];
                            NSDate *now = [NSDate date];
                            if ([dueDate compare:now] == NSOrderedAscending) {
                                [self.overdueTasks addObject:task];
                            } else {
                                [self.uncompletedTasks addObject:task];
                            }
                        }
                    } else {
                        [self.other addObject:task];
                    }
                    NSInteger totalTasks = self.completedTasks.count + self.overdueTasks.count + self.uncompletedTasks.count + self.other.count;
                    if (totalTasks >= objs.count) {
                        [self sortTaskArrays];
                        self.hasLoadedTasks = YES;
                        [self.completedTasksButton setEnabled:YES];
                        [self.tableView reloadData];
                    }
                }];
            }

        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hasLoadedTasks) return  2;
    else return 1;
}

#pragma mark – Table View Data Source and Delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == OVERDUE_SECTION) {
        return @"Overdue Tasks";
    } else if (section == UNCOMPLETED_SECTION) {
        return @"Uncompleted Tasks";
    }
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasLoadedTasks) {
        if (section == OVERDUE_SECTION) {
            if (self.overdueTasks.count == 0) return 1; // Cell that says "none"
            else return self.overdueTasks.count;
        } else if (section == UNCOMPLETED_SECTION) {
            if (self.uncompletedTasks.count == 0) return 1; // Cell that says "none"
            else return self.uncompletedTasks.count;
        } else {
            return 0;
        }
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedTasks) {
        if ((indexPath.section == OVERDUE_SECTION && self.overdueTasks.count == 0) || (indexPath.section == UNCOMPLETED_SECTION && self.uncompletedTasks.count == 0)) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            self.selectedIndexPath = indexPath;
            [self performSegueWithIdentifier:@"toTask" sender:self];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    if (self.hasLoadedTasks) {
        if (indexPath.section == OVERDUE_SECTION) {
            if (self.overdueTasks.count == 0) {
                cell.textLabel.text = @"None";
                cell.detailTextLabel.text = @"";
            } else {
                PFObject *task = [self.overdueTasks objectAtIndex:indexPath.row];
                cell.detailTextLabel.textColor = [UIColor redColor];
                cell.textLabel.text = [task objectForKey:TASK_NAME];
                NSDate *date = [task objectForKey:TASK_DUE_DATE];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd"];
                NSString *theDate = [NSString stringWithFormat:@"Due: %@", [dateFormat stringFromDate:date]];
                cell.detailTextLabel.text = theDate;
            }
        } else if (indexPath.section == UNCOMPLETED_SECTION) {
            if (self.uncompletedTasks.count == 0) {
                cell.textLabel.text = @"None";
                cell.detailTextLabel.text = @"";
            } else {
                PFObject *task = [self.uncompletedTasks objectAtIndex:indexPath.row];
                cell.detailTextLabel.textColor = [UIColor grayColor];
                cell.textLabel.text = [task objectForKey:TASK_NAME];
                NSDate *date = [task objectForKey:TASK_DUE_DATE];
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"MM/dd"];
                NSString *theDate = [NSString stringWithFormat:@"Due: %@", [dateFormat stringFromDate:date]];
                cell.detailTextLabel.text = theDate;
            }
        }
    } else {
        cell.textLabel.text = @"Loading tasks...";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCompletedTasks"]) {
        CompletedTasksTableViewController *dest = segue.destinationViewController;
        dest.completedTasks = self.completedTasks;
    } else if ([segue.identifier isEqualToString:@"toTask"]) {
        StudentTaskViewController *dest = segue.destinationViewController;
        dest.isCompleted = NO;
        if (self.selectedIndexPath.section == OVERDUE_SECTION) {
            dest.task = [self.overdueTasks objectAtIndex:self.selectedIndexPath.row];
        } else if (self.selectedIndexPath.section == UNCOMPLETED_SECTION) {
            dest.task = [self.uncompletedTasks objectAtIndex:self.selectedIndexPath.row];
        }
    }
}


@end
