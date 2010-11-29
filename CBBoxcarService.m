 //
//  CBBoxcarService.m
//  Caboose
//
//  Created by Steve Streza on 5/3/10.
//  Copyright 2010 Villainware. All rights reserved.
//

#import "CBBoxcarService.h"
#import "CJSONDeserializer.h"

#include <openssl/md5.h>

#define CallDelegateMethod(__sel) do{ if(self.delegate && [(NSObject *)self.delegate respondsToSelector:__sel]) [(NSObject *)self.delegate performSelector:__sel withObject:self]; }while(0)
#define CallDelegateMethodWithObject(__sel,__obj) do{ if(self.delegate && [(NSObject *)self.delegate respondsToSelector:__sel]) [(NSObject *)self.delegate performSelector:__sel withObject:self withObject:(__obj)]; }while(0)

@implementation CBBoxcarService

@synthesize email=_email, password=_password, appName=_appName, appVersion=_appVersion, delegate=_delegate;

#pragma mark Utilities

+ (NSString *) hexStringForData:(NSData *)inData {
	const char * data = [inData bytes];
	NSMutableString *result;
	NSString *immutableResult;
	
	// Iterate through NSData's buffer, converting every byte into hex
	// and appending the result to a string.
	result = [[NSMutableString alloc] init];

	int i;
	for (i = 0; i < [inData length]; i++) {
		[result appendFormat:@"%02x", data[i] & 0xff];
	}
	
	immutableResult = [NSString stringWithString:result];
	[result release];
	return immutableResult;
}

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
	
	NSString *message = [NSString stringWithFormat:
						 @"{"
							@"\"app_name\": \"%@\", "
							@"\"app_ver\": \"%@\", "
							@"\"username\": \"%@\", "
							@"\"password\": \"%@\""
						 @"}", self.appName, self.appVersion, self.email, [[self class] hashForPassword:self.password]];
	
	NSLog(@"Sending socket message: %@", message);
	[_boxcarSocket send:message];
}

+(NSString *)hashForPassword:(NSString *)password{
	NSData *data = [password dataUsingEncoding:NSUTF8StringEncoding];
	void *md5 = MD5([data bytes], [data length], NULL);
	NSData *hashData = [NSData dataWithBytes:md5 length:MD5_DIGEST_LENGTH];
	return [self hexStringForData:hashData];
}

- (void)webSocketDidClose:(WebSocket*)webSocket{
	CallDelegateMethod(@selector(boxcarServiceDidDisconnect:));
}

- (void)webSocket:(WebSocket*)webSocket didReceiveMessage:(NSString*)message{
	NSDictionary *notification = [[CJSONDeserializer deserializer] deserializeAsDictionary:[message dataUsingEncoding:NSUTF8StringEncoding]
																			 error:nil];
	NSLog(@"Received socket object: %@", notification);
	if(notification){
		CallDelegateMethodWithObject(@selector(boxcarService:receivedNotification:), notification);
	}
}

-(NSString *)appName{
	return (_appName ? _appName : @"Caboose");
}

-(NSString *)appVersion{
	return (_appVersion ? _appVersion : @"1.0");
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
