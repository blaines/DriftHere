//
//  ShowMeetViewController.m
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ShowMeetViewController.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation ShowMeetViewController

@synthesize profilePhoto, meetingTitle, meetingDistance, meetingDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        TTDPRINT(@"");
    }
    return self;
}

- (void)loadView {
//    self.navigationBarTintColor = [UIColor colorWithRed:0.65f green:0.61f blue:0.5f alpha:1];
    
    
    // load automatically the NIB
    [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner: self options: nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        self.navigationBarTintColor = [UIColor colorWithRed:0.65f green:0.61f blue:0.5f alpha:1];
    
    
    // user = 15
    // meet = 8
    
    
    
    TTDPRINT(@"");
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/meet/get_single_meeting/%@?latitude=1&longitude=1", API_DOMAIN, API_ROUTE, @"10"];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    _currentMeeting = [[[[jsonKitDecoder parseJSONData:request.responseData] objectForKey:@"data"] copy] retain];
    
    [meetingTitle setText:[_currentMeeting objectForKey:@"meet_title"]];
    [meetingDescription setText:[_currentMeeting objectForKey:@"meet_detail"]];
    [meetingDistance setText:[NSString stringWithFormat:@"%@ miles",[_currentMeeting objectForKey:@"distance"]]];
    [meetingTitle setText:[_currentMeeting objectForKey:@"meet_title"]];
    
    
    profilePhoto = [[TTImageView alloc] initWithFrame:CGRectMake(20, 30, 100, 100)];
    //    profilePhoto.defaultImage = @"Drift.png";
    profilePhoto.urlPath = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",@"bschanfeldt"];
//    [profilePhoto reload];
    [self.view addSubview:profilePhoto];
//    profilePhoto.hidden = NO;

    UIButton* button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundImage:[UIImage imageNamed:@"Button.png"] forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor colorWithRed:0 green:0.28f blue:0.31f alpha:1] forState:UIControlStateNormal];
    [button2 setTitle:@"Call" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(makeCall)
      forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(20, 180, 320 - 40, 50);
    [self.view addSubview:button2];

}



- (void)makeCall {
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/call/initiate_call/%@/%@", API_DOMAIN, API_ROUTE, @"15", @"8"];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
////    idStr = [query objectForKey:@"idStr"];
//    TTDPRINT(@"");
//}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
