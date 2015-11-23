//
//  Common.h
//  
//
//  Created by Rachel on 11/10/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Common : NSObject
+ (void)setBorder:(UIView *)view withColor:(UIColor *)color;
+ (void)setUpNavBar:(UIViewController *)vc;
+ (NSString *)getFirstNameFromFullName:(NSString *)fullName;
+ (NSString *)getLastNameFromFullName:(NSString *)fullName;
/*  Returns a random all capital alphabetic string of the given length. */
+ (NSString *) randomStringWithLength: (int) len;
@end
