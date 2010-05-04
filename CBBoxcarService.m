 //
//  CBBoxcarService.m
//  Caboose
//
//  Created by Steve Streza on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CBBoxcarService.h"
#import "CJSONDeserializer.h"

#define CallDelegateMethod(__sel) do{ if(self.delegate && [(NSObject *)self.delegate respondsToSelector:__sel]) [(NSObject *)self.delegate performSelector:__sel withObject:self]; }while(0)
#define CallDelegateMethodWithObject(__sel,__obj) do{ if(self.delegate && [(NSObject *)self.delegate respondsToSelector:__sel]) [(NSObject *)self.delegate performSelector:__sel withObject:self withObject:(__obj)]; }while(0)

@implementation CBBoxcarService

@synthesize email=_email, password=_password, delegate=_delegate;

#pragma mark CBBoxcarService

-(void)reopenSession{
	[self closeSession];
	[self openSession];
}

-(void)closeSession{
	if(!_boxcarSocket){
		CallDelegateMethod(@selector(boxcarServiceWillDisconnect:));

		[_boxcarSocket close];
		[_boxcarSocket release];
		_boxcarSocket = nil;
	}
}

-(void)openSession{
	CallDelegateMethod(@selector(boxcarServiceWillConnect:));

	_boxcarSocket = [[WebSocket alloc] initWithURLString:@"ws://farm.boxcar.io:8080/websocket" delegate:self];
	[_boxcarSocket open];
}

#pragma mark WebSocketDelegate

- (void)webSocket:(WebSocket*)webSocket didFailWithError:(NSError*)error{
	CallDelegateMethodWithObject(@selector(boxcarService:didFailWithError:), error);
}

- (void)webSocketDidOpen:(WebSocket*)webSocket{
	CallDelegateMethod(@selector(boxcarServiceDidConnect:));
	
	[_boxcarSocket send:[NSString stringWithFormat:
						 @"{"
							@"\"action\": \"login\",",
							@"\"email\": \"%@\",",
							@"\"password\": \"%@\"",
						 @"}", self.email, self.password]];
}

- (void)webSocketDidClose:(WebSocket*)webSocket{
	CallDelegateMethod(@selector(boxcarServiceDidDisconnect:));
}

- (void)webSocket:(WebSocket*)webSocket didReceiveMessage:(NSString*)message{
	NSDictionary *notification = [[CJSONDeserializer deserializer] deserializeAsDictionary:[message dataUsingEncoding:NSUTF8StringEncoding]
																			 error:nil];
	if(notification){
		CallDelegateMethodWithObject(@selector(boxcarService:receivedNotification:), notification);
	}
}

#pragma mark NSObject

-(id)initWithEmail:(NSString *)anEmail password:(NSString *)aPassword{
	if(self = [super init]){
		_email = [anEmail copy];
		_password = [aPassword copy];
		
		[self openSession];
	}
	return self;
}

-(void)dealloc{
	[self closeSession];
	[super dealloc];
}

@end
