#import <UIKit/UIKit.h>

@interface FirebaseAppDelegate : NSObject  <UIApplicationDelegate>

+ (instancetype)sharedInstance;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end