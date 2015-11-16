//
//  Common.h
//  
//
//  Created by Rachel on 11/10/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Common : NSObject
+ (void)setBorder:(UIView *)view withColor:(UIColor *)color;
+ (void)setUpNavBar:(UIViewController *)vc;
+ (NSString *)getFirstNameFromFullName:(NSString *)fullName;
+ (NSString *)getLastNameFromFullName:(NSString *)fullName;
@end
