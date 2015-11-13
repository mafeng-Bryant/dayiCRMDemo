//
//  Loader.m
//  lib_net
//
//  Created by lyq on 11-6-8.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import "RRLoader.h"
#import "RRURLRequest.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "RRToken.h"

static NSMutableSet			*bind_loaders = nil;


@implementation RRLoader

@synthesize conn;
@synthesize buff;
@synthesize info;
@synthesize time_interval;


#pragma mark -
#pragma mark binds array
+ (NSUInteger) count
{
	return [bind_loaders count];
}

#pragma mark Construction

- (id) init
{
	self = [super init];
	
	if (self)
	{
		if (buff)
		{
			buff = nil;
		}
		buff = [[NSMutableData alloc] init];
	}
	
	return self;
}

- (id) initWithRequest: (RRURLRequest *)request
{
	self = [self init];
	
	if (self)
	{
		[request setupHttpBody];
		conn = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
	}
	
	return self;
}

- (void) dealloc
{
	[timer invalidate];
	timer = nil;
}

#pragma mark -
#pragma mark Instance Mehtod

- (void) load
{
	if (nil == conn)
	{
		return;
	}
	
	if (0 < time_interval)
	{
		[timer invalidate];
		timer = nil;
		
		timeout_count = 0;
		
		timer = [NSTimer timerWithTimeInterval:30.0f
										target:self
									  selector:@selector(onTimeout:)
									  userInfo:nil
									   repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	}
	
	[conn start];
}

- (void) loadwithTimer
{
	if (nil == conn)
	{
		return;
	}
	
	[timer invalidate];
	timer = nil;
	
	timeout_count = 0;
	
	timer = [NSTimer timerWithTimeInterval:30.0f
									target:self
								  selector:@selector(onTimeout:)
								  userInfo:nil
								   repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
	
	[conn start];
}

- (void) loadWithoutTimer
{	
	if (nil == conn)
	{
		return;
	}
	
	time_interval = -1;
	
	[conn start];
}

- (void) cancel
{
	[timer invalidate];
	timer = nil;
	
	timeout_count = 0;
	
	[conn cancel];
}

#pragma mark -

- (NSString *) getStringData
{
	NSString *s = [[NSString alloc] initWithData:buff encoding:NSUTF8StringEncoding];
	return s;
}

- (id) getJSONData
{
	NSString *s = [[NSString alloc] initWithData:buff encoding:NSUTF8StringEncoding];
	return [s JSONValue];
}

#pragma mark -
#pragma mark timer

- (void) onTimeout:(NSTimer*)theTimer
{
	timeout_count++;
	
	[timer invalidate];
	timer = nil;
	
	if (2 > timeout_count)
	{
		timer = [NSTimer timerWithTimeInterval:90.0f
										target:self
									  selector:@selector(onTimeout:)
									  userInfo:nil
									   repeats:NO];
		[[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
		
		NSError *err = [NSError errorWithDomain:@"RRLoader" code:-101 userInfo:nil];
		[self connection:nil didFailWithError:err];
		
		return;
	}
	
	NSError *err = [NSError errorWithDomain:@"RRLoader" code:-102 userInfo:nil];
	[self connection:nil didFailWithError:err];
}

#pragma mark -
#pragma mark NotificationListener

- (void) addNotificationListener:(NSString *)notificationName target:(id)target action:(SEL)action
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center addObserver:target selector:action name:notificationName object:self];
}

- (void) addNotificationListener:(NSString *)notificationName target:(id)target action:(SEL)action object:(id)object forKey:(id)akey
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center addObserver:target selector:action name:notificationName object:self];
}

- (void) removeNotificationListener:(NSString *)notificationName target:(id)target
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center removeObserver:target name:notificationName object:self];
}

- (void) removeNotificationListener:(NSString *)notificationName target:(id)target forKey:(id)aKey
{
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	[center removeObserver:target name:notificationName object:self];
}

#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
//    NSHTTPURLResponse *resp = (NSHTTPURLResponse*)aResponse;
//	
//	http_status_code = [resp statusCode];
//    
//	NSDictionary *dict = [NSDictionary dictionaryWithObject:resp forKey:@"data"];
//	
//	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//	[center postNotificationName:RRLOADER_STATUS_CHANGE object:self userInfo:dict];
}

- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
	[buff appendData:data];
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:data forKey:@"data"];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:RRLOADER_STATUS_CHANGE object:self userInfo:dict];
	
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
	
}

- (void)connection:(NSURLConnection *)aConn didFailWithError:(NSError *)error
{
	[timer invalidate];
	timer = nil;
	
	NSString *av_msg = nil;
	
	switch ([error code])
	{
		case -1004:
		case -1009:
			av_msg = @"暂时无法连接到服务器，请稍后重试。";
			break;
			
		case -101:
			av_msg = @"网络质量不算好哦，请耐心等待下⋯⋯";
			break;
			
		case -102:
			av_msg = @"网络超时，刚才的网络请求失败，请稍后重试。";
			break;
			
		default:
			av_msg = @"网络错误，请检查网络设置或稍后再试。";
			break;
	}
	
	if (-1 != time_interval)
	{
//		[RWAlertView show:av_msg];
	}
	
	switch ([error code])
	{
		case -101:
			return;
			break;
			
		default:
			break;
	}
	
	[conn cancel];
	conn = nil;
	
	NSDictionary *dict = [NSDictionary dictionaryWithObject:error forKey:@"data"];
	
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:RRLOADER_FAIL object:self userInfo:dict];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
	[timer invalidate];
	timer = nil;
	conn = nil;
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:RRLOADER_COMPLETE object:self];
    NSDictionary *json = [self getJSONData];
    if ([[[json objectForKey:@"data"] objectForKey:@"ecode"] isEqualToString:@"401"])
    {
        RRToken *token = [RRToken getInstance];
		[RRToken removeTokenForUID:[token getProperty:@"id"]];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"last_login_uid"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[AppDelegate getInstance] performSelector:@selector(checkToken) withObject:nil afterDelay:1.0f];
    }
}


@end