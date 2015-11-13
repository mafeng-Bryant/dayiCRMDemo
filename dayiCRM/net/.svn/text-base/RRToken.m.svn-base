//
//  RRToken.m
//  lib_net
//
//  Created by lyq on 11-6-10.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import "RRToken.h"


static RRToken *instance = nil;


@implementation RRToken

@synthesize uid;


#pragma mark -
#pragma mark class method

+ (RRToken *) getInstance
{
    [self check];
	return instance;
}

+ (BOOL) check
{
	NSString *last_login_uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_login_uid"];
	
	if (!last_login_uid)
	{
        instance = nil;
		return NO;
	}
	
	if (instance)
	{
		instance = nil;
	}
	
	RRToken *token = [[RRToken alloc] initWithUID:last_login_uid];
	
	if ([token loadFromFile])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

+ (void) removeTokenForUID:(NSString *)UID
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *exist_tokens = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"tokens"]];
	
	if (nil == UID)
	{
		UID = @"";
	}
	
	[exist_tokens removeObjectForKey:UID];

	[defaults setObject:exist_tokens forKey:@"tokens"];
    [defaults synchronize];
}

#pragma mark -

- (id) initWithUID:(NSString *)UID
{
	if (nil == UID || [UID isEqualToString:@""])
	{
		return nil;
	}
	
	self = [super init];
	
	if (self)
	{
		instance = self;
		
		self.uid = UID;
		
		if (properties)
		{
			properties = nil;
		}
		properties = [[NSMutableDictionary alloc] init];
				
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:UID forKey:@"last_login_uid"];
		
		NSMutableDictionary *exist_tokens = [NSMutableDictionary dictionaryWithDictionary:[defaults objectForKey:@"tokens"]];
		if (exist_tokens)
		{
			if (![exist_tokens objectForKey:UID])
			{
				[exist_tokens setObject:[NSString stringWithFormat:@"token_%@.plist", UID] forKey:UID];
				[defaults setObject:exist_tokens forKey:@"tokens"];
			}
		}
		else
		{
			exist_tokens = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"token_%@.plist", UID], UID, nil];
			[defaults setObject:exist_tokens forKey:@"tokens"];
		}
	}
	
	return self;
}


- (void) dealloc
{
	[self saveToFile];
	
	properties = nil;
	
	
	instance = nil;
	
}

#pragma mark -

#pragma mark Store/Restore
- (BOOL) loadFromFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"token_%@.plist", uid];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:token_file];
	
	if (nil != dic)
	{
		[properties addEntriesFromDictionary:dic];
		return YES;
	}
	else
	{
		return NO;
	}
}

- (void) saveToFile
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"token_%@.plist", uid];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	
	[properties writeToFile:token_file atomically:YES];
}


#pragma mark Property
- (id) getProperty:(NSString *)key
{
	return [properties objectForKey:key];
}

- (void) setProperty:(id)value forKey:(NSString *)key
{
	[properties setObject:value forKey:key];
}

- (void) unsetProperty: (NSString *)key
{
	[properties removeObjectForKey:key];
}

- (void) cleanProperty
{
	[properties removeAllObjects];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@", properties];
}


@end
