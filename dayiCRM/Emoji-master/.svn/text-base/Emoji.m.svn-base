//
//  Emoji.m
//  Emoji
//
//  Created by Aliksandr Andrashuk on 26.10.12.
//  Copyright (c) 2012 Aliksandr Andrashuk. All rights reserved.
//

#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    NSString *emoji = [[[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding] autorelease];
    return emoji;
}
+ (NSArray *)allEmoji {
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
    NSDictionary *faceMap = [NSDictionary dictionaryWithContentsOfFile:
               [[NSBundle mainBundle] pathForResource:@"_expression"
                                               ofType:@"plist"]];
    [array addObjectsFromArray:[faceMap allValues]];
    [[NSUserDefaults standardUserDefaults] setObject:faceMap forKey:@"FaceMap"];
    NSDictionary *faceMaps = [NSDictionary dictionaryWithContentsOfFile:
                             [[NSBundle mainBundle] pathForResource:@"_expression_s"
                                                             ofType:@"plist"]];
    [[NSUserDefaults standardUserDefaults] setObject:faceMaps forKey:@"FaceMaps"];
    [[NSUserDefaults standardUserDefaults] synchronize];

//    [array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
//    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
//    [array addObjectsFromArray:[EmojiTransport allTransport]];
    
    return array;
}
@end
