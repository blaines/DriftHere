//
//  DataObject.m
//  cloudbot-ios-q
//
//  Created by Blaine on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataObject.h"

@implementation DataObject

@synthesize name        = _name;
@synthesize attributes  = _attributes; // picture_url, email_addresses, phone_numbers, phone_number_count, email_address_count, connectedness, service_count, etc.
@synthesize idStr       = _idStr;

- (void) dealloc {
    TT_RELEASE_SAFELY(_name);
    TT_RELEASE_SAFELY(_attributes);
    TT_RELEASE_SAFELY(_idStr);
    [super dealloc];
}

@end
