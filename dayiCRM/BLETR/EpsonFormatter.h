//
//  EpsonFormatter.h
//  BLETR
//
//  Created by Fang on 14-8-15.
//  Copyright (c) 2014年 ISSC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EpsonFormatter : NSObject{
    NSMutableData *_data;
}

@property (readonly) NSMutableData *data;

- (void)initializePrinter;
- (void)selectCenterJustification;
- (void)selectLeftJustification;
- (void)selectRightJustification;
- (void)selectZoomFont;
- (void)selectNormalFont;
- (void)selectBoldStyle;
- (void)cancelBoldStyle;

- (void)selectStandardPrinterMode;
- (void)appendReturnString;
- (void)appendTabString;
- (void)appendString:(NSString *)string;

@end
