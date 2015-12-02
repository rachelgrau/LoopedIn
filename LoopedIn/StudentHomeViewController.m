//
//  StudentHomeViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/5/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentHomeViewController.h"
#import "StudentRewardViewController.h"
#import "StudentTasksViewController.h"
#import <Parse/Parse.h>
#import "DBKeys.h"
#import "Common.h"
#import "TextFieldPopUp.h"

@interface StudentHomeViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *myTasksButton;
@property (strong, nonatomic) IBOutlet UIButton *myRewardsButton;
@property (strong, nonatomic) IBOutlet UILabel *progressDescription;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicImageView;
/* Reward user currently is working towards; must be loaded */
@property PFObject *desiredReward;
/* Invisible prof pic button which overlays the imageview */
@property (strong, nonatomic) IBOutlet UIButton *flipProfilePicButton;
@property UIImage *profilePicImage;
/* YES when the user's profile picture (or ADD PROFILE PICTURE) is being displayed, NO when "CHANGE PROFILE PICTURE" is being displayed. */
@property BOOL isDisplayingProfPic;
/* YES when the user has already uploaded a profile picture; NO otherwise. */
@property BOOL hasProfPic;
@end

#define CHANGE_PROFILE_PIC_TAG 1

@implementation StudentHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Disable button until prof pic loads */
    self.flipProfilePicButton.enabled = NO;
    
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
    
    /* Load profile picture */
    [self loadAndDisplayProfilePic];
    
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
    [self.nameLabel setAttributedText:attributedText];
    
    /* Set border of tasks and rewards button */
    [Common setBorder:self.myTasksButton withColor:[UIColor blackColor]];
    [Common setBorder:self.myRewardsButton withColor:[UIColor blackColor]];
    
}

- (void) viewWillAppear:(BOOL)animated {
    /* Get points */
    NSNumber *pointsEarned = [[PFUser currentUser] objectForKey:POINTS];
    PFObject *reward = [[PFUser currentUser] objectForKey:DESIRED_REWARD];
    if (!reward) {
        self.progressDescription.text = @"No reward to work towards.";
    } else {
        [reward fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            NSString *progressDescText = @"No reward to work towards.";
            if (object) {
                self.desiredReward = object;
                NSString *rewardTitle = [object objectForKey:REWARD_TITLE];
                NSNumber *pointsNeeded = [object objectForKey:REWARD_POINTS];
                progressDescText = [NSString stringWithFormat:@"%@/%@ points earned towards %@!", pointsEarned, pointsNeeded, rewardTitle];
            }
            self.progressDescription.text = progressDescText;
        }];
    }
}

- (void)goToSettings:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"toLogIn" sender:self];
}

- (IBAction)myTasksPressed:(id)sender {
}

- (IBAction)myRewardsPressed:(id)sender {
}

- (IBAction)joinClassPressed:(id)sender {
    NSArray *arr = [NSArray arrayWithObjects:@"Join", nil];
    TextFieldPopUp *alertView = [[TextFieldPopUp alloc] initWithPlaceholder:@"Enter a class code" delegate:self buttonTitles:arr];
    [alertView showInView:self.view];
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

#pragma mark - Profile Pic stuff

/* This method loads the current user's profile picture and displays it as a circle. If the user doesn't have a profile picture yet, then it uses the "ADD PROFILE PICTURE" image as the profile pic image. */
- (void)loadAndDisplayProfilePic {
    PFFile *imageFile = [[PFUser currentUser] objectForKey:PROFILE_PIC];
    if (imageFile) {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data && !error) {
                self.isDisplayingProfPic = YES;
                self.hasProfPic = YES;
                self.flipProfilePicButton.enabled = YES;
                UIImage *profilePicture = [UIImage imageWithData:data];
                self.profilePicImage = profilePicture;
                [self.profilePicImageView setImage:profilePicture];
                /* Crop to circle */
                [self.profilePicImageView setImage:self.profilePicImage];
                self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width / 2;
                self.profilePicImageView.clipsToBounds = YES;
            }
        }];
    } else {
        self.isDisplayingProfPic = NO;
        self.hasProfPic = NO;
        self.flipProfilePicButton.enabled = YES;
        UIImage *defaultProfPic = [UIImage imageNamed:@"addProfPic.png"];
        self.profilePicImage = defaultProfPic;
        [self.profilePicImageView setImage:defaultProfPic];
        /* Crop to circle */
        [self.profilePicImageView setImage:self.profilePicImage];
        self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width / 2;
        self.profilePicImageView.clipsToBounds = YES;
    }
}

