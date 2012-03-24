//
//  AppDelegate.m
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
// JANET GINSBERG
//      Edward tufte
//      Design for hackers.com
// Music - Givers

#import "AppDelegate.h"

#import "FBConnect.h"
#import "JSONKit.h"

#import "HomeController.h"
#import "NewMeetViewController.h"
#import "ShowMeetViewController.h"
#import "SearchTestController.h"
#import "StandardSearchController.h"

// http://drifthere.com/api/meet/get_meetings?latitude=1&longitude=1
// http://drifthere.com/api/meet/get_single_meeting/10

// Your Facebook APP Id must be set before running this example
// See http://www.facebook.com/developers/createapp.php
// Also, your application must bind to the fb[app_id]:// URL
// scheme (substitute [app_id] for your real Facebook app id).
static NSString* kAppId = @"227118464003308";

@implementation AppDelegate

@synthesize window = _window, facebook = _facebook, currentUser = _currentUser;
@synthesize isLoggedIn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.supportsShakeToReload = YES;
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    
    TTURLMap* map = navigator.URLMap;
    [map from:@"*" toViewController:[TTWebController class]];
    
    [map                    from: @"dh://home"
          toSharedViewController: [HomeController class]];
    
    [map            from: @"dh://new_meet"
                  parent: nil
        toViewController: [NewMeetViewController class]
                selector: nil
              transition: NO];
    
    [map            from: @"dh://find_meet"
                  parent: nil
        toViewController: [StandardSearchController class]
                selector: nil
              transition: NO];
    
    [map            from: @"dh://show_meet"
                  parent: nil
        toViewController: [ShowMeetViewController class]
                selector: nil
              transition: NO];

    if (![navigator restoreViewControllers]) {
        [navigator openURLAction:[TTURLAction actionWithURLPath:@"dh://home"]];
    }
    
    _permissions =  [[NSArray arrayWithObjects:
                      @"read_stream", @"publish_stream", @"offline_access",nil] retain];
    _facebook = [[Facebook alloc] initWithAppId:kAppId
                                    andDelegate:self];
    isLoggedIn = @"NO";
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    TTDPRINT(@"");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    TTDPRINT(@"");
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    TTDPRINT(@"");
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    TTDPRINT(@"");
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    TTDPRINT(@"");
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    TTDPRINT(@"");
    return [_facebook handleOpenURL:url];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// private

/**
 * Show the authorization dialog.
 */
- (void)fbLogin {
    TTDPRINT(@"");
    [_facebook authorize:_permissions];
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)fbLogout {
    TTDPRINT(@"");
    [_facebook logout:self];
}

/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    TTDPRINT(@"");
    isLoggedIn = @"YES";
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/user/authenticate", API_DOMAIN, API_ROUTE];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:_facebook.accessToken forKey:@"facebook_token"];
    [request setPostValue:_facebook.expirationDate forKey:@"expiration_date"];
    [request startSynchronous];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    _currentUser = [[[[jsonKitDecoder parseJSONData:request.responseData] objectForKey:@"data"] copy] retain];

    TTDPRINT(@"%@", _facebook.accessToken);
    TTDPRINT(@"%@", request.responseString);
    TTDPRINT(@"%@",request.responseStatusMessage); // [TODO] Async requests
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
    TTDPRINT(@"");
    NSLog(@"did not login");
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    TTDPRINT(@"");
    isLoggedIn = @"NO";
}

@end
