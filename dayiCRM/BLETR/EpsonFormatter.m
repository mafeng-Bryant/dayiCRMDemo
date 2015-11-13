//
//  EpsonFormatter.m
//  BLETR
//
//  Created by Fang on 14-8-15.
//  Copyright (c) 2014年 ISSC. All rights reserved.
//

#import "EpsonFormatter.h"

@implementation EpsonFormatter
#define EpsonFormatterESCString "\x1b"
#define EpsonFormatterGSString "\x1d"
#define EpsonFormatterRETURNString "\r"
#define EpsonFormatterTABNString " "

@synthesize data = _data;

- (id)init {
    self = [super init];
    if (self) {
        _data = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_data release];
    [super dealloc];
}

- (void)initializePrinter {
    [_data appendBytes:EpsonFormatterESCString "@" length:2];
}

- (void)selectCenterJustification {
    [_data appendBytes:EpsonFormatterESCString "a" "\x1" length:3];
}

- (void)selectLeftJustification{
    [_data appendBytes:EpsonFormatterESCString "a" "\x0" length:3];
}

- (void)selectBoldStyle {
    [_data appendBytes:EpsonFormatterESCString "g" "\x1" length:3];
}

- (void)cancelBoldStyle{
    [_data appendBytes:EpsonFormatterESCString "g" "\x0" length:3];
}


- (void)selectRightJustification{
    [_data appendBytes:EpsonFormatterESCString "a" "\x2" length:3];

}

- (void)selectZoomFont{
    [_data appendBytes:EpsonFormatterGSString "!" "\x1" length:3];
}

- (void)selectNormalFont{
    [_data appendBytes:EpsonFormatterGSString "!" "\x0" length:3];
}

- (void)selectStandardPrinterMode {
    [_data appendBytes:EpsonFormatterESCString "!" "\x0" length:3];
}

- (void)appendTabString{
    [_data appendBytes:EpsonFormatterTABNString length:1];
}

- (void)appendReturnString{
    [_data appendBytes:EpsonFormatterRETURNString length:1];
}

- (void)appendString:(NSString *)string {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    [_data appendData:[string  dataUsingEncoding:enc allowLossyConversion:YES]];
}

@end
