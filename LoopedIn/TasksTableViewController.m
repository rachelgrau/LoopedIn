//
//  TasksTableViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "TasksTableViewController.h"
#import "DBKeys.h"
#import "CreateTaskViewController.h"
#import "TaskViewController.h"

@interface TasksTableViewController ()
@property NSArray *tasks;
@property BOOL hasLoadedTasks;
@property PFObject *selectedTask;
@end

@implementation TasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tasks";
    
    UIBarButtonItem *plusButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    
    self.navigationItem.rightBarButtonItem = plusButton;
}

- (void)viewWillAppear:(BOOL)animated {
    self.hasLoadedTasks = NO;
    /* Load tasks that this teacher has assigned */
    PFQuery *taskQuery = [PFQuery queryWithClassName:TASK_CLASS_NAME];
    [taskQuery whereKey:TASK_TEACHER equalTo:[PFUser currentUser]];
    [taskQuery orderByAscending:TASK_DUE_DATE];
    [taskQuery findObjectsInBackgroundWithBlock:^(NSArray *tasks, NSError *error) {
        self.tasks = tasks;
        self.hasLoadedTasks = YES;
        [self.tableView reloadData];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addTask {
    [self performSegueWithIdentifier:@"toCreateTask" sender:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasLoadedTasks) {
        return self.tasks.count;
    } else {
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskTableViewCell" forIndexPath:indexPath];
    if (self.hasLoadedTasks) {
        PFObject *task = [self.tasks objectAtIndex:indexPath.row];
        cell.textLabel.text = [task objectForKey:TASK_NAME];
        NSDate *date = [task objectForKey:TASK_DUE_DATE];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd"];
        NSString *theDate = [NSString stringWithFormat:@"Due: %@", [dateFormat stringFromDate:date]];
        cell.detailTextLabel.text = theDate;
    } else {
        cell.textLabel.text = @"Loading tasks...";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedTasks) {
        self.selectedTask = [self.tasks objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"toSingleTask" sender:self];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCreateTask"]) {
        CreateTaskViewController *dest = segue.destinationViewController;
        dest.isEditing = NO;
        dest.myClass = self.myClass;
    } else if ([segue.identifier isEqualToString:@"toSingleTask"]) {
        TaskViewController *dest = segue.destinationViewController;
        dest.task = self.selectedTask;
    }
}


@end
