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

- (void)setUpCellWithLabelText:(NSString *)labelText image:(UIImage *)image withTextColor:(UIColor *)textColor circular:(BOOL)isCircular {
    self.classNameLabel.text = labelText;
    self.classNameLabel.textColor = textColor;
    [self.classIconImageView setImage:image];
    if (isCircular) {
        /* Crop to circle */
        self.classIconImageView.layer.cornerRadius = self.classIconImageView.frame.size.width / 2;
        self.classIconImageView.clipsToBounds = YES;
    }
}

@end
