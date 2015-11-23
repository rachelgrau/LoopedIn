//
//  StudentTableViewCell.m
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "StudentTableViewCell.h"
#import "DBKeys.h"
#import "Common.h"

@interface StudentTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *profPicImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *arrowImageView;

@end


@implementation StudentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setProfImage:(UIImage *)image {
    [self.profPicImageView setImage:image];
    /* Crop to circle */
    self.profPicImageView.layer.cornerRadius = self.profPicImageView.frame.size.width / 2;
    self.profPicImageView.clipsToBounds = YES;
}

- (void)setUpCellWithUser:(PFUser *)user {
    /* Set name label */
    NSString *name = [user objectForKey:FULL_NAME];
    NSString *firstName = [Common getFirstNameFromFullName:name];
    UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    UIFont *normalFont = [UIFont fontWithName:@"Avenir-Book" size:17.0f];
    NSDictionary *boldAttr = @{
                               NSFontAttributeName:boldFont
                               };
    NSDictionary *normalAttr = @{
                                 NSFontAttributeName:normalFont
                                 };
    const NSRange range = NSMakeRange(0, firstName.length);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:name
                                           attributes:normalAttr];
    [attributedText setAttributes:boldAttr range:range];
    [self.nameLabel setAttributedText:attributedText];
    
    PFFile *imageFile = [user objectForKey:PROFILE_PIC];
    if (!imageFile) {
        [self setProfImage:[UIImage imageNamed:@"noProfPic.png"]];
    }
    if (imageFile) {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (data && !error) {
                UIImage *profilePicture = [UIImage imageWithData:data];
                [self setProfImage:profilePicture];
            } else {
                [self setProfImage:[UIImage imageNamed:@"noProfPic.png"]];
            }
        }];
    }
}

- (void)setName:(NSString *)name setImage:(UIImage *)image {
    /* Set name label */
    NSString *firstName = [Common getFirstNameFromFullName:name];
    UIFont *boldFont = [UIFont fontWithName:@"Avenir-Heavy" size:17.0f];
    UIFont *normalFont = [UIFont fontWithName:@"Avenir-Book" size:17.0f];
    NSDictionary *boldAttr = @{
                               NSFontAttributeName:boldFont
                               };
    NSDictionary *normalAttr = @{
                                 NSFontAttributeName:normalFont
                                 };
    const NSRange range = NSMakeRange(0, firstName.length);
    
    NSMutableAttributedString *attributedText =
    [[NSMutableAttributedString alloc] initWithString:name
                                           attributes:normalAttr];
    [attributedText setAttributes:boldAttr range:range];
    [self.nameLabel setAttributedText:attributedText];
    
    if (image) {
        self.profPicImageView.image = image;
        self.profPicImageView.layer.cornerRadius = self.profPicImageView.frame.size.width / 2;
        self.profPicImageView.clipsToBounds = YES;
    }
}

@end
