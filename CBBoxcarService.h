//
//  CBBoxcarService.h
//  Caboose
//
//  Created by Steve Streza on 5/3/10.
//  Copyright 2010 Villainware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocket.h"

@class CBBoxcarService;

@protocol CBBoxcarDelegate
@optional

-(void)boxcarServiceWillConnect:(CBBoxcarService *)service;
-(void)boxcarServiceDidConnect:(CBBoxcarService *)service;

-(void)boxcarServiceWillDisconnect:(CBBoxcarService *)service;
-(void)boxcarServiceDidDisconnect:(CBBoxcarService *)service;

-(void)boxcarService:(CBBoxcarService *)service didFailWithError:(NSError *)error;
-(void)boxcarService:(CBBoxcarService *)service receivedNotification:(NSDictionary *)notification;

@end


@interface CBBoxcarService : NSObject <WebSocketDelegate> {
	WebSocket *_boxcarSocket;
	
	NSString *_email;
	NSString *_password;
	
	NSString *_appName;
	NSString *_appVersion;
	
	id <CBBoxcarDelegate> _delegate;
}

@property (nonatomic, assign) id <CBBoxcarDelegate> delegate;
@property (nonatomic, readonly) NSString *email;
@property (nonatomic, readonly) NSString *password;

@property (nonatomic, copy) NSString *appName;
@property (nonatomic, copy) NSString *appVersion;

-(id)initWithEmail:(NSString *)anEmail password:(NSString *)aPassword;

-(void)openSession;
-(void)closeSession;
-(void)reopenSession;

//utilities
+ (NSString *)hexStringForData:(NSData *)data;
+ (NSString *)hashForPassword:(NSString *)password;
@end
