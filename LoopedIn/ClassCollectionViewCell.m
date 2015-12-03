//
//  ClassCollectionViewCell.m
//  LoopedIn
//
//  Created by Rachel on 12/2/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import "ClassCollectionViewCell.h"
#import <Parse/Parse.h>
#import "DBKeys.h"

@interface ClassCollectionViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *classIconImageView;
@end

@implementation ClassCollectionViewCell
- (void)setUpCellWithClass:(PFObject *)theClass {
    if (theClass) {
        NSString *className = [theClass objectForKey:CLASS_NAME];
        self.classNameLabel.text = className;
        
        NSString *classType = [theClass objectForKey:CLASS_TYPE];
        if ([classType isEqualToString:CLASS_TYPE_ART]) {
            [self.classIconImageView setImage:[UIImage imageNamed:@"art.png"]];
        } else if ([classType isEqualToString:CLASS_TYPE_ENGLISH]) {
            [self.classIconImageView setImage:[UIImage imageNamed:@"english.png"]];
        } else if ([classType isEqualToString:CLASS_TYPE_HISTORY]) {
            [self.classIconImageView setImage:[UIImage imageNamed:@"history.png"]];
        } else if ([classType isEqualToString:CLASS_TYPE_LANGUAGE]) {
            [self.classIconImageView setImage:[UIImage imageNamed:@"language.png"]];
        } else if ([classType isEqualToString:CLASS_TYPE_MATH]) {
            [self.classIconImageView setImage:[UIImage imageNamed:@"math.png"]];
        } else if ([classType isEqualToString:CLASS_TYPE_SCIENCE]) {
            [self.classIconImageView setImage:[UIImage imageNamed:@"art.png"]];
        } else {
            [self.classIconImageView setImage:[UIImage imageNamed:@"other.png"]];
        }
        self.classNameLabel.textColor = [UIColor blackColor];
    } else {
        self.classNameLabel.text = @"Join Class";
        self.classNameLabel.textColor = [UIColor colorWithRed:70.0/255.0 green:225.0/255.0 blue:182.0/255.0 alpha:1.0];
        [self.classIconImageView setImage:[UIImage imageNamed:@"addClass.png"]];
    }
}
@end
