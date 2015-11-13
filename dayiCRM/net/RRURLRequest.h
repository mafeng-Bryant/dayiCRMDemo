//
//  RRURLRequest.h
//  lib_net
//
//  Created by lyq on 11-6-8.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRURLRequest : NSMutableURLRequest
{
	NSMutableDictionary		*parameters;
	NSMutableDictionary		*datas;
}

+ (void) setFlag:(BOOL)flag;

+ (id) requestWithURLString: (NSString *)url;

- (id) initWithURLString: (NSString *)url;

- (void) dealloc;

- (void) setParam: (NSString*)value forKey:(NSString *)key;

- (void) unsetParam: (NSString *)key;

- (void) clearParams;

- (void) setData:(NSData *)data forKey:(NSString *)key;

- (void) unsetData:(NSString *)key;

- (void) clearDatas;

- (void) setupHttpBody;


@end
