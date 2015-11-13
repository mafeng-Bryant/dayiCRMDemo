//
//  RRToken.h
//  lib_net
//
//  Created by lyq on 11-6-10.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RRToken : NSObject
{
	NSString			*uid;
	NSMutableDictionary *properties;
}

@property (nonatomic, copy) NSString *uid;


+ (id) getInstance;

+ (BOOL) check;

+ (void) removeTokenForUID:(NSString *)UID;

- (BOOL) loadFromFile;

- (void) saveToFile;

- (id) getProperty: (NSString *)key;

- (void) setProperty: (id)value forKey:(NSString *)key;

- (void) unsetProperty: (NSString *)key;

- (void) cleanProperty;

- (id) initWithUID:(NSString *)UID;


@end
