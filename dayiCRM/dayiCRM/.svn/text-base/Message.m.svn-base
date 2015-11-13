//
//  Message.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "Message.h"
#import "RRToken.h"

@implementation Message

- (void)setDict:(NSDictionary *)dict{
    
    _dict = dict;
    
    self.icon = dict[@"avatarId"];
    self.time = [self getTimeStringWithString:dict[@"createTime"] ];
    
    self.content = [self replaceContent];
    if ([dict[@"fromUserId"] isEqualToString:dict[@"userId"]]) {
        self.type = 1;
    }
    else
    {
        self.type = 0;
    }
    self.msgType = dict[@"msgType"];
}

- (NSString *)getTimeStringWithString:(NSString *)time
{
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
	[date_formatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[time doubleValue]/1000]];
    return post_date;
}

- (int)getTypeWithString:(NSString *)userId
{
    RRToken *token = [RRToken getInstance];
    NSLog(@"%@,%@",userId,[token getProperty:@"id"]);
    if ([userId isEqualToString:[token getProperty:@"id"]]) {
        return 0;
    }
    return 1;
}

- (NSString *)replaceContent
{
    NSString *contentStr = _dict[@"content"];
    
    NSRegularExpression* regex1 = [[NSRegularExpression alloc]
                                   initWithPattern:@"<a .*>(\\d+|\\D+)</a>"
                                   options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                   error:nil];
    
    NSArray* chunks1 = [regex1 matchesInString:contentStr options:0
                                         range:NSMakeRange(0, [contentStr length])];
    for (NSTextCheckingResult* b in chunks1)
    {
        contentStr = [regex1 stringByReplacingMatchesInString:contentStr options:0 range:b.range withTemplate:@""];
    }
    
    return contentStr;

}
@end
