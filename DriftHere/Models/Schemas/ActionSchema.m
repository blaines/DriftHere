//
//  ActionSchema.m
//  cloudbot-ios-q
//
//  Created by Blaine on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// http://api.cloudbot.com/v0/timelines?auth_token=fNgxhgZyFOO1xuIPTxyQ

#import "AppDelegate.h"
#import "ActionSchema.h"
#import "JSONKit.h"

@implementation ActionSchema

@synthesize name;
@synthesize schema;
@synthesize aliases;
@synthesize description;

+ (NSArray *)initAll
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString *urlString = [NSString stringWithFormat:@"http://%@/%@/actions.json?auth_token=%@", GLOBAL_DOMAINNAME, GLOBAL_API_VERSION, appDelegate.userToken];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //TODO: fix that: error = nil
    NSData *jsonData = [NSData dataWithContentsOfURL:url];
    if(jsonData) {
        JSONDecoder *jsonKitDecoder = [JSONDecoder decoder];
        NSDictionary *results = [jsonKitDecoder parseJSONData:jsonData];
        
        TTDPRINT(@"Total Results %d", [results count]);
        
        NSMutableArray *resultsAsArray = [[NSMutableArray alloc] init];
		if (results) {
            for (NSDictionary *dictionary in results) {
                ActionSchema *newActionSchema = [[ActionSchema alloc] initWithDictionary:dictionary];
                [resultsAsArray addObject:newActionSchema];
            }
		} else {
			NSLog(@"No response. No Internet??");
		}
        
        return resultsAsArray;
    } else {
        return NO;
    }
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        name = [[dictionary objectForKey:@"name"] retain];
        schema = [[dictionary objectForKey:@"schema"] retain];
        aliases = [[dictionary objectForKey:@"aliases"] retain];
        description = [[dictionary objectForKey:@"guide"] retain]; // [TODO] change guide to description on server
    }
    return self;
}
@end
