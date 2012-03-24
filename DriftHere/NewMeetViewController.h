//
//  NewMeetViewController.h
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface NewMeetViewController : TTViewController {
    UITextField* meetingTitle;
    UITextView* meetingDescription;
    
    AppDelegate* _appDelegate;
}

@property (nonatomic, retain) IBOutlet UITextField *meetingTitle;
@property (nonatomic, retain) IBOutlet UITextView *meetingDescription;

@end
