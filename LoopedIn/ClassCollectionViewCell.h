//
//  ClassCollectionViewCell.h
//  LoopedIn
//
//  Created by Rachel on 12/2/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//
// Cell with a label and an image.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ClassCollectionViewCell : UICollectionViewCell
/* Sets up the cell. The cell contains a label, whose text will be |labelText| in |textColor|. The cell also has an image above the label, which will contain |image| and will be circular if |isCircular| == YES (and default, or unchanged, otherwise).  */
- (void)setUpCellWithLabelText:(NSString *)labelText image:(UIImage *)image withTextColor:(UIColor *)textColor circular:(BOOL)isCircular;
@end
