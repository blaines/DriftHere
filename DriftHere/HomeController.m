//
//  ViewController.m
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeController.h"

@implementation HomeController

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _sendTimer = nil;
        
        [[TTNavigator navigator].URLMap from:@"dh://compose?to=(composeTo:)"
                       toModalViewController:self selector:@selector(composeTo:)];
        
        [[TTNavigator navigator].URLMap from:@"dh://post"
                            toViewController:self selector:@selector(post:)];
        
        _permissions =  [[NSArray arrayWithObjects:
                          @"read_stream", @"publish_stream", @"offline_access",nil] retain];
        
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc {
    [[TTNavigator navigator].URLMap removeURL:@"dh://compose?to=(composeTo:)"];
    [[TTNavigator navigator].URLMap removeURL:@"dh://post"];
    [_sendTimer invalidate];
	[super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// UIViewController

- (void)loadView {
    TTDPRINT(@"");
    
    CGRect appFrame = [UIScreen mainScreen].applicationFrame;
    self.view = [[[UIView alloc] initWithFrame:appFrame] autorelease];;
    
    self.navigationBarTintColor = [UIColor colorWithRed:0.65f green:0.61f blue:0.5f alpha:1];

    UIImageView* _background = [[UIImageView alloc] initWithFrame:self.view.bounds];
    _background.image = [UIImage imageNamed: @"Background.png"]; 
    [self.view addSubview:_background];
    
//    For some reason the button doesn't show with the image.
//    FBLoginButton* buttonfb = [FBLoginButton buttonWithType:UIButtonTypeRoundedRect];
//    buttonfb.frame = CGRectMake(20, 20, appFrame.size.width - 40, 50);
//    [self.view addSubview:buttonfb];
//    _fbButton = buttonfb;
    
    profileImage = [[TTImageView alloc] initWithFrame:CGRectMake(110, 30, 100, 100)];
//    profileImage.defaultImage = @"Drift.png";
    [self.view addSubview:profileImage];
    profileImage.hidden = YES;
    
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor colorWithRed:0 green:0.28f blue:0.31f alpha:1] forState:UIControlStateNormal];
    [button1 setTitle:@"Login with facebook" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(fbButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake((320-button1.imageView.image.size.width)/2, 160, button1.imageView.image.size.width, button1.imageView.image.size.height);
    button1.frame = CGRectMake(20, 160, appFrame.size.width - 40, 50);
    [self.view addSubview:button1];
    
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:0 green:0.28f blue:0.31f alpha:1] forState:UIControlStateNormal];
    [button2 setTitle:@"Schedule a meet" forState:UIControlStateNormal];
    [button2 addTarget:@"dh://new_meet" action:@selector(openURL)
     forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(20, button1.bottom + 20, appFrame.size.width - 40, 50);
    [self.view addSubview:button2];
    button2.hidden = YES;

    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor colorWithRed:0 green:0.28f blue:0.31f alpha:1] forState:UIControlStateNormal];
    [button3 setTitle:@"Find a meet" forState:UIControlStateNormal];
    [button3 addTarget:@"dh://find_meet" action:@selector(openURLFromButton:)
      forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(20, button2.bottom + 20, appFrame.size.width - 40, 50);
    [self.view addSubview:button3];
    button3.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name: UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)refreshView {
    TTDPRINT(@"");
    if ([[_appDelegate isLoggedIn] isEqualToString:@"YES"]) {
        [button1 setTitle:[NSString stringWithFormat:@"Logged in as %@",[[_appDelegate.currentUser objectForKey:@"profile"] objectForKey:@"first_name"]] forState:UIControlStateNormal];
        profileImage.urlPath = [NSString stringWithFormat:@"https://graph.facebook.com/me/picture?type=large&access_token=%@",_appDelegate.facebook.accessToken];
        [profileImage reload];
        profileImage.hidden = NO;
        button2.hidden = NO;
        button3.hidden = NO;
    } else {
        [button1 setTitle:@"Login with facebook" forState:UIControlStateNormal];
        profileImage.hidden = YES;
        profileImage.urlPath = @"";
        [profileImage reload];
        button2.hidden = YES;
        button3.hidden = YES;
    }
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return TTIsSupportedOrientation(interfaceOrientation);
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
// IBAction

/**
 * Called on a login/logout button click.
 */
- (void)fbButtonClick {
    TTDPRINT(@"%@",[_appDelegate isLoggedIn]);
    if ([[_appDelegate isLoggedIn] isEqualToString:@"YES"]) {
        [_appDelegate fbLogout];
        [self refreshView];
    } else {
        [_appDelegate fbLogin];
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end