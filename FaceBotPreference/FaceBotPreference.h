//
//  FaceBotPreference.h
//  FaceBotPreference
//
//  Created by Sang-jun Jung on 13. 1. 10..
//  Copyright (c) 2013년 Sang-jun Jung. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import <CoreFoundation/CoreFoundation.h>

#define FACETIME_AUTO_ACCEPT        "AutoAcceptInvites"
#define FACETIME_AUTO_ACCEPT_FROM   "AutoAcceptInvitesFrom"
#define FF_PREFPANE_BUNDLE_IDENTIFIER @"com.bandoche.FaceBotPreference"


@interface FaceBotPreference : NSPreferencePane <NSTableViewDelegate> {
    CFStringRef appID;
    CFStringRef appIDFaceTime;
    NSString *addressFromId;
    NSMutableArray *addressFromList;
}

@property (nonatomic, strong) IBOutlet NSButton *flagAutoAnswer;
@property (nonatomic, strong) IBOutlet NSTableView *addressTable;
@property (nonatomic, strong) IBOutlet NSTableColumn *nameField, *contactField;
@property (nonatomic, strong) IBOutlet NSTextField *inputContact;

- (void)mainViewDidLoad;

- (void)readSettings;

- (IBAction)addAddress:(id)sender;
- (IBAction)removeAddress:(id)sender;
- (IBAction)changeAutoStatus:(id)sender;

- (IBAction)visitWebsite:(id)sender;
- (NSString *)bundleVersionNumber;

// tableView
- (id) tableView:(NSTableView *)pTableViewObj objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex;

@end
