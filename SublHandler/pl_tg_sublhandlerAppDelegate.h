//
//  pl_tg_sublhandlerAppDelegate.h
//  SublHandler
//
//  Created by Tomasz Gryszkiewicz on 18.02.2014.
//  Copyright (c) 2014 Tomasz Gryszkiewicz. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSURL+L0URLParsing.h"

@interface pl_tg_sublhandlerAppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSMenu *statusMenu;
    NSStatusItem *statusItem;
    NSString *path;
}

@property (assign) IBOutlet NSWindow *window;
@property NSString *path;

- (IBAction)showPrefPanel:(id)sender;
- (NSString *)inputBox:(NSString *)prompt defaultValue: (NSString *)text;
- (IBAction)quitApplication:(id)sender;

@end
