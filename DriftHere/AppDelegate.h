//
//  AppDelegate.h
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "ASIFormDataRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, 
                                      FBRequestDelegate,
                                      FBDialogDelegate,
                                      FBSessionDelegate> 
{
    Facebook*   _facebook;
    NSArray*    _permissions;
    NSString*        _isLoggedIn; // SO LAME BOOL FAILS
    NSDictionary* _currentUser;
//    NSDictionary* _currentUserToken;
}

@property (nonatomic, retain) NSString *isLoggedIn;
@property (nonatomic, retain) NSDictionary *currentUser;
@property (strong, nonatomic) UIWindow *window;
@property (readonly) Facebook *facebook;

- (void) fbLogin;
- (void) fbLogout;

@end
