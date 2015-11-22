//
//  Common.m
//  
//
//  Created by Rachel on 11/10/15.
//
//

#import "Common.h"

@implementation Common
NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

/* Returns a random string with the given length. */
+ (NSString *) randomStringWithLength: (int) len {
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }
    
    return randomString;
}

/* Given a string that contains the full name of a user, returns the first name only */
+ (NSString *)getFirstNameFromFullName:(NSString *)fullName {
    NSMutableString *firstName = [NSMutableString stringWithString:@""];
    for (int i=0; i < fullName.length; i++) {
        if ([fullName characterAtIndex:i] == ' ') {
            break;
        } else {
            [firstName appendString:[NSString stringWithFormat:@"%c", [fullName characterAtIndex:i]]];
        }
    }
    return firstName;
}

/* Given a string that contains the full name of a user, returns the last name only. If the user has a middle name (or multiple last names), returns the last name that's separated by a space. If there are no spaces (just one name), then returns the full name. */
+ (NSString *)getLastNameFromFullName:(NSString *)fullName {
    int lastSpaceIndex = -1;
    for (int i=0; i < fullName.length; i++) {
        if ([fullName characterAtIndex:i] == ' ') {
            lastSpaceIndex = i;
        }
    }
    if (lastSpaceIndex == -1) return fullName;
    return [fullName substringFromIndex:lastSpaceIndex];
}

+ (void)setBorder:(UIView *)view withColor:(UIColor *)color {
    view.layer.masksToBounds = YES;
    view.layer.borderColor = [color CGColor];
    view.layer.borderWidth = 1.0f;
}

+ (void)setUpNavBar:(UIViewController *)vc {
    vc.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:88.0/255.0 green:227.0/255.0 blue:195.0/255.0 alpha:1.0];
    vc.navigationController.navigationBar.translucent = NO;
    vc.title = @"Looped In";
    [vc.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor],
       NSFontAttributeName:[UIFont fontWithName:@"Avenir Book" size:21]}];
    vc.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

@end
