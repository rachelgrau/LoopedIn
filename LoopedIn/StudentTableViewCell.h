//
//  StudentTableViewCell.h
//  LoopedIn
//
//  Created by Rachel on 11/23/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudentTableViewCell : UITableViewCell
- (void)setUpCellWithUser:(PFUser *)user;
- (void)setName:(NSString *)name setImage:(UIImage *)image;
/* Sets up a cell with a label that says "Loading students..." */
- (void)setUpLoadingCell;
@end
