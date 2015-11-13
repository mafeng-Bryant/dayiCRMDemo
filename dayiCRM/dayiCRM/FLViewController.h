//
//  FLViewController.h
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "EGORefreshTableHeaderView.h"
#import "NSURL+Download.h"
#import "DownloadManager.h"
#import "LXActionSheet.h"

#define Time  0.25
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define  keyboardHeight 216
#define  toolBarHeight 45
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define facialViewHeight 170
#define  buttonWh 34
@interface FLViewController : UIViewController<facialViewDelegate,DownloadManagerDelegate,AVAudioPlayerDelegate,LXActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    BOOL keyboardIsShow;//键盘是否显示
    BOOL voiceIsShow;
    BOOL recording;
    
    UIScrollView *scrollView;//表情滚动视图
    UIPageControl *pageControl;
    NSMutableArray *faceArray;
    NSString *lastFace;
    NSString *msgId;
    NSString *userId;
    NSString *maxId;
    NSString *minId;
    NSUInteger pageIndex;
    NSMutableArray *buffer;
    AVAudioPlayer *audioPlayer;
    NSTimer *timer;
    NSTimer *updataTimer;
    AVAudioRecorder *recorder;
    NSTimer *recorderTimer;
    NSString *recorderUrl;
    NSString *recorderFileName;

    NSString *fromMemberId;
    NSString *toMemberId;
    NSString *type;
    
    UIImageView *voiceImageView;
    UIImageView *voice_image;
    EGORefreshTableHeaderView	*refreshHeaderView;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (strong, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIToolbar *tool_bar;
@property (weak, nonatomic) IBOutlet UIView *acessView;
@property (nonatomic,retain) AVAudioPlayer *audioPlayer;
@property (nonatomic, copy)NSString *msgId;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *title;

- (IBAction)faceBtnClick:(UIButton *)sender;
- (IBAction)voiceBtnClick:(UIButton *)sender;
- (IBAction)imageBtnClick:(UIButton *)sender;

@end
