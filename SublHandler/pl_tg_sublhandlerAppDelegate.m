//
//  pl_tg_sublhandlerAppDelegate.m
//  SublHandler
//
//  Created by Tomasz Gryszkiewicz on 18.02.2014.
//  Copyright (c) 2014 Tomasz Gryszkiewicz. All rights reserved.
//

#import "pl_tg_sublhandlerAppDelegate.h"

NSString *defaultPath = @"/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl";

@implementation pl_tg_sublhandlerAppDelegate

@synthesize path;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(void)awakeFromNib{
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    [statusItem setTitle:@"S"];
    // Add a nice image, if you can draw
    // [statusItem setImage:image];
    // [statusItem setAlternateImage:image];
    [statusItem setHighlightMode:YES];

    NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
    path = [d objectForKey:@"path"];
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];
    [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
}

-(void)handleGetURLEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    if (nil == path) path = defaultPath;
    
    // txmt://open/?url=file://~/.bash_profile&line=11&column=2
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
    
    if (url && [[url host] isEqualToString:@"open"]) {
        NSDictionary *params = [url dictionaryByDecodingQueryString];
        NSString* url  = [params objectForKey:@"url"];
        if (url) {
            NSString *file = [url stringByReplacingOccurrencesOfString:@"file://" withString: @""];
            NSString *line = [params objectForKey:@"line"];
            NSString *arg = nil;
            if (line) {
                arg = [NSString stringWithFormat:@"%@:%@", file, line];
            } else {
                arg = [NSString stringWithFormat:@"%@", file];
            }
            
            NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:path];
            [task setArguments:[NSArray arrayWithObjects:arg, nil]];
            [task launch];
            NSWorkspace *sharedWorkspace = [NSWorkspace sharedWorkspace];
            NSString *appPath = [sharedWorkspace fullPathForApplication:@"Sublime Text 2"];
            NSString *identifier = [[NSBundle bundleWithPath:appPath] bundleIdentifier];
            NSArray *selectedApps =
            [NSRunningApplication runningApplicationsWithBundleIdentifier:identifier];
            NSRunningApplication *runningApplcation = (NSRunningApplication*)[selectedApps objectAtIndex:0];
            [runningApplcation activateWithOptions: NSApplicationActivateAllWindows];
            //[runningApplcation setCollectionBehavior: NSWindowCollectionBehaviorMoveToActiveSpace];
        }
    }
}

-(IBAction)showPrefPanel:(id)sender {
    if (nil == path) path = defaultPath;
    NSString *p=[self inputBox:@"Set the path to subl command line" defaultValue: path];
    if (p) {
        path = p;
        NSUserDefaults *d = [NSUserDefaults standardUserDefaults];
        [d setObject:path forKey:@"path"];
    }
}

- (NSString *)inputBox: (NSString *)prompt defaultValue: (NSString *)text {
    NSAlert *alert = [NSAlert alertWithMessageText: prompt
                                     defaultButton:@"OK"
                                   alternateButton:@"Cancel"
                                       otherButton:nil
                         informativeTextWithFormat:@""];
    
    NSTextField *input = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 500, 24)];
    [input setStringValue: text];
    [alert setAccessoryView:input];
    NSInteger button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        [input validateEditing];
        return [input stringValue];
    }
    else if (button == NSAlertAlternateReturn) {
        return nil;
    }
    else {
        return nil;
    }
}

-(IBAction)quitApplication:(id)sender {
    [NSApp terminate:self];
}

@end
