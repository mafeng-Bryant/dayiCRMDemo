//
//  RRLoader.h
//  lib_net
//
//  Created by lyq on 11-6-8.
//	Copyright 2011 RoadRover Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRURLRequest.h"


#define RRLOADER_STATUS_CHANGE		@"RRLOADER_STATUS_CHANGE"
#define RRLOADER_FAIL				@"RRLOADER_FAIL"
#define RRLOADER_COMPLETE			@"RRLOADER_COMPLETE"


@class RRURLRequest;

@interface RRLoader : NSObject <NSURLConnectionDelegate>
{
	NSURLConnection		*conn;
	NSMutableData		*buff;
	NSUInteger			http_status_code;
	
	NSTimer				*timer;
	NSTimeInterval		time_interval;
	NSInteger			timeout_count;
	id					info;
}


@property (nonatomic, readonly) NSURLConnection *conn;
@property (nonatomic, readonly) NSMutableData *buff;
@property (nonatomic) id info;
@property (nonatomic, assign) NSTimeInterval time_interval;


+ (NSUInteger) count;

- (id) initWithRequest: (RRURLRequest *)request;

- (void) dealloc;

- (void) addNotificationListener: (NSString *)notificationName target:(id)target action:(SEL)action;

- (void) addNotificationListener: (NSString *)notificationName target:(id)target action:(SEL)action object:(id)object forKey:(id)akey;

- (void) removeNotificationListener: (NSString *)notificationName target:(id)target;

- (void) removeNotificationListener: (NSString *)notificationName target:(id)target forKey:(id)aKey;

- (void) load;

- (void) loadwithTimer;

- (void) loadWithoutTimer;

- (void) cancel;

- (NSString *) getStringData;

- (id) getJSONData;


@end
