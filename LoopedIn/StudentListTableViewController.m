//
//  StudentListTableViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentListTableViewController.h"
#import "StudentTableViewCell.h"
#import "DBKeys.h"
#import "Common.h"

@interface StudentListTableViewController ()
@property NSArray *students;
@end

@implementation StudentListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PFRelation *relation = [self.myClass relationForKey:CLASS_STUDENTS];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *err) {
        if (results) {
            self.students = results;
            [self sortStudentArray];
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
    return self.students.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StudentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    PFUser *student = [self.students objectAtIndex:indexPath.row];
    [cell setUpCellWithUser:student];
//    [cell setName:[self.students objectAtIndex:indexPath.row] setImage:[UIImage imageNamed:@"rachel.jpeg"]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
