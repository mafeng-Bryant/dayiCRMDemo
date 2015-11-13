//
//  RRRemoteImage.h
//  RR
//
//  Created by lyq on 8/29/11.
//  Copyright 2011 RoadRover Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RRRemoteImage : UIImage
{
	id					delegate;
	UIView				*__unsafe_unretained parent_view;
	UIImage				*image;
	NSString			*url;
	NSURLConnection		*connect;
	NSMutableData		*img_data;
}

@property (nonatomic, unsafe_unretained, readonly) UIView *parent_view;
@property (nonatomic, readonly) NSString *url;


- (id) initWithURLString:(NSString *)urlString andParentView:(UIView *)aParentView andDelegate:(id)aDelegate;

- (id) initWithURLString:(NSString *)urlString parentView:(UIView *)aParentView delegate:(id)aDelegate defaultImageName:(NSString *)name;

@end


@protocol RRRemoteImageDelegate

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage;

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage;

@end
