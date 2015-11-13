//
//  MessageCell.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "MessageCell.h"
#import "Message.h"
#import "MessageFrame.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "FLViewController.h"
#import "RRToken.h"

@interface MessageCell ()
{
    UIButton     *_timeBtn;
    UIImageView *_iconView;
    UIButton    *_contentBtn;
}

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // 1、创建时间按钮
        _timeBtn = [[UIButton alloc] init];
        [_timeBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = kTimeFont;
        _timeBtn.enabled = NO;
        [_timeBtn setBackgroundImage:[UIImage imageNamed:@"chat_timeline_bg.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:_timeBtn];
        
        // 2、创建头像
        clickAvatar = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:clickAvatar];

        
        // 3、创建内容
        _contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        _contentBtn.titleLabel.font = kContentFont;
        _contentBtn.titleLabel.numberOfLines = 0;
        
        [self.contentView addSubview:_contentBtn];
        

    }
    return self;
}

- (void)setMessageFrame:(MessageFrame *)messageFrame{
    
    UITableView *tv = (UITableView *) self.superview;
    if (IOS7) {
        tv = (UITableView *) self.superview.superview;
    }
    FLViewController *vc = (FLViewController *) tv.dataSource;
    
    _messageFrame = messageFrame;
    Message *message = _messageFrame.message;

    // 1、设置时间
    [_timeBtn setTitle:message.time forState:UIControlStateNormal];
    _timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    clickAvatar.frame = _messageFrame.iconF;
    
    NSString *avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,message.icon];
    if (message.type == MessageTypeMe) {
        
        avatar_url = [NSString stringWithFormat:@"%@%@",BASE_URL ,[[RRToken getInstance] getProperty:@"avatar"]];
    }
	UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
	if (avatar_im)
	{
        [clickAvatar setImage:avatar_im forState:UIControlStateNormal];

	}
	else
	{
		RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
															 parentView:_iconView
															   delegate:self
													   defaultImageName:@"default_pic_avatar"];
        [clickAvatar setImage:r_img forState:UIControlStateNormal];

	}
    
    clickAvatar.accessibilityIdentifier = [NSString stringWithFormat:@"%d",message.type ];
    [clickAvatar addTarget:vc action:@selector(btn_avatar_click:) forControlEvents:UIControlEventTouchUpInside];


    // 3、设置内容
    if ([message.msgType isEqualToString:@"image"])
    {
        if (clickImage) {
            [clickImage removeFromSuperview];
            clickImage = nil;
        }
        if (message.type == MessageTypeMe) {
            clickImage = [[ClickImage alloc] initWithFrame:CGRectMake(5, 0,114, 86)];
        }
        else{
            clickImage = [[ClickImage alloc] initWithFrame:CGRectMake(10, 0, 114, 86)];
        }
        clickImage.canClick = YES;
        clickImage.layer.cornerRadius = 10.0f;
        clickImage.layer.masksToBounds = YES;
        NSString *avatar_url;
        if ([message.content hasPrefix:@"http"]) {
            avatar_url = message.content;
        }
        else{
            avatar_url = [BASE_URL stringByAppendingString:message.content ];
        }
        UIImage *avatar_im = [RRImageBuffer readFromFile:avatar_url];
        if (avatar_im)
        {
            [clickImage setImage:avatar_im];
        }
        else
        {
            RRRemoteImage *r_img = [[RRRemoteImage alloc] initWithURLString:avatar_url
                                                                 parentView:clickImage
                                                                   delegate:self
                                                           defaultImageName:@"default_pic_avatar"];
            [clickImage setImage:r_img];
        }

        _contentBtn.accessibilityHint = @"image";
        _contentBtn.accessibilityIdentifier = message.content;
        
        [_contentBtn addSubview:clickImage];
        [_contentBtn addTarget:vc action:@selector(btn_content_click:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if ([message.msgType isEqualToString:@"voice"])
    {
        if (imv) {
            [imv removeFromSuperview];
            imv = nil;
        }
        if (message.type == MessageTypeMe) {
            imv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 12, 17)];
            imv.image = [UIImage imageNamed:@"chat_voice_me"];
        }
        else{
            imv = [[UIImageView alloc] initWithFrame:CGRectMake(33, 10, 12, 17)];
            imv.image = [UIImage imageNamed:@"chat_type_voice"];

        }
        _contentBtn.accessibilityHint = @"voice";
        _contentBtn.accessibilityIdentifier = message.content;
        [_contentBtn addTarget:vc action:@selector(btn_content_click:) forControlEvents:UIControlEventTouchUpInside];
        
        [_contentBtn addSubview:imv];
    }
    else
    {
        if (currentLabel) {
            [currentLabel removeFromSuperview];
            currentLabel = nil;
        }
        if (message.type == MessageTypeMe) {
            currentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(15, 10, _messageFrame.contentF.size.width, _messageFrame.contentF.size.height)];
        }
        else{
            currentLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(20, 10, _messageFrame.contentF.size.width, _messageFrame.contentF.size.height)];
        }
        currentLabel.delegate = self;
        [self creatAttributedLabel:[CustomMethod escapedString:message.content] Label:currentLabel];
        [CustomMethod drawImage:currentLabel];
        [_contentBtn addSubview:currentLabel];
    }

    _contentBtn.frame = _messageFrame.contentF;
    _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    if (message.type == MessageTypeMe) {
        _contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }

    UIImage *normal , *focused;
    if (message.type == MessageTypeMe) {
    
        normal = [UIImage imageNamed:@"chatto_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"chatfrom_bg_normal.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
        
    }
    [_contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [_contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
}

- (void)btn_content_click:(id)sender
{
    
}

- (void)btn_avatar_click:(id)sender
{
    
}

- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    NSMutableArray *httpArr = [CustomMethod addHttpArr:o_text];
    NSMutableArray *phoneNumArr = [CustomMethod addPhoneNumArr:o_text];
    NSMutableArray *emailArr = [CustomMethod addEmailArr:o_text];
    
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMap"];
    
    NSDictionary *dics = [[NSUserDefaults standardUserDefaults] objectForKey:@"FaceMaps"];
    NSDictionary *s_emojiDic = [[NSDictionary alloc] initWithObjects:[dics allKeys] forKeys:[dics allValues]];
    m_emojiDic = [[NSDictionary alloc] initWithObjects:[dic allKeys] forKeys:[dic allValues]];
    NSString *text = [CustomMethod transformString:o_text emojiDic:m_emojiDic s_emojiDic:s_emojiDic];
    text = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];
    
    MarkupParser *wk_markupParser = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:kContentFont];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAttString:attString withImages:wk_markupParser.images];
    
    NSString *string = attString.string;
    
    if ([emailArr count]) {
        for (NSString *emailStr in emailArr) {
            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
        }
    }
    
    if ([phoneNumArr count]) {
        for (NSString *phoneNum in phoneNumArr) {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    if ([httpArr count]) {
        for (NSString *httpStr in httpArr) {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    
    label.delegate = self;
    CGRect labelRect = label.frame;
    labelRect.size.width = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame = labelRect;
    label.underlineLinks = YES;//链接是否带下划线
    [label.layer display];
}

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL]) {
        url = linkInfo.URL;
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"打开网址"]];
        [actionSheet showInView:self.superview];

    }
    else if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@",linkInfo.phoneNumber]]]) {
        phoneNumber = linkInfo.phoneNumber;
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"拨打电话?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[phoneNumber]];
        [actionSheet showInView:self.superview];
    }
    return NO;
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger )buttonIndex
{
    if (0 == buttonIndex) {
        if (phoneNumber) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@",phoneNumber]]];
            phoneNumber = nil;
        }
        else {
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}

- (void)didClickOnDestructiveButton
{
}

- (void)didClickOnCancelButton
{
}

#pragma mark -
#pragma mark RRRemoteImageDelegate

- (void) remoteImageDidBorken:(RRRemoteImage *)remoteImage
{
	static UIImage *empty_image = nil;
	
	if (nil == empty_image)
	{
		empty_image = [UIImage imageNamed:@"default_pic_avatar"];
	}
	
    if ([remoteImage.parent_view isEqual:imv]) {
        [imv setImage:empty_image];
    }
    else if ([remoteImage.parent_view isEqual:clickImage])
    {
        [clickImage setImage:empty_image];
    }
    else
    {
        [_iconView setImage:empty_image];
    }
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
    if ([remoteImage.parent_view isEqual:imv]) {
        [imv setImage:newImage];
    }
    else if ([remoteImage.parent_view isEqual:clickImage])
    {
        [clickImage setImage:newImage];
    }
    else
    {
        [_iconView setImage:newImage];
    }
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

- (void)dealloc
{
    currentLabel = nil;
    m_emojiDic = nil;
    imv = nil;
    clickImage = nil;
    _timeBtn = nil;
    _iconView = nil;
    _contentBtn = nil;
}

@end
