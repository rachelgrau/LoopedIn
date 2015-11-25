//
//  StudentTeacherViewController.m
//  LoopedIn
//
//  Created by Rachel on 11/24/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentTeacherViewController.h"
#import "Common.h"
#import "DBKeys.h"

@interface StudentTeacherViewController ()
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *profPic;
@end

@implementation StudentTeacherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
