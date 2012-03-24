//
//  ShowMeetViewController.h
//  DriftHere
//
//  Created by Blaine on 8/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface ShowMeetViewController : TTViewController {
    NSDictionary* _currentMeeting;
    
    TTImageView* profilePhoto;
    UILabel* meetingTitle;
    UILabel* meetingDistance;
    UILabel* profileName;
    UITextView* meetingDescription;
    
    
    NSString* idStr;

}

@property (nonatomic, retain) IBOutlet TTImageView* profilePhoto;
@property (nonatomic, retain) IBOutlet UILabel* meetingTitle;
@property (nonatomic, retain) IBOutlet UILabel* profileName;
@property (nonatomic, retain) IBOutlet UILabel* meetingDistance;
@property (nonatomic, retain) IBOutlet UITextView* meetingDescription;

@end
