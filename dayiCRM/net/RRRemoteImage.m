//
//  RRRemoteImage.m
//  RR
//
//  Created by lyq on 8/29/11.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import "RRRemoteImage.h"


@implementation RRRemoteImage

@synthesize parent_view;
@synthesize url;


#pragma mark -

- (id) initWithURLString:(NSString *)urlString andParentView:(UIView *)aParentView andDelegate:(id)aDelegate
{
	self = [super init];
	
	if (self)
	{
		delegate = aDelegate;
		parent_view = aParentView;
		img_data = [[NSMutableData alloc] init];
		url = [[NSString alloc] initWithString:urlString];
		
		NSURL *url_c = [NSURL URLWithString:urlString];
		NSURLRequest *request = [NSURLRequest requestWithURL:url_c];
		connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	
	return self;
}

- (id) initWithURLString:(NSString *)urlString parentView:(UIView *)aParentView delegate:(id)aDelegate defaultImageName:(NSString *)name
{
	UIImage *def_img = [UIImage imageNamed:name];
	
	if (!def_img)
	{
		return nil;
	}
	
	self = [super initWithCGImage:def_img.CGImage];
	
	if (self)
	{
		delegate = aDelegate;
		parent_view = aParentView;
		img_data = [[NSMutableData alloc] init];
		url = [[NSString alloc] initWithString:urlString];
		
		NSURL *url_c = [NSURL URLWithString:urlString];
		NSURLRequest *request = [NSURLRequest requestWithURL:url_c];
		connect = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	}
	
	return self;
}



#pragma mark -
#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)aConn didReceiveData:(NSData *)data
{
	[img_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConn
{
	UIImage *new_img = [[UIImage alloc] initWithData:img_data];
		
	if (!new_img)
	{
		if (delegate && [delegate respondsToSelector:@selector(remoteImageDidBorken:)])
		{
			[delegate performSelector:@selector(remoteImageDidBorken:) withObject:self];
		}
	}
	else if (delegate && [delegate respondsToSelector:@selector(remoteImageDidLoaded:newImage:)])
	{
		[delegate performSelector:@selector(remoteImageDidLoaded:newImage:) withObject:self withObject:new_img];
	}
	
}


@end
