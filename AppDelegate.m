#import "AppDelegate.h"
#import "BZGSignupViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BZGSignupViewController *signupVC = [[BZGSignupViewController alloc] initWithStyle:UITableViewStylePlain];
    self.window.rootViewController = signupVC;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
