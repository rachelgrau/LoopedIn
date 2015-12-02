//
//  StudentTeacherViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/24/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentTeacherViewController.h"
#import "TaskViewController.h"
#import "Common.h"
#import "DBKeys.h"
#import <Parse/Parse.h>

@interface StudentTeacherViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIImageView *profPic;
@property NSMutableArray *uncompletedTasks;
@property NSMutableArray *completedTasks;
@property BOOL tasksLoaded;
@property NSIndexPath *selectedIndexPath;
@end

@implementation StudentTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tasksLoaded = NO;
    self.uncompletedTasks = [[NSMutableArray alloc] init];
    self.completedTasks = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:TASK_COMPLETION_CLASS_NAME];
    [query whereKey:TASK_COMPLETION_ASIGNEE equalTo:self.student];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (PFObject *taskCompletion in objects) {
            PFObject *task = [taskCompletion objectForKey:TASK_COMPLETION_TASK];
            [task fetchInBackgroundWithBlock:^(PFObject *fetchedTask, NSError *error) {
                if (![[taskCompletion objectForKey:TASK_IS_COMPLETED] boolValue]) {
                    [self.uncompletedTasks addObject:fetchedTask];
                } else {
                    [self.completedTasks addObject:fetchedTask];
                }
                if ((self.uncompletedTasks.count + self.completedTasks.count) == objects.count) {
                    self.tasksLoaded = YES;
                    [self.tableView reloadData];
                }
            }];
        }
        if (objects.count == 0) {
            self.tasksLoaded = YES;
            [self.tableView reloadData];
        }
    }];
    
    /* Set up profile picture */
    [self loadProfPic];
    
    /* Set name label */
    NSString *fullName = [self.student objectForKey:FULL_NAME];
    NSString *firstName = [Common getFirstNameFromFullName:fullName];
    self.title = firstName;
    UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:32.0f];
    UIFont *normalFont = [UIFont fontWithName:@"Avenir-Book" size:32.0f];
    
    NSDictionary *boldAttr = @{
                               NSFontAttributeName:boldFont
                               };
    NSDictionary *normalAttr = @{
                                 NSFontAttributeName:normalFont
                                 };
    const NSRange range = NSMakeRange(0, firstName.length);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:fullName
                                           attributes:normalAttr];
    [attributedText setAttributes:boldAttr range:range];
    [self.nameLabel setAttributedText:attributedText];

}

- (void)viewDidAppear:(BOOL)animated {
    if (self.selectedIndexPath) {
        [self.tableView deselectRowAtIndexPath:self.selectedIndexPath animated:YES];
    }
}

- (void)loadProfPic {
    PFFile *imageFile = [self.student objectForKey:PROFILE_PIC];
    if (imageFile) {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data && !error) {
                UIImage *profilePicture = [UIImage imageWithData:data];
                [self.profPic setImage:profilePicture];
                /* Crop to circle */
                [self.profPic setImage:profilePicture];
                self.profPic.layer.cornerRadius = self.profPic.frame.size.width / 2;
                self.profPic.clipsToBounds = YES;
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Incomplete Tasks";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.tasksLoaded) {
        return self.uncompletedTasks.count;
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tasksLoaded) {
        self.selectedIndexPath = indexPath;
        [self performSegueWithIdentifier:@"toTask" sender:self];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"studentCell" forIndexPath:indexPath];
    if (self.tasksLoaded) {
        PFObject *task = [self.uncompletedTasks objectAtIndex:indexPath.row];
        cell.textLabel.text = [task objectForKey:TASK_NAME];
        NSDate *date = [task objectForKey:TASK_DUE_DATE];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd"];
        NSString *theDate = [NSString stringWithFormat:@"Due: %@", [dateFormat stringFromDate:date]];
        cell.detailTextLabel.text = theDate;
    } else {
        cell.textLabel.text = @"Loading tasks...";
        cell.detailTextLabel.text = @"";
    }
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTask"]) {
        TaskViewController *dest = segue.destinationViewController;
        dest.task = [self.uncompletedTasks objectAtIndex:self.selectedIndexPath.row];
    }
}


@end
