//
//  StandardSearchDataSource.h
//  cloudbot-ios-q
//
//  Description:
//  This is effectively an enchanced StandardDataSource with some additonal methods to support search.
//

#import "DataObject.h"
#import "DataModel.h"
#import <CoreLocation/CoreLocation.h>

@interface StandardSearchDataSource : TTListDataSource {
    NSString* _urlFormat;
}

@property (copy) NSString *urlFormat;

@end