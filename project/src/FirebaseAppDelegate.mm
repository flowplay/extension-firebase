#include "FirebaseAppDelegate.h"

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import <Firebase.h>

@implementation FirebaseAppDelegate

+ (instancetype)sharedInstance
{
  static FirebaseAppDelegate *_sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[self alloc] _init];
  });
  return _sharedInstance;
}

- (instancetype)_init
{
  NSLog(@"FirebaseAppDelegate: _init");
  return self;
}

- (instancetype)init
{
  return nil;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    NSLog(@"FirebaseAppDelegate: willFinishLaunchingWithOptions");
    [FIRApp configure];
    return YES;
}

@end