//
//  StandardSearchController.m
//  cloudbot-ios-q
//
//  Created by Blaine on 7/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StandardSearchController.h"
#import "StandardSearchDataSource.h"
#import "DataModel.h"

#import "MockDataSource.h"

@implementation StandardSearchController

@synthesize urlFormat,searchType,useLocation,remotePath,locationManager,bestEffortAtLocation;

//////////////////////////////////////////////////////////////////////////////////////////
/// Methods for displaying in the navigation heirarchy

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        TTDPRINT(@"");
        StandardSearchDataSource* ds = [StandardSearchDataSource dataSourceWithObjects:nil];
        [ds setModel:[[[DataModel alloc] init] autorelease]];
        
        // By setting the dataSource property, the model property for this
        // class (StandardSearchController) will automatically be hooked up 
        // to point at the same model that the dataSource points at, 
        // which we just instantiated above.
        self.dataSource = ds;
    }
    return self;
}

//  It seems initWithNibName gets called from TTNavigator first then initWithUrl.
//  The problem is initWithNibName sets our datasource, but not the url format and type. Requires further debugging. [TODO]
- (id)initWithUrl:(NSString *)urlStr type:(NSString *)typeStr location:(id)locationObj remote:(NSString *)remoteStr {
    if (self = [super init]) {
//        if (urlStr) {
//            if ([urlStr isEqualToString:@"no"]) {
//                // NO uses no URL, nil uses default url
//                self.urlFormat = NO;
//            } else {
//                // Custom url [TODO] look into encoding
//                self.urlFormat = [[NSString stringWithFormat:@"cb://%@",
//                                   [urlStr stringByReplacingOccurrencesOfString:@"@"
//                                                                     withString:@"/"]] stringByAppendingString:@"/%@"];
//            }
//        } else {
//            self.urlFormat = nil;
//        }
        self.urlFormat = NO;
        
        self.searchType = typeStr;
        if (locationObj) {
            self.useLocation = YES;
            
            // Create the manager object
            self.locationManager = [[[CLLocationManager alloc] init] autorelease];
            locationManager.delegate = self;
            // This is the most important property to set for the manager. It ultimately determines how the manager will
            // attempt to acquire location and thus, the amount of power that will be consumed.
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
            // Once configured, the location manager must be "started".
            [locationManager startUpdatingLocation];
        } else {
            self.useLocation = NO;
        }
        self.remotePath = remoteStr;
        
        self.searchType = typeStr;
        [(id<DataModel>)[[self dataSource] model] setSearchType:self.searchType];
        [self reload]; // hack

    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)dictionary {
    TTDPRINT(@"");
    // Translate url, type, location, remote
    return [self initWithUrl:[dictionary objectForKey:@"url"]
                        type:[dictionary objectForKey:@"type"]
                    location:[dictionary objectForKey:@"location"]
                      remote:[dictionary objectForKey:@"remote"]];
}

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
    return [self initWithDictionary:query];
}

- (void)loadView
{
    TTDPRINT(@"");
    [super loadView];
        
    // Create the tableview.
    self.view = [[[UIView alloc] initWithFrame:TTApplicationFrame()] autorelease];
    self.tableView = [[[UITableView alloc] initWithFrame:TTApplicationFrame() style:UITableViewStylePlain] autorelease];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    // Add search bar to top of screen.
//    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 0.f, TTApplicationFrame().size.width, TT_ROW_HEIGHT)];
//    searchBar.delegate = self;
//    searchBar.placeholder = @"Search";
//    self.navigationItem.titleView = searchBar;
//    [searchBar release];
}

/// Methods for displaying in the navigation heirarchy
//////////////////////////////////////////////////////////////////////////////////////////
/// Location

/*
 * We want to get and store a location measurement that meets the desired accuracy. For this example, we are
 *      going to use horizontal accuracy as the deciding factor. In other cases, you may wish to use vertical
 *      accuracy, or both together.
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    TTDPRINT(@"");
    // store all of the measurements, just so we can see what kind of data we might receive
//    [locationMeasurements addObject:newLocation];
    // test the age of the location measurement to determine if the measurement is cached
    // in most cases you will not want to rely on cached measurements
    NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
    if (locationAge > 5.0) return;
    // test that the horizontal accuracy does not indicate an invalid measurement
    if (newLocation.horizontalAccuracy < 0) return;
    // test the measurement to see if it is more accurate than the previous measurement
    if (bestEffortAtLocation == nil || bestEffortAtLocation.horizontalAccuracy > newLocation.horizontalAccuracy) {
        // store the location as the "best effort"
        self.bestEffortAtLocation = newLocation;
        // test the measurement to see if it meets the desired accuracy
        //
        // IMPORTANT!!! kCLLocationAccuracyBest should not be used for comparison with location coordinate or altitidue 
        // accuracy because it is a negative value. Instead, compare against some predetermined "real" measure of 
        // acceptable accuracy, or depend on the timeout to stop updating. This sample depends on the timeout.
        //
        if (newLocation.horizontalAccuracy <= locationManager.desiredAccuracy) {
            // we have a measurement that meets our requirements, so we can stop updating the location
            // 
            // IMPORTANT!!! Minimize power usage by stopping the location manager as soon as possible.
            //
            [self stopUpdatingLocation];
            // we can also cancel our previous performSelector:withObject:afterDelay: - it's no longer necessary
//            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopUpdatingLocation:) object:nil];
        }
    }
    [self.dataSource location:bestEffortAtLocation];
    // update the display with the new location data
//    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    TTDPRINT(@">>>ERR<<<");
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a 
    // timeout that will stop the location manager to save power.
    if ([error code] != kCLErrorLocationUnknown) {
        [self stopUpdatingLocation];
    }
}

- (void)stopUpdatingLocation {
    TTDPRINT(@"");
//    self.stateString = state;
    [self.tableView reloadData];
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
//    [self.dataSource location:bestEffortAtLocation];
    
//    UIBarButtonItem *resetItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Reset", @"Reset") style:UIBarButtonItemStyleBordered target:self action:@selector(reset)] autorelease];
//    [self.navigationItem setLeftBarButtonItem:resetItem animated:YES];;
}

/// Location
//////////////////////////////////////////////////////////////////////////////////////////
/// Always useful
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    TTDPRINT(@"Selected '%d'",indexPath);
//}
//
//- (void)didSelectObject:(id)object atIndexPath:(NSIndexPath*)indexPath {
//    TTDPRINT(@"√");
//}
//

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    TTDPRINT(@"");
    [self.dataSource search:searchText];
}
// Forces a search server-side
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    TTDPRINT(@"√");
//  Configure our TTModel with the user's search terms
//  and tell the TTModelViewController to reload.
    [searchBar resignFirstResponder];
    [(id<DataModel>)self.model setSearchTerms:[searchBar text]];
    [self reload];
    [self.tableView scrollToTop:YES];
}

/// Always useful
//////////////////////////////////////////////////////////////////////////////////////////

@end
