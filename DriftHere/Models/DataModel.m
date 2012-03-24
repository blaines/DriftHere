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


static NSString* kUrlFormatForOne = @"http://GLOBAL_DOMAINNAME/v0/contacts/%@.json?auth_token=%@"; // [TODO] search one?
static NSString* kUrlFormatForMany = @"http://GLOBAL_DOMAINNAME/v0/search.json?auth_token=%@";
static NSString* kUrlFormatForGeneric = @"http://GLOBAL_DOMAINNAME/v0/%@?auth_token=%@";


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
        _endpoint = [[NSMutableString stringWithFormat:kUrlFormatForMany, appDelegate.userToken] retain];
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
        _endpoint = [[NSMutableString stringWithFormat:kUrlFormatForMany, appDelegate.userToken] retain];
        
        searchType = typeStr;
    }
    
    return self;    
}

- (id)initWithRoute:(NSString *)routeStr {
    TTDPRINT(@"");
    if (self = [super init]) {
        _resultsPerPage = 10; // ignored
        _page = 1; // ignored
        _result = [[NSMutableArray array] retain];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _endpoint = [[NSMutableString stringWithFormat:kUrlFormatForGeneric, routeStr, appDelegate.userToken] retain];
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
        _endpoint = [[NSMutableString stringWithFormat:kUrlFormatForOne, idStr, appDelegate.userToken] retain];
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
    
    NSMutableString* url = [[_endpoint stringByReplacingOccurrencesOfString:@"GLOBAL_DOMAINNAME" withString:GLOBAL_DOMAINNAME] mutableCopy];
    if(searchTerms) {
        [url appendFormat:@"&name=%@", searchTerms];
    }
    if(_expectOne) {
    } else {
        if(searchType) {
            [url appendFormat:@"&type=%@", searchType];
//            [TODO] [HACK] Actually use location to find venues
            if ([searchType isEqualToString:@"venue"] && searchLocation) {
//                TTDPRINT(@"%f,%f",searchLocation.coordinate.latitude,searchLocation.coordinate.longitude);
                [url appendFormat:@"&ll=%f,%f",searchLocation.coordinate.latitude,searchLocation.coordinate.longitude];
            }
        } else {
            [url appendFormat:@"&type=%@", @"contact"];
        }
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
    NSDictionary *results = [jsonKitDecoder parseJSONData:[request.response data]];
    
//    TTDPRINT(@"%d Results",[results count]);
    
//    if ([NSStringFromClass([results class]) isEqualToString:@"JKDictionary"]) {
    if (_expectOne) {
        // When fetching an ID
        DataObject* object = [[DataObject alloc] init];
        object.name = [NSString stringWithFormat:@"%@",[results objectForKey:@"name"]]; // It is possible to have blank names!
        object.idStr = [results objectForKey:@"_id"];
        object.attributes = [results copy];
        [_result addObject:object];
        TT_RELEASE_SAFELY(object);
    } else {
        // When fetching the index
        for (NSDictionary* result in results) {
            DataObject* object = [[DataObject alloc] init];
            object.name = [NSString stringWithFormat:@"%@",[result objectForKey:@"name"]]; // It is possible to have blank names!
            object.idStr = [result objectForKey:@"_id"];
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
    if (text.length) {
        [self cancel];
        NSMutableArray* _oldResultArray = [[_result copy] autorelease];
        [_result removeAllObjects];

        text = [text lowercaseString];
        for (DataObject* object in _oldResultArray) {
            if ([[object.name lowercaseString] rangeOfString:text].location == 0) {
                TTDPRINT(@"Adding '%@'", object.name);
                [_result addObject:object];
            }
        }
        [_delegates perform:@selector(modelDidFinishLoad:) withObject:self];
        if([_result count] == 0){
            self.searchTerms = text;
            [self load:TTURLRequestCachePolicyDefault more:NO];
        }
    }
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