/* This method is called when the user clicks on the profile picture. If a profile picture is currently being displayed, it flips over and displays the "change profile picture" image. If the "change profile picture image" is currently being displayed, then it displays an alert asking if the user wants to upload a new profile picture. Lastly, if the user doesn't have a profile picture and the "add profile picture" image is currently being displayed, then this method shows an alert asking if the user wants to upload a profile picture. */
- (IBAction)profilePicPressed:(id)sender {
    if (self.isDisplayingProfPic && self.hasProfPic) {
        /* They clicked on their profile picture */
        self.isDisplayingProfPic = NO;
        UIImage *destImage = [UIImage imageNamed:@"changeProfPic.png"];
        self.flipProfilePicButton.enabled = NO;
        [UIView transitionWithView:self.profilePicImageView duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            self.profilePicImageView.image = destImage;
            self.flipProfilePicButton.enabled = YES;
        } completion:nil];
    } else {
        /* They clicked change prof pic */
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Change profile picture?" message:nil delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag = CHANGE_PROFILE_PIC_TAG;
        [alert show];
    }
}

/* Flips the profile picture and displays the user's profile picture, if they have one. Does nothing if they don't. */
- (void) showProfPic {
    if (self.hasProfPic) {
        self.flipProfilePicButton.enabled = NO;
        [UIView transitionWithView:self.profilePicImageView duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            self.profilePicImageView.image = self.profilePicImage;
            self.flipProfilePicButton.enabled = YES;
        } completion:nil];
    }
}

#pragma mark - Text Field Pop Up Delegate

- (void)customAlertView:(TextFieldPopUp *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex withTextFieldText:(NSString *)text {
    [alertView disableButton];
    text = [text uppercaseString];
    PFQuery *query = [PFQuery queryWithClassName:CLASS_CLASS_NAME];
    [query whereKey:CLASS_CODE equalTo:text];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *class, NSError *error) {
        if (class && !error) {
            PFRelation *relation = [class relationForKey:CLASS_STUDENTS];
            /* Check if user is already registered for this class */
            PFQuery *query = [relation query];
            [query whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
            [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
                if (count == 0) {
                    /* User hasn't yet registered for this class -- add him/her! */
                    [relation addObject:[PFUser currentUser]];
                    [class saveInBackground];
                    [alertView displaySuccessAndDisappear];
                } else {
                    [alertView displayErrorMessage:@"You're already in that class!"];
                    [alertView enableButton];
                }
            }];
        } else {
            [alertView displayErrorMessage:@"Enter a valid class code."];
            [alertView enableButton];
        }
    }];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == CHANGE_PROFILE_PIC_TAG) {
        if (buttonIndex == 0) {
            self.isDisplayingProfPic = YES;
            // Change back to prof pic, or leave it as ADD PROFILE PIC pic if they don't have one
            [self showProfPic];
        } else if (buttonIndex == 1) {
            self.isDisplayingProfPic = YES;
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.hasProfPic = YES;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    self.profilePicImage = chosenImage;
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"profilePic" data:imageData];
    [imageFile saveInBackground];
    
    PFUser *user = [PFUser currentUser];
    [user setObject:imageFile forKey:PROFILE_PIC];
    [user saveInBackground];
    
    [UIView transitionWithView:self.profilePicImageView duration:.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        self.profilePicImageView.image = chosenImage;
        self.flipProfilePicButton.enabled = YES;
    } completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.isDisplayingProfPic = YES;
    [self showProfPic];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toRewards"]) {
        StudentRewardViewController *dest = segue.destinationViewController;
        if (self.desiredReward) {
            dest.desiredReward = self.desiredReward;
        }
    } else if ([segue.identifier isEqualToString:@"toTasks"]) {
        StudentTasksViewController *dest = segue.destinationViewController;
        dest.student = [PFUser currentUser];
    }
}


@end
