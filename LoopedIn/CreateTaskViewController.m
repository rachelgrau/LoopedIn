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

@interface CreateTaskViewController ()
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property NSString *selectedDate;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property PFObject *task;
@end

@implementation CreateTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create Task";
}

- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    
    self.selectedDate = formatedDate;
    NSLog(@"%@", self.selectedDate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender {
    if (!self.task) {
        self.task = [PFObject objectWithClassName:TASK_CLASS_NAME];
    }
    [self.task setObject:TASK_NAME forKey:self.nameTextField.text];
    [self.task setObject:TASK_DESC forKey:self.descriptionTextField.text];
    [self performSegueWithIdentifier:@"finishCreateTask" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"finishCreateTask"]) {
        FinishCreateTaskViewController *dest = segue.destinationViewController;
        dest.task = self.task;
    }
}


@end
