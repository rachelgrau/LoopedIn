//
//  FinishCreateTaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "FinishCreateTaskViewController.h"
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

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
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

- (IBAction)createTask:(id)sender {
    /* TO DO: Loading icon / disable buttons while we store this stuff */
    NSString *pointsStr = [self pickerView:self.pointPicker titleForRow:[self.pointPicker selectedRowInComponent:0] forComponent:0];

    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *points = [f numberFromString:pointsStr];
    NSString *name = [self.task objectForKey:TASK_NAME];
    NSString *description = [self.task objectForKey:TASK_DESC];
    NSDate *dueDate = [self.task objectForKey:TASK_DUE_DATE];
    
    /* Get list of students */
    PFRelation *relation = [self.myClass relationForKey:CLASS_STUDENTS];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *students, NSError *err) {
        if (students) {
            if ([self.studentsSwitch isOn]) {
                /* Create a task for each student */
                for (PFUser *student in students) {
                    PFObject *currTask = [PFObject objectWithClassName:TASK_CLASS_NAME];
                    [currTask setObject:name forKey:TASK_NAME];
                    [currTask setObject:description forKey:TASK_DESC];
                    [currTask setObject:dueDate forKey:TASK_DUE_DATE];
                    [currTask setObject:points forKey:TASK_POINTS];
                    [currTask setObject:[PFUser currentUser] forKey:TASK_TEACHER];
                    [currTask setObject:student forKey:TASK_ASIGNEE];
                    [currTask saveInBackground];
                }
            }
            if ([self.parentsSwitch isOn]) {
                /* TO DO: loop through student and create task for each parent*/
                for (PFUser *student in students) {
                    /* Find the parent of this student */
                    PFQuery *query = [PFQuery queryWithClassName:PARENTHOOD_CLASS_NAME];
                    [query whereKey:CHILD equalTo:student];
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *parentObj, NSError *error) {
                        PFUser *parent = (PFUser *)parentObj;
                        PFObject *currTask = [PFObject objectWithClassName:TASK_CLASS_NAME];
                        [currTask setObject:name forKey:TASK_NAME];
                        [currTask setObject:description forKey:TASK_DESC];
                        [currTask setObject:dueDate forKey:TASK_DUE_DATE];
                        [currTask setObject:points forKey:TASK_POINTS];
                        [currTask setObject:parent forKey:TASK_TEACHER];
                        [currTask setObject:parent forKey:TASK_ASIGNEE];
                        [currTask saveInBackground];
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
