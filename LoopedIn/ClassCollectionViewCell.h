//
//  ClassCollectionViewCell.h
//  LoopedIn
//
//  Created by Rachel on 12/2/15.
//  Copyright (c) 2015 Rachel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ClassCollectionViewCell : UICollectionViewCell
- (void)setUpCellWithClass:(PFObject *)theClass;
@end