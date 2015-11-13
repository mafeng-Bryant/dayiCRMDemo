//
//  RRImageLoader.m
//  lib_net
//
//  Created by lyq on 11-6-15.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import "RRImageLoader.h"
#import "RRToken.h"
#import "RRLoader.h"

@implementation RRImageLoader

@synthesize url;
@synthesize image;

- (id) initWithURLString: (NSString *)aUrl
{
	self = [super init];
	
	if (self)
	{
		image = nil;
		if (url)
		{
			url = nil;
		}
		self.url = aUrl;
	}
	
	return self;
}

- (void) load
{
	RRURLRequest *req = [RRURLRequest requestWithURLString:url];
	NSLog(@"%@",[super initWithRequest:req]);
	[super load];
}


- (void) connectionDidFinishLoading:(NSURLConnection *)aConn
{
	conn = nil;
	
	if (image)
	{
		image = nil;
	}
	
	image = [[UIImage alloc] initWithData:buff];
	
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	
	if (!image)
	{
		[center postNotificationName:RRIMAGELOADER_BROKEN_IMAGE object:self];
		return;
	}
	
	[center postNotificationName:RRLOADER_COMPLETE object:self];
}

@end
