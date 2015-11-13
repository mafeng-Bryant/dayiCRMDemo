//
//  RWCache.m
//  RW
//
//  Created by fang honghao on 12-3-23.
//  Copyright (c) 2012年 roadrover. All rights reserved.
//

#import "RWCache.h"
#import "RWDidist.h"

static RWCache *instance = nil;

@implementation RWCache

@synthesize uid;

#pragma mark -
#pragma mark class method

+ (RWCache *) getInstanceWithName:(NSString *)name
{
	[self checkWithName:name];
	return instance;
}

- (NSUInteger) getCount
{
	return [arr count];
}

- (NSMutableArray *) getArr
{
	return arr;
}

- (void) cleanCache
{
	[arr removeAllObjects];
}

+ (BOOL) checkWithName:(NSString *)name
{
	if (instance)
	{
		instance = nil;
	}
	
	RWCache *token = [[RWCache alloc] init];
	
	if ([token loadFromFileWithName:name])
	{
		return YES;
	}
	else
	{
		return NO;
	}
}

#pragma mark -

- (id) init
{
	self = [super init];
	
	if (self)
	{
		instance = self;
		if (arr)
		{
			arr = nil;
		}
		arr = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void) dealloc
{
	
	arr = nil;
	
	
	instance = nil;
	
}

#pragma mark -

#pragma mark Store/Restore
- (BOOL) loadFromFileWithName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"%@.plist",name];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:token_file];
	if (nil != array)
	{
		[arr addObjectsFromArray:array];

		return YES;
	}
	else
	{
		return NO;
	}
}

- (void) saveToFileWithName:(NSString *)name
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"%@.plist",name];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	
	if ([arr count] > 40)
	{
		[arr removeObjectAtIndex:0];
	}
    
	[arr writeToFile:token_file atomically:YES];
}

- (void) deleteFileWithName:(NSString *)name Index:(NSUInteger)index
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *token_file_name = [NSString stringWithFormat:@"%@.plist",name];
	NSString *token_file = [document_directory stringByAppendingPathComponent:token_file_name];
	[arr removeObjectAtIndex:index];
	[arr writeToFile:token_file atomically:YES];
}
#pragma mark Property

- (void) setArr:(NSDictionary *)value WithName:(NSString *)name
{
	[self loadFromFileWithName:name];
	
	if ([name isEqualToString:@"draft"])
	{
		[arr addObject:value];
		return;
	}

    else if ([name isEqualToString:@"history"])
    {
        for (int i = 0; i < [arr count]; i++)
        {
            
            if ([[[arr objectAtIndex:i] objectForKey:@"srcCity"]isEqualToString:[value objectForKey:@"srcCity"]] &&
                [[[arr objectAtIndex:i] objectForKey:@"decCity"]isEqualToString:[value objectForKey:@"decCity"]] &&
                ![RWDidist compareData:[[arr objectAtIndex:i] objectForKey:@"date"] toData:[value objectForKey:@"date"]])
            {
                [arr replaceObjectAtIndex:i withObject:value];
                is_copy = YES;
            }
        }
    }

	if (!is_copy)
	{
		[arr addObject:value];
	}

}


@end
