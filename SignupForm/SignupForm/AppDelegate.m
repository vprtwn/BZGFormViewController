//
//  AppDelegate.m
//
//  https://github.com/benzguo/BZGFormViewController
//

#import "AppDelegate.h"
#import "SignupViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SignupViewController *signupVC = [[SignupViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.window.rootViewController = signupVC;
    [self.window makeKeyAndVisible];
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    return YES;
}

@end
