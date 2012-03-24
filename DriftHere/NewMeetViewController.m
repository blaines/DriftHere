//
//  NewMeetViewController.m
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NewMeetViewController.h"

@implementation NewMeetViewController

@synthesize meetingTitle, meetingDescription;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return self;
}

- (void)loadView {
    self.navigationBarTintColor = [UIColor colorWithRed:0.65f green:0.61f blue:0.5f alpha:1];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(post)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    // load automatically the NIB
    [[NSBundle mainBundle] loadNibNamed: NSStringFromClass([self class]) owner: self options: nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)post
{
    TTDPRINT(@"");
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/meet/add_meeting", API_DOMAIN, API_ROUTE];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[_appDelegate.currentUser objectForKey:@"user_id"] forKey:@"user_id"];
    [request setPostValue:meetingTitle.text forKey:@"meet_title"];
    [request setPostValue:meetingDescription.text forKey:@"meet_detail"];
    [request setPostValue:@"37.0625" forKey:@"latitude"];
    [request setPostValue:@"-95.677068" forKey:@"longitude"];
    [request startSynchronous];
//    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    TTDPRINT(@"%@", request.responseString);

//    [_appDelegate.currentUser objectForKey:@"profile"]
    [self.navigationController popViewControllerAnimated:YES];
    TTDPRINT(@"%@ %@", meetingTitle.text, meetingDescription.text);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
