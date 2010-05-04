//
//  CabooseAppDelegate.m
//  Caboose
//
//  Created by Steve Streza on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CabooseAppDelegate.h"
#import <Growl/Growl.h>

@implementation CabooseAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[GrowlApplicationBridge setGrowlDelegate:self];
	
	NSString *email = [[NSUserDefaults standardUserDefaults] objectForKey:@"boxcarEmail"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"boxcarPassword"];
	
	if(email == nil || password == nil){
		NSAlert *alert = [NSAlert alertWithMessageText:@"No email or password" 
										 defaultButton:@"OK"
									   alternateButton:nil
										   otherButton:nil
							 informativeTextWithFormat:@"To enable, run in Terminal:\n\n"
						  @"defaults write com.villainware.caboose boxcarEmail john@example.com\n"
						  @"defaults write com.villainware.caboose boxcarPassword myPassword"];
		[alert runModal];
		
		[NSApp terminate:self];
	}

	boxcar = [[CBBoxcarService alloc] initWithEmail:email
										   password:password];
	boxcar.delegate = self;
}

-(void)boxcarService:(CBBoxcarService *)service receivedNotification:(NSDictionary *)notification{
	[GrowlApplicationBridge notifyWithTitle:@"Caboose"
								description:[notification objectForKey:@"alert"]
						   notificationName:@"PushNotification" 
								   iconData:nil
								   priority:0
								   isSticky:NO 
							   clickContext:nil];
}

@end
