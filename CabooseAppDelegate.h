//
//  CabooseAppDelegate.h
//  Caboose
//
//  Created by Steve Streza on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CBBoxcarService.h"

@interface CabooseAppDelegate : NSObject <NSApplicationDelegate, CBBoxcarDelegate> {
    NSWindow *window;

	CBBoxcarService *boxcar;
}

@property (assign) IBOutlet NSWindow *window;

@end
