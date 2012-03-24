//
//  Contact.m
//  cloudbot-ios-q
//
//  Created by Blaine on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DataModel.h"
#import "DataObject.h"
#import "JSONKit.h"

//#import <extThree20JSON/extThree20JSON.h>

// Example Response
// http://api.cloudbot.com/v0/contacts.json?auth_token=fNgxhgZyFOO1xuIPTxyQ

// Notes
// %u is unsigned int
// %@ is string

static NSString* kUrlFormatForOne = @"http://drifthere.com/api/meet/get_single_meeting/%@"; // [TODO] search one?
static NSString* kUrlFormatForMany = @"http://drifthere.com/api/meet/get_meetings?latitude=%@&longitude=%@";

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DataModel

@synthesize searchType;
@synthesize searchTerms;
@synthesize searchLocation;
//@synthesize endpoint        = _endpoint;
@synthesize result          = _result;
@synthesize resultsPerPage  = _resultsPerPage;
@synthesize finished        = _finished;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)init {
    TTDPRINT(@"");
    if (self = [super init]) {
        _resultsPerPage = 10; // ignored
        _page = 1; // ignored
        _result = [[NSMutableArray array] retain];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _endpoint = kUrlFormatForMany;
    }
    return self;    
}

- (id)initWithSearchType:(NSString *)typeStr {
    TTDPRINT(@"");
    if (self = [super init]) {
        _resultsPerPage = 10; // ignored
        _page = 1; // ignored
        _result = [[NSMutableArray array] retain];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _endpoint = kUrlFormatForMany;
        
        searchType = typeStr;
    }
    
    return self;    
}

- (id)initWithID:(NSString *)idStr {
    TTDPRINT(@"# '%@'", idStr);
    if (self = [super init]) {
        _resultsPerPage = 10; // ignored
        _page = 1; // ignored
        _result = [[NSMutableArray array] retain];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        _expectOne = YES;
        _endpoint = [[NSMutableString stringWithFormat:kUrlFormatForOne, idStr] retain];
    }
    
    return self;    
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(searchTerms);
    TT_RELEASE_SAFELY(searchType);
    TT_RELEASE_SAFELY(_result);
    TT_RELEASE_SAFELY(_endpoint);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more {
    TTDPRINT(@"");
    //    if (!self.isLoading && TTIsStringWithAnyText(_searchQuery)) {
    if (more) {
        _page++;
    } else {
        _page = 1;
        _finished = NO;
        [_result removeAllObjects];
    }
    
    NSMutableString* url = [_endpoint mutableCopy];
    if(_expectOne) {
    } else {
        url = [NSString stringWithFormat:_endpoint, @"1", @"1"]; // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    }
    
    TTDPRINT(@"%@",url);
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    
    request.cachePolicy = cachePolicy;
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    
    TTURLDataResponse* response = [[TTURLDataResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    
    
    [request send];
    //    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    TTDPRINT(@"");
    
    JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
    NSDictionary *results = [[jsonKitDecoder parseJSONData:[request.response data]] objectForKey:@"data"];
    
//    TTDPRINT(@"%d Results",[results count]);
    
//    if ([NSStringFromClass([results class]) isEqualToString:@"JKDictionary"]) {
    if (_expectOne) {
        // When fetching an ID
        DataObject* object = [[DataObject alloc] init];
        object.title = [NSString stringWithFormat:@"%@",[results objectForKey:@"meet_title"]]; // POSSIBLE BLANK
        object.detail = [NSString stringWithFormat:@"%@",[results objectForKey:@"meet_detail"]]; // POSSIBLE BLANK
        object.idStr = [results objectForKey:@"meet_id"];
        object.attributes = [results copy];
        [_result addObject:object];
        TT_RELEASE_SAFELY(object);
    } else {
        // When fetching the index
        for (NSDictionary* result in results) {
            DataObject* object = [[DataObject alloc] init];
            object.title = [NSString stringWithFormat:@"%@",[result objectForKey:@"meet_title"]]; // POSSIBLE BLANK
            object.detail = [NSString stringWithFormat:@"%@",[result objectForKey:@"meet_detail"]]; // POSSIBLE BLANK
            object.idStr = [result objectForKey:@"meet_id"];
            object.attributes = [result copy];
            [_result addObject:object];
            TT_RELEASE_SAFELY(object);
        }        
    }
    
    [super requestDidFinishLoad:request];
}

- (void)setSearchTerms:(NSString *)theSearchTerms
{
    TTDPRINT(@"§'%@'", theSearchTerms);
    if (![theSearchTerms isEqualToString:searchTerms]) {
        [searchTerms release];
        searchTerms = [theSearchTerms retain];
        //        page = 1;
    }
}

- (void)setSearchType:(NSString *)theSearchType
{
    TTDPRINT(@"§T'%@'", theSearchType);
    if (![theSearchType isEqualToString:searchType]) {
        [searchType release];
        searchType = [theSearchType retain];
        //        page = 1; // Reset page
    }
}

- (NSMutableArray *)results
{
//    TTDPRINT(@"");
    return _result; // Can't be a copy if we're going to permit updates and deletions. [TODO] Ensure a better alternative does not exist.
//    return [[_result copy] autorelease];
}

- (void)search:(NSString*)text {
    TTDPRINT(@"§'%@'", text);
}

- (void)location:(CLLocation*)location {
    TTDPRINT(@"");
    self.searchLocation = location;
    [self load:TTURLRequestCachePolicyDefault more:NO];
}

- (NSMutableArray*)delegates {
    TTDPRINT(@"");
    return [super delegates];
}

- (BOOL)isLoadingMore {
    TTDPRINT(@"");
    return [super isLoadingMore];
}

- (BOOL)isOutdated {
    TTDPRINT(@"");
    return [super isOutdated];
}

- (BOOL)isLoaded {
    TTDPRINT(@"");
    return [super isLoaded];
}

- (BOOL)isLoading {
    TTDPRINT(@"");
    return [super isLoading];
}

- (BOOL)isEmpty {
    TTDPRINT(@"");
    return [super isEmpty];
}

- (BOOL)expectOne {
    TTDPRINT(@"");
    return _expectOne;
}


@end

