//
//  MessageCell.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Attributes.h"
#import "MarkupParser.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"
#import "LXActionSheet.h"
#import "ClickImage.h"
@class MessageFrame;

@interface MessageCell : UITableViewCell<OHAttributedLabelDelegate,LXActionSheetDelegate>
{
    OHAttributedLabel *currentLabel;
    NSDictionary *m_emojiDic;
    NSString *phoneNumber;
    NSURL *url;
    UIImageView *imv;
    ClickImage *clickImage;
    UIButton *clickAvatar;


}
@property (nonatomic, strong) MessageFrame *messageFrame;

@end
