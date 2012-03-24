//
//  ViewController.h
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20UI/UIViewAdditions.h>

#import "FBLoginButton.h"
#import "AppDelegate.h"

@interface HomeController : TTViewController {
    NSTimer* _sendTimer;
    
    IBOutlet UILabel* _label;
    IBOutlet FBLoginButton* _fbButton;
    UIButton* button1;
    UIButton* button2;
    UIButton* button3;
    BOOL isLoggedIn;
    TTImageView* profileImage;
    
    NSArray* _permissions;
    AppDelegate* _appDelegate;
    
}


- (void)refreshView;

@end
