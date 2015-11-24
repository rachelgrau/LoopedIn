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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextButtonPressed:(id)sender {
    if (!self.task) {
        self.task = [PFObject objectWithClassName:TASK_CLASS_NAME];
    }
    [self.task setObject:self.nameTextField.text forKey:TASK_NAME];
    [self.task setObject:self.descriptionTextField.text forKey:TASK_DESC];
    [self.task setObject:self.datePicker.date forKey:TASK_DUE_DATE];
    [self performSegueWithIdentifier:@"finishCreateTask" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"finishCreateTask"]) {
        FinishCreateTaskViewController *dest = segue.destinationViewController;
        dest.task = self.task;
        dest.myClass = self.myClass;
    }
}


@end
