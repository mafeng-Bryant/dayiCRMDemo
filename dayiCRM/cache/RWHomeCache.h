//
//  RWHomeCache.h
//  RW
//
//  Created by 方鸿灏 on 12-5-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWHomeCache : NSObject

+ (NSString *) hashName: (NSString *)typeName;

+ (NSMutableArray *) readFromFile: (NSString *)typeName;

+ (NSInteger ) writeToFile: (NSMutableArray *)arr withName:(NSString *)typeName;


@end
