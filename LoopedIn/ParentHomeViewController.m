//
//  ParentHomeViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "ParentHomeViewController.h"
#import "StudentTasksViewController.h"
#import "ClassCollectionViewCell.h"
#import <Parse/Parse.h>
#import "Common.h"
#import "DBKeys.h"

@interface ParentHomeViewController ()
@property NSMutableArray *myChildren;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property BOOL myChildrenLoaded;
@property (strong, nonatomic) IBOutlet UILabel *parentNameLabel;
@property NSIndexPath *selectedClassIndexPath;
@end

@implementation ParentHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myChildrenLoaded = NO;
    self.myChildren = [[NSMutableArray alloc] init];
    
    /* Set name label */
    NSString *fullName = [[PFUser currentUser] objectForKey:FULL_NAME];
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
    [self.parentNameLabel setAttributedText:attributedText];
    
    
    /* Set navigation title */
    [Common setUpNavBar:self];
    
    /* Add settings button */
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *settingsButtonImage = [UIImage imageNamed:@"settings.png"];
    [settingsButton setBackgroundImage:settingsButtonImage forState:UIControlStateNormal];
    [settingsButton addTarget:self action:@selector(goToSettings:) forControlEvents:UIControlEventTouchUpInside];
    settingsButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *settingsNavButton = [[UIBarButtonItem alloc] initWithCustomView:settingsButton];
    self.navigationItem.rightBarButtonItem = settingsNavButton;

    PFQuery *parenthoodQuery = [PFQuery queryWithClassName:PARENTHOOD_CLASS_NAME];
    [parenthoodQuery whereKey:PARENT equalTo:[PFUser currentUser]];
    [parenthoodQuery findObjectsInBackgroundWithBlock:^(NSArray *objs, NSError *err) {
        for (PFObject *parenthood in objs) {
            PFUser *child = [parenthood objectForKey:CHILD];
            [child fetchInBackgroundWithBlock:^(PFObject *obj, NSError *error) {
                PFUser *fetchedChild = (PFUser *)obj;
                [self.myChildren addObject:fetchedChild];
                if (self.myChildren.count == objs.count) {
                    self.myChildrenLoaded = YES;
                    [self.collectionView reloadData];
                }
            }];
        }
    }];
}

- (IBAction)logoutPressed:(id)sender {
    if ([PFUser currentUser]) {
        [PFUser logOut];
    }
    [self performSegueWithIdentifier:@"toLogIn" sender:self];

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

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.myChildrenLoaded) {
        return self.myChildren.count + 1;
    } else {
        return 1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ClassCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"childCell" forIndexPath:indexPath];
    if (indexPath.row == self.myChildren.count) {
        /* "Add child" cell */
        [cell setUpCellWithLabelText:@"Add Child" image:[UIImage imageNamed:@"addClass.png"] withTextColor:[UIColor colorWithRed:70.0/255.0 green:225.0/255.0 blue:182.0/255.0 alpha:1.0] circular:YES];
    } else {
        PFUser *child = [self.myChildren objectAtIndex:indexPath.row];
        NSString *firstName = [Common getFirstNameFromFullName:[child objectForKey:FULL_NAME]];
        PFFile *imageFile = [child objectForKey:PROFILE_PIC];
        [cell setUpCellWithLabelText:firstName image:nil withTextColor:[UIColor blackColor] circular:YES];
        if (imageFile) {
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (data && !error) {
                    UIImage *profilePicture = [UIImage imageWithData:data];
                    [cell setUpCellWithLabelText:firstName image:profilePicture withTextColor:[UIColor blackColor] circular:YES];
                }
            }];
        } else {
            [cell setUpCellWithLabelText:firstName image:[UIImage imageNamed:@"noProfPic.png"] withTextColor:[UIColor blackColor] circular:YES];
        }
    }
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == self.myClasses.count) {
//        NSArray *arr = [NSArray arrayWithObjects:@"Join", nil];
//        TextFieldPopUp *alertView = [[TextFieldPopUp alloc] initWithPlaceholder:@"Enter a class code" delegate:self buttonTitles:arr];
//        [alertView showInView:self.view];
//    } else if (self.classesLoaded) {
//        self.selectedClass = [self.myClasses objectAtIndex:indexPath.row];
//        [self performSegueWithIdentifier:@"toTasks" sender:self];
//    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTasks"]) {
        StudentTasksViewController *dest = segue.destinationViewController;
        if (self.selectedClassIndexPath) {
            dest.classToShow = nil;
            dest.student = [PFUser currentUser];
            self.selectedClassIndexPath = nil;
        } else {
            dest.classToShow = [self.myChildren objectAtIndex:self.selectedClassIndexPath.row];
            
            dest.student = [PFUser currentUser];
        }
    }
}


@end
