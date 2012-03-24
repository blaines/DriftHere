//
//  DataObject.m
//  cloudbot-ios-q
//
//  Created by Blaine on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataObject.h"

@implementation DataObject

@synthesize title        = _title;
@synthesize detail        = _detail;
@synthesize attributes  = _attributes;
@synthesize idStr       = _idStr;

- (void) dealloc {
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_detail);
    TT_RELEASE_SAFELY(_attributes);
    TT_RELEASE_SAFELY(_idStr);
    [super dealloc];
}

@end
