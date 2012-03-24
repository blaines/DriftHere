//
//  DataObject.h
//  cloudbot-ios-q
//
//  Created by Blaine on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Three20/Three20.h>

@interface DataObject : NSObject {
    NSString* _name;
    NSDictionary* _attributes;
    NSString* _idStr;
}

@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSDictionary* attributes;
@property (nonatomic, copy) NSString* idStr;

@end
