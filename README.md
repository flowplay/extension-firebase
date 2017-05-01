# extension-firebase

Note: This extension needs lots of cleanup and depends on an delegate registry that is not included in this project. 
Most third party integrations require putting init code in the willFinishLaunchingWithOptions or didFinishLaunchingWithOptions
delegates. Unfortunately, this delegate can only be overridden once.  We have several third-party integrations. Which 
required us to build a registry, something like this:

#### NMEAppDelegate+Extension.mm

```
#include "NMEAppDelegate+Extension.h"
#include "AppDelegateRegistry.h"
#include "DeepLinkApplicationDelegate.h"
#include "SwrveAppDelegate.h"
#include "FacebookAppDelegate.h"
#include "KochavaApplicationDelegate.h"
#include "FirebaseAppDelegate.h"

#import <hxcpp.h>
#import <hx/GC.h>
#import <objc/runtime.h>

@implementation SDLUIKitDelegate (Extension)

-(id)init {
    self = [super init];

    NSLog(@"NMEAppDelegate+Extension init");

    [[AppDelegateRegistry sharedInstance] registerDelegate: [FacebookAppDelegate sharedInstance]];
    [[AppDelegateRegistry sharedInstance] registerDelegate: [DeepLinkApplicationDelegate sharedInstance]];
    [[AppDelegateRegistry sharedInstance] registerDelegate: [SwrveAppDelegate sharedInstance]];
    [[AppDelegateRegistry sharedInstance] registerDelegate: [KochavaApplicationDelegate sharedInstance]];
    [[AppDelegateRegistry sharedInstance] registerDelegate: [FirebaseAppDelegate sharedInstance]];

    [[NSNotificationCenter defaultCenter] addObserverForName:
     UIApplicationDidReceiveMemoryWarningNotification
     object:[UIApplication sharedApplication] queue:nil
     usingBlock:^(NSNotification *notif) {
          __hxcpp_collect(true);
          __hxcpp_gc_compact();
    }];
    return self;
}

-(BOOL)application         : (UIApplication *) application
       openURL             : (NSURL *)url
       sourceApplication   : (NSString *)sourceApplication
       annotation          : (id)annotation
{
    // call all the registered delegates
    BOOL result = YES;
    NSArray* delegates = [[AppDelegateRegistry sharedInstance] getDelegates];
    for (NSObject <UIApplicationDelegate> *delegate in delegates) {
        if ([delegate respondsToSelector:@selector(application:openURL:sourceApplication:annotation:)])
        {
            result &= [delegate application: application openURL: url sourceApplication: sourceApplication annotation: annotation];
        }
    }

    return result;
}

-(BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    NSLog(@"NMEAppDelegate+Extension willFinishLaunchingWithOptions");

    // call all the registered delegates
    BOOL result = YES;
    for (NSObject <UIApplicationDelegate> *delegate in [[AppDelegateRegistry sharedInstance] getDelegates]) {
        if ([delegate respondsToSelector:@selector(application:willFinishLaunchingWithOptions:)])
        {
            result &= [delegate application: application willFinishLaunchingWithOptions: launchOptions];
        }
    }
    return result;
}

- (BOOL)application          : (UIApplication *)application
        continueUserActivity : (NSUserActivity *)userActivity
        restorationHandler   : (void (^)(NSArray *restorableObjects))restorationHandler
{
    NSLog(@"NMEAppDelegate+Extension continueUserActivity");
     // call all the registered delegates
     BOOL result = YES;
     for (NSObject <UIApplicationDelegate> *delegate in [[AppDelegateRegistry sharedInstance] getDelegates]) {
         if ([delegate respondsToSelector:@selector(application:continueUserActivity:restorationHandler:)])
         {
             result &= [delegate application: application continueUserActivity: userActivity restorationHandler: restorationHandler];
         }
     }
     return result;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"NMEAppDelegate+Extension didReceiveRemoteNotification");
    // call all the registered delegates
    for (NSObject <UIApplicationDelegate> *delegate in [[AppDelegateRegistry sharedInstance] getDelegates]) {
        if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)])
        {
            [delegate application: application didReceiveRemoteNotification: userInfo];
        }
    }
}


@end
```

# How to use the extension

Follow [these instructions](https://firebase.google.com/docs/ios/setup) on downloading your GoogleServices-Info.plist 
file from firebase.

We place the firebase plist config file in our templates/ios folder in our project. We also must override the project.pbxproj
file to load this and other plist files. This is a very sloppy process that requires using xcode to drag and drop the plist into 
the project and copying the resulting entries in the project.pbxproj into our template project.pbxproj. If you have questions
 about this insane process your best bet is to join the openfl slack channel here: https://openfl-slack-invite.herokuapp.com/


Include the extension in your project.xml, change the 'path' to wherever you keep your libs.

```<haxelib name="extension-firebase" path="../libs/extension-firebase" />```


