//
//  ActionSchema.h
//  cloudbot-ios-q
//
//  Created by Blaine on 7/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActionSchema : NSObject {
    NSString *name;
    NSDictionary *schema;
    NSArray *aliases;
    NSString *description;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDictionary *schema;
@property (nonatomic, assign) NSArray *aliases;
@property (nonatomic, retain) NSString *description;

+ (NSArray *)initAll;
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
