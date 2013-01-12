//
//  FaceBotPreference.m
//  FaceBotPreference
//
//  Created by Sang-jun Jung on 13. 1. 10..
//  Copyright (c) 2013년 Sang-jun Jung. All rights reserved.
//

#import "FaceBotPreference.h"

@implementation FaceBotPreference

@synthesize flagAutoAnswer, addressTable, contactField, nameField, inputContact;

- (void)mainViewDidLoad
{
//    NSLog(@"It works!");
    [self readSettings];
}

- (id)initWithBundle:(NSBundle *)bundle
{
//    NSLog(@"initWithBundle works!");
    if ( ( self = [super initWithBundle:bundle] ) != nil ) {
        appID = CFSTR("com.bandoche.FaceBotPreference");
        appIDFaceTime = CFSTR("com.apple.FaceTime");
        addressFromId = @"FaceBotAddressCell";
        addressFromList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)readSettings {
//    NSLog(@"readSettings");
//    CFPreferencesSynchronize(appIDFaceTime, kCFPreferencesAnyUser, kCFPreferencesAnyHost);
    CFPreferencesAppSynchronize(appIDFaceTime);
    
    CFPropertyListRef value;
    CFArrayRef fromList = NULL;


    /* Initialize the checkbox */
    value = CFPreferencesCopyAppValue( CFSTR(FACETIME_AUTO_ACCEPT),  appIDFaceTime );
    if ( value && CFGetTypeID(value) == CFBooleanGetTypeID()  ) {
        [flagAutoAnswer setState:CFBooleanGetValue(value)];
    } else {
        [flagAutoAnswer setState:NO];
    }
    if ( value ) CFRelease(value);
    
    /* Initialize the list field */
    value = CFPreferencesCopyAppValue( CFSTR(FACETIME_AUTO_ACCEPT_FROM),  appIDFaceTime );
    if ( value && CFGetTypeID(value) == CFArrayGetTypeID()  ) {
//        CFArrayGetValues(fromList, CFRangeMake(0, CFArrayGetCount(value)), &value);
        fromList = value;
        [addressFromList addObjectsFromArray:[(NSArray *)fromList mutableCopy]];
//        NSLog(@"readSetting: %ld address(s) found", [addressFromList count]);
    } else {
//        NSLog(@"readSetting: no address list found");
    }
    if ( value ) CFRelease(value);
    
    
}


- (IBAction)addAddress:(id)sender {
//    NSLog(@"addAddress");
    // add to array
    [addressFromList addObject:[inputContact stringValue]];
    [inputContact setStringValue:@""];
    [addressTable reloadData];
    
    // save to plist
    CFArrayRef fromList = CFArrayCreateCopy(kCFAllocatorDefault, (CFArrayRef)addressFromList);
    CFPreferencesSetAppValue( CFSTR(FACETIME_AUTO_ACCEPT_FROM), fromList, appIDFaceTime );
    CFPreferencesAppSynchronize(appIDFaceTime);
}
- (IBAction)removeAddress:(id)sender {
//    NSLog(@"removeAddress");
    if ([[addressTable selectedRowIndexes] count] == 0) {
        return;
    } else {
        [addressFromList removeObjectsAtIndexes:[addressTable selectedRowIndexes]];
        [addressTable reloadData];
        // save to plist
        CFArrayRef fromList = CFArrayCreateCopy(kCFAllocatorDefault, (CFArrayRef)addressFromList);
        CFPreferencesSetAppValue( CFSTR(FACETIME_AUTO_ACCEPT_FROM), fromList, appIDFaceTime );
        CFPreferencesAppSynchronize(appIDFaceTime);
    }
}

- (IBAction)changeAutoStatus:(id)sender {
    if ([flagAutoAnswer state]) {
        CFPreferencesSetAppValue( CFSTR(FACETIME_AUTO_ACCEPT), kCFBooleanTrue, appIDFaceTime );
//        NSLog(@"changeAutoStatus = On");
    }    else {
        CFPreferencesSetAppValue( CFSTR(FACETIME_AUTO_ACCEPT), kCFBooleanFalse, appIDFaceTime );
//        NSLog(@"changeAutoStatus = Off");
    }
    CFPreferencesAppSynchronize(appIDFaceTime);
}


// 사이트 방문
- (IBAction)visitWebsite:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dev.bandoche.com/FaceBot?version=%@", [self bundleVersionNumber]]]];
}


// 버전 반환
- (NSString *)bundleVersionNumber {
    NSString *versionNumber = [[[NSBundle bundleWithIdentifier:
                               FF_PREFPANE_BUNDLE_IDENTIFIER] infoDictionary]\
                             valueForKey:@"CFBundleVersion"];
//    NSLog(@"version: %@", versionNumber);
    return versionNumber;
} 



// tableView

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj {
	return (int)[addressFromList count];
}

- (id) tableView:(NSTableView *)pTableViewObj objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
    if ([[pTableColumn identifier] isEqualToString:@"userName"]) {
        return @"";
    } else if ([[pTableColumn identifier] isEqualToString:@"contact"]) {
        return [addressFromList objectAtIndex:pRowIndex];
    } else {
        return @"";
    }
}

// 편집 안되게
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return NO;
}
@end
