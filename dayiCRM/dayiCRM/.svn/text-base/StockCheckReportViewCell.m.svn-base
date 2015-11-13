//
//  StockCheckReportViewCell.m
//  dayiCRM
//
//  Created by Fang on 14/10/23.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "StockCheckReportViewCell.h"

@implementation StockCheckReportViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setContent:(NSDictionary *)data
{
    [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[data objectForKey:@"avatarId"]]];
    lb_name.text = [[data objectForKey:@"productName"] stringByAppendingString:[data objectForKey:@"pici"]];
    
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"YYYY-MM-dd HH:MM"];
    NSString *start_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"detailDate"] doubleValue]/1000]];
    
    lb_time.text = [NSString stringWithFormat:@"盘点时间: %@",start_date];
    if ([[data objectForKey:@"result"] isEqualToString:@"N"]) {
        lb_status.hidden = NO;
    }
    
    lb_picecInventory.text = [NSString stringWithFormat:@"%@%@%@%@",[data objectForKey:@"picecInventory"],[data objectForKey:@"bigUnitName"],[data objectForKey:@"unitInventory"],[data objectForKey:@"unitName"]];
    
    lb_realInventory.text = [NSString stringWithFormat:@"%@%@%@%@",[data objectForKey:@"pieceRealNumber"],[data objectForKey:@"bigUnitName"],[data objectForKey:@"realNumber"],[data objectForKey:@"unitName"]];
    
    lb_remark.text = [data objectForKey:@"remark"];
}

@end
