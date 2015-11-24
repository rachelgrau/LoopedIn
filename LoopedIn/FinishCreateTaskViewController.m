//
//  FinishCreateTaskViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "FinishCreateTaskViewController.h"

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
    return [self.pointOptions objectAtIndex:row];
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
