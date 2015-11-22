//
//  TeacherHomeViewController.m
//  
//
//  Created by Rachel on 11/2/15.
//
//

#import "TeacherHomeViewController.h"
#import "SignUpViewController.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "DBKeys.h"

@interface TeacherHomeViewController ()
@property (strong, nonatomic) IBOutlet UIButton *studentsButton;
@property (strong, nonatomic) IBOutlet UIButton *tasksButton;
@property (strong, nonatomic) IBOutlet UILabel *classCodeLabel;
@property (strong, nonatomic) IBOutlet UIButton *rewardsButton;
@end

@implementation TeacherHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TO DO: if !self.myClass, load it in 
    
    if (self.myClass) {
        self.classCodeLabel.text = [NSString stringWithFormat:@"Class code: %@", [self.myClass objectForKey:CLASS_CODE]];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:CLASS_CLASS_NAME];
        [query whereKey:CLASS_TEACHER equalTo:[PFUser currentUser]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
            if (obj) {
                self.myClass = obj;
                self.classCodeLabel.text = [NSString stringWithFormat:@"Class code: %@", [self.myClass objectForKey:CLASS_CODE]];
            }
        }];
    }
    
    /* Set navigation title */
    [Common setUpNavBar:self];
    
    /* Set borders of buttons */
    [Common setBorder:self.studentsButton withColor:[UIColor blackColor]];
    [Common setBorder:self.tasksButton withColor:[UIColor blackColor]];
    [Common setBorder:self.rewardsButton withColor:[UIColor blackColor]];
    
    /* Add settings button */
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsButtonImage = [UIImage imageNamed:@"settings.png"];
    [settingsButton setBackgroundImage:settingsButtonImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *settingsNavButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsNavButton;
}

- (void)goToSettings:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOutPressed:(id)sender {
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
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
