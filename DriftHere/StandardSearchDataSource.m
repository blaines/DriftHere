//
//  StandardSearchDataSource.h
//  cloudbot-ios-q
//
//  Description:
//  This is effectively an enchanced StandardDataSource with some additonal methods to support search.
//

#import "StandardSearchDataSource.h"

@implementation StandardSearchDataSource

@synthesize urlFormat = _urlFormat;

static NSString* kDefaultUrlFormat = @"cb://contact/%@";

- (void)tableViewDidLoadModel:(UITableView *)tableView {
    TTDPRINT(@"");
    [super tableViewDidLoadModel:tableView];
    
//    TTDPRINT(@"Removing all objects in the table view.");
    [self.items removeAllObjects];
//    [self.sections removeAllObjects];
    self.items = [NSMutableArray array];
//    self.sections = [NSMutableArray array];

    NSMutableDictionary* groups = [NSMutableDictionary dictionary];
    
    if ([(id<DataModel>)self.model expectOne]) {
//      When fetching an ID
        
//        DataObject* contact = [[(id<DataModel>)self.model results] objectAtIndex:0];
//        
//        [_sections addObject:contact.name];
//        [_items addObject:[NSMutableArray array]];
//        
//        
//        NSMutableArray* section = [NSMutableArray array];
//        for (NSString* phone_number in [contact.attributes valueForKey:@"phone_numbers"]) {
//            NSMutableString* sanitized_phone_number = [NSMutableString stringWithCapacity:phone_number.length];
//            for (int i=0; i<[phone_number length]; i++) {
//                if (isalnum([phone_number characterAtIndex:i])) {
//                    [sanitized_phone_number appendFormat:@"%c",[phone_number characterAtIndex:i]];
//                }
//            }
//            TTTableCaptionItem* tci = [TTTableCaptionItem itemWithText:phone_number
//                                                               caption:@"mobile"
//                                                                   URL:[NSString stringWithFormat:@"cb://sms_or_tel_action/%@",sanitized_phone_number]];
//            [section addObject:tci];
//        }
//        [_sections addObject:@"Phone Numbers"];
//        [_items addObject:section];
//        
//        
//        section = [NSMutableArray array];
//        for (NSString* email_address in [contact.attributes valueForKey:@"email_addresses"]) {
//            TTTableCaptionItem* tci = [TTTableCaptionItem itemWithText:email_address
//                                                               caption:@"home"
//                                                                   URL:[NSString stringWithFormat:@"mailto://%@",email_address]];
//            [section addObject:tci];
//        }
//        [_sections addObject:@"Email Addresses"];
//        [_items addObject:section];
//
//
//        section = [NSMutableArray array];
//        TTTableCaptionItem* tci;
//        for (NSString* service in [contact.attributes valueForKey:@"contact_services"]) {
//            // [TODO] hackety hack :) probably want to move this entire build process to some other class...
//            if ([[service valueForKey:@"service_type"] isEqualToString:@"twitter"]) {
//                tci = [TTTableCaptionItem itemWithText:[NSString stringWithFormat:@"%@",[service valueForKey:@"service_screen_name"]]
//                                               caption:[service valueForKey:@"service_type"]
//                                                   URL:[NSString stringWithFormat:@"cb://dm_or_reply_action/%@/%@", contact.idStr, [service valueForKey:@"service_screen_name"]]];
//            } else {
//                tci = [TTTableCaptionItem itemWithText:[NSString stringWithFormat:@"%@",[service valueForKey:@"service_screen_name"]]
//                                                                   caption:[service valueForKey:@"service_type"]];
//            }
//            [section addObject:tci];
//        }
//        [_sections addObject:@"Connected Services"];
//        [_items addObject:section];
        
    } else {
//      When fetching an index
//          Construct an object that is suitable for the table view system
//          from each SearchResult domain object that we retrieve from the TTModel.
        
        for (DataObject *result in [(id<DataModel>)self.model results]) {
//            NSString* letter = [NSString stringWithFormat:@"%C", [result.title characterAtIndex:0]];
//            NSMutableArray* section = [groups objectForKey:letter];
//            if (!section) {
//                section = [NSMutableArray array];
//                [groups setObject:section forKey:letter];
//            }
            
            // Supports default navigation, no navigation (NO), or custom navigation

            
            TTDPRINT(@"**>> The IDSTR is: '%@'", result.idStr);
            
            TTTableItem* item = [TTTableTextItem itemWithText:result.title URL:[NSString stringWithFormat:@"dh://show_meet?idStr=%@",result.idStr]];

//            TTTableItem* item = [TTTableImageItem itemWithText:result.title imageURL:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large",[result.attributes objectForKey:@"user_name"]] defaultImage:@"Icon.png" URL:[NSString stringWithFormat:@"dh://show_meet?idStr=",result.idStr]];
            [_items addObject:item];
//            [section addObject:item];
        }
        
//        NSArray* letters = [groups.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
//        for (NSString* letter in letters) {
//            NSArray* items = [groups objectForKey:letter];
//            [_sections addObject:letter];
//            [_items addObject:items];
//        }
    }
    
//    TTDPRINT(@"Added %lu search result objects", (unsigned long)[self.items count]);
}
////////////////////////////////////////////////////////////////////////////////////
// Right side section index

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView {
            return nil;
    if ([(id<DataModel>)self.model expectOne]) {
        return nil;
    } else {
        return [TTTableViewDataSource lettersForSectionsWithSearch:NO summary:YES];
    }
}

// Right side section index
////////////////////////////////////////////////////////////////////////////////////
// Search support

- (void)search:(NSString*)text {
    TTDPRINT(@"§'%@'", text);
    [(id<DataModel>)self.model search:text];
}

- (void)location:(CLLocation*)location {
    TTDPRINT(@"§'%@'", location);
    [(id<DataModel>)self.model location:location];
}

// Search support
////////////////////////////////////////////////////////////////////////////////////
#pragma mark TTTableViewDataSource protocol

- (UIImage*)imageForEmpty {
	return [UIImage imageNamed:@"Three20.bundle/images/empty.png"];
}

- (UIImage*)imageForError:(NSError*)error {
    return [UIImage imageNamed:@"Three20.bundle/images/error.png"];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void) dealloc {
    TT_RELEASE_SAFELY(_urlFormat);
    [super dealloc];
}

@end