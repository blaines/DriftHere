//
//  StandardSearchController.h
//  cloudbot-ios-q
//
//  Created by Blaine on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Three20/Three20.h>
#import <CoreLocation/CoreLocation.h>

@interface StandardSearchController : TTTableViewController <TTTableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate> {
    NSString*   urlFormat;
    NSString*   searchType;
    BOOL        useLocation;
    NSString*   remotePath;
    
    CLLocationManager *locationManager;
    CLLocation *bestEffortAtLocation;
}

- (id)initWithUrl:(NSString *)urlStr type:(NSString *)typeStr location:(id)useLocation remote:(NSString *)remotePath;
- (id)initWithDictionary:(NSDictionary*)dictionary;

@property (copy)                 NSString*   urlFormat;
@property (copy)                 NSString*   searchType;
@property (nonatomic, readwrite) BOOL        useLocation;
@property (copy)                 NSString*   remotePath;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation *bestEffortAtLocation;

@end
