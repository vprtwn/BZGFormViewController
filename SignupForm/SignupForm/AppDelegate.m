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
    SignupViewController *signupVC = [[SignupViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:signupVC];
    nc.navigationBar.translucent = NO;
    self.window.rootViewController = nc;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
