//
//  Contact.h
//  cloudbot-ios-q
//
//  Created by Blaine on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DataObject.h"
#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>

/*
 * a searchable model which can be configured with a 
 * loading and/or search time
 */


@protocol DataModel <TTModel>
// Will search Nouns instead of the default contacts.
// Default searchType is Contacts - for now
@property (nonatomic, retain) NSString *searchType;
// The keywords that will be submitted to the api in order to do the actual server-side search (e.g. "green apple")
@property (nonatomic, retain) NSString *searchTerms;
// A list of domain objects constructed by the model after parsing the web service's HTTP response. In this case, it is a list of SearchResult objects.
@property (nonatomic, readonly) NSMutableArray *results;                        
// The total number of results available on the server (but not necessarily downloaded) for the current model configuration's search query.
@property (nonatomic, readonly) NSUInteger totalResultsAvailableOnServer;
// A boolean which determines wether the result is an individual record or a set.
@property (nonatomic, readonly) BOOL *expectOne;
- (void)search:(NSString*)text;
- (id)initWithRoute:(NSString *)routeStr;
@end


@interface DataModel : TTURLRequestModel {
    NSString*        searchTerms;
    CLLocation*      searchLocation;
    NSString*        searchType;
    NSString*        _endpoint;
    NSMutableArray*  _result;
    NSUInteger       _page;             // page of search request
    NSUInteger       _resultsPerPage;   // results per page, once the initial query is made
    BOOL _finished;
    BOOL _expectOne;
}

@property (nonatomic, retain)   NSString*       searchType;
@property (nonatomic, retain)   NSString*       searchTerms;
@property (nonatomic, retain)   CLLocation*     searchLocation;
//@property (nonatomic, readonly) NSString*       endpoint;
@property (nonatomic, readonly) NSMutableArray* result;
@property (nonatomic, assign)   NSUInteger      resultsPerPage;
@property (nonatomic, readonly) BOOL            finished;

- (id)initWithSearchType:(NSString*)typeStr;
- (id)initWithID:(NSString*)idStr;
- (id)initWithRoute:(NSString *)routeStr;
- (void)search:(NSString*)text;
- (void)location:(CLLocation*)location;

@end
