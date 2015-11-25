//
//  StudentListTableViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentListTableViewController.h"
#import "StudentTableViewCell.h"
#import "StudentTeacherViewController.h"
#import "DBKeys.h"
#import "Common.h"

@interface StudentListTableViewController ()
@property NSArray *students;
@property BOOL hasLoadedStudents;
@property PFObject *selectedStudent;
@end

@implementation StudentListTableViewController

- (void)viewDidLoad {
    self.hasLoadedStudents = NO;
    [super viewDidLoad];
    PFRelation *relation = [self.myClass relationForKey:CLASS_STUDENTS];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *err) {
        if (results) {
            self.students = results;
            [self sortStudentArray];
            self.hasLoadedStudents = YES;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/* Sorts the student array by last names. */
- (void)sortStudentArray {
    NSArray *sortedArray = [self.students sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        PFUser *first = a;
        PFUser *second = b;
        NSString *lastNameOne = [Common getLastNameFromFullName:[first objectForKey:FULL_NAME]];
        NSString *lastNameTwo = [Common getLastNameFromFullName:[second objectForKey:FULL_NAME]];
        return [lastNameOne compare:lastNameTwo];
    }];
    self.students = sortedArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasLoadedStudents) {
        return self.students.count;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasLoadedStudents) {
        self.selectedStudent = [self.students objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"toStudentView" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    if (self.hasLoadedStudents) {
        PFUser *student = [self.students objectAtIndex:indexPath.row];
        [cell setUpCellWithUser:student];
    } else {
        [cell setUpLoadingCell];
    }
    return cell;
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
    if ([segue.identifier isEqualToString:@"toStudentView"]) {
        StudentTeacherViewController *dest = segue.destinationViewController;
        dest.student = self.selectedStudent;
    }
}


@end
