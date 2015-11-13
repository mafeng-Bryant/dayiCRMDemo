//
//  RRURLRequest.m
//  lib_net
//
//  Created by lyq on 11-6-8.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import "RRURLRequest.h"

static 	BOOL is_voic = NO;

@implementation RRURLRequest

+ (void) setFlag:(BOOL)flag
{
    is_voic = flag;

}


+ (id) requestWithURLString: (NSString *)url
{
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:url];
	
	return req;
}

- (id) initWithURLString: (NSString *)url
{
	NSString *f_url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *URL = [NSURL URLWithString:f_url];
	
	self = [super initWithURL:URL];
	
	if (self)
	{
		parameters = [[NSMutableDictionary alloc] init];
		datas = [[NSMutableDictionary alloc] init];
	}
			return self;
}

- (void) dealloc
{
	parameters = nil;
	
	datas = nil;
	
}

#pragma mark -
#pragma mark Parameters

- (void) setParam:(NSString *)value forKey:(NSString *)key
{
	[parameters setObject:value forKey:key];
}

- (void) unsetParam:(NSString *)key
{
	[parameters removeObjectForKey:key];
}

- (void) clearParams
{
	[parameters removeAllObjects];
}


#pragma mark -
#pragma mark Datas

- (void) setData:(NSData *)data forKey:(NSString *)key
{
	[datas setObject:data forKey:key];
}

- (void) unsetData:(NSString *)key
{
	[datas removeObjectForKey:key];
}

- (void) clearDatas
{
	[datas removeAllObjects];
}

#pragma mark -

- (void) setupHttpBody
{
	if (0 < [datas count])
	{
			//如果要发送文件，就必须为POST方式，并且设置为multipart/form-data
		[self setHTTPMethod:@"POST"];
		[self setValue:@"multipart/form-data; boundary=0xKhTmLbOuNdArY" forHTTPHeaderField:@"Content-Type"];
		
		NSMutableData *post_data = [[NSMutableData alloc] init];
		
		for (id p in parameters)
		{
			[post_data appendData:[@"--0xKhTmLbOuNdArY\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
			[post_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", p] dataUsingEncoding:NSUTF8StringEncoding]];
			NSString *d = [NSString stringWithFormat:@"%@", [parameters objectForKey:p]];
			[post_data appendData:[d dataUsingEncoding:NSUTF8StringEncoding]];
			[post_data appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		}
		
		for (id p in datas)
		{
			[post_data appendData:[@"--0xKhTmLbOuNdArY\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
			if (is_voic)
			{
				[post_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"capture%@.amr\"\r\n\r\n",p, p] dataUsingEncoding:NSUTF8StringEncoding]];
			}
			else
			{
				[post_data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"capture%@.jpg\"\r\n\r\n",p, p] dataUsingEncoding:NSUTF8StringEncoding]];
			}
			[post_data appendData:[datas objectForKey:p]];
			
		}
		[post_data appendData:[@"\r\n--0xKhTmLbOuNdArY--\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		
		[self setHTTPBody:post_data];
	}
	else
	{
		NSMutableString *str = [[NSMutableString alloc] init];
		
		for (id p in parameters)
		{
			[str appendFormat:@"&%@=%@", p, [parameters objectForKey:p]];
		}
		
		NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
		
		[self setHTTPBody:data];
		
	}
}


@end
