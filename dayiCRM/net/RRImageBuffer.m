//
//  RRImageBuffer.m
//  RR
//
//  Created by lyq on 6/27/11.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RRImageBuffer.h"


@implementation RRImageBuffer

+ (NSString *) hashName: (NSString *)imgName
{
	return [NSString stringWithFormat:@"%u", [imgName hash]];
}

+ (UIImage *) readFromFile: (NSString *)imgName
{
	NSString *filename = [RRImageBuffer hashName:imgName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *data_file = [document_directory stringByAppendingPathComponent:filename];
	
	UIImage *image = [[UIImage alloc] initWithContentsOfFile:data_file];
	return image;
}

+ (NSInteger) writeToFile: (UIImage *)image withName:(NSString *)imgName
{
	NSString *filename = [RRImageBuffer hashName:imgName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *data_file = [document_directory stringByAppendingPathComponent:filename];
	
	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];
	UIImage *new_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	//NSLog(@"%@", imgName);
	NSData *data = UIImageJPEGRepresentation(new_img, 0.5f);
	//NSLog(@"%u", [data length]);
	[data writeToFile:data_file atomically:YES];
	
	return 0;
}

+ (NSInteger) writeToFile: (UIImage *)image withName:(NSString *)imgName forSize:(CGSize)aSize
{
	NSString *filename = [RRImageBuffer hashName:imgName];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document_directory = [paths objectAtIndex:0];
	NSString *data_file = [document_directory stringByAppendingPathComponent:filename];
	
	CGSize new_size = CGSizeMake(0, 0);
	
	if (image.size.width > image.size.height)
	{
		if (image.size.width > aSize.width)
		{
			new_size.width = aSize.width;
			new_size.height = aSize.width / image.size.width * image.size.height;
		}
	}
	else
	{
		if (image.size.height > aSize.height)
		{
			new_size.width = aSize.height / image.size.height * image.size.width;
			new_size.height = aSize.height;
		}
	}
	
	CGRect rect = CGRectMake(0, 0, new_size.width, new_size.height);
	UIGraphicsBeginImageContext(rect.size);
	[image drawInRect:rect];
	UIImage *new_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	NSData *data = UIImageJPEGRepresentation(new_img, 0.5f);
	[data writeToFile:data_file atomically:YES];
	
	return 0;
}

@end
