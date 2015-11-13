//
//  FLViewController.m
//  15-QQ聊天布局
//
//  Created by Liu Feng on 13-12-3.
//  Copyright (c) 2013年 Liu Feng. All rights reserved.
//

#import "FLViewController.h"
#import "MessageFrame.h"
#import "Message.h"
#import "MessageCell.h"
#import "RegexKitLite.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RWDidist.h"
#import "NSURL+Download.h"
#import "VoiceConverter.h"
#import "RWHomeCache.h"
#import "NSObject+SBJson.h"
#import "MemberDetailViewController.h"

@interface FLViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray  *_allMessagesFrame;
    NSArray *itemsArray;
}
@end

@implementation FLViewController
@synthesize title;
@synthesize msgId,userId;
@synthesize audioPlayer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = title;
    UIBarButtonItem *btn_cancel;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];

    CGRect top_rect = CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, 320.0f, self.tableView.bounds.size.height);
	refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithoutDateLabel:top_rect];
	refreshHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_view.png"]];
	[self.tableView addSubview:refreshHeaderView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    keyboardIsShow=NO;

    _messageField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _messageField.leftViewMode = UITextFieldViewModeAlways;
    _messageField.delegate = self;
    itemsArray = [NSArray arrayWithArray:self.tool_bar.items];
    [self initScrollView];
    
    UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 2, 2);
    UIImage *originalImageYellow = [UIImage imageNamed:@"toolbar_bottom_bg"];
    UIImage *stretchableImageYellow = [originalImageYellow resizableImageWithCapInsets:insets];
    [self.navigationController.toolbar setBackgroundImage:stretchableImageYellow forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    UIImageView *barBackgroudView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    barBackgroudView.image = stretchableImageYellow;
    [self.navigationController.toolbar insertSubview:barBackgroudView atIndex:0];

    faceArray = [NSMutableArray array];
    buffer = [NSMutableArray array];
    _allMessagesFrame = [NSMutableArray array];

    NSArray *arr = [RWHomeCache readFromFile:self.userId];
    NSString *previousTime = nil;
	if ([arr count])
	{
        for (NSDictionary *dict in arr) {
            
            MessageFrame *messageFrame = [[MessageFrame alloc] init];
            Message *message = [[Message alloc] init];
            message.dict = dict;
            messageFrame.showTime = ![previousTime isEqualToString:message.time];
            
            previousTime = message.time;
            messageFrame.message = message;
            [_allMessagesFrame addObject:messageFrame];
        }
		[self.tableView reloadData];
        [self scrollTableToFoot:NO];

	}

    pageIndex = 1;
   [self loadData];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10
                                             target:self
                                           selector:@selector(updataMsg) userInfo:nil
                                            repeats:YES];
 }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	self.toolbarItems = itemsArray;
	[self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.toolbarItems = self.tool_bar.items;
	[self.navigationController setToolbarHidden:YES animated:YES];
    [SVProgressHUD dismiss];
    [self dismissKeyBoard];
    [self cleanCache];
    [timer invalidate];
    [recorderTimer invalidate];
    [self.recordBtn removeFromSuperview];
    [updataTimer invalidate];
}

- (void)dealloc
{
    self.view=nil;
    timer=nil;
    scrollView = nil;
    self.tableView=nil;
    recorderTimer = nil;
    buffer=nil;
    audioPlayer =nil;
    faceArray =nil;
    updataTimer = nil;
    self.acessView=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[note userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, ty-rect.size.height);
        self.navigationController.toolbar.transform = CGAffineTransformMakeTranslation(0, ty);
        CGRect keyBoardFrame = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if (self.tool_bar.frame.size.height>45) {
            self.tool_bar.frame = CGRectMake(0, keyBoardFrame.origin.y-20-self.tool_bar.frame.size.height,  self.view.bounds.size.width,self.tool_bar.frame.size.height);
        }else{
            self.tool_bar.frame = CGRectMake(0, keyBoardFrame.origin.y-65,  self.view.bounds.size.width,toolBarHeight);
        }
    }];
    [self.faceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile"] forState:UIControlStateNormal];
    keyboardIsShow=YES;
    [pageControl setHidden:YES];

}

#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [self.faceBtn setImage:[UIImage imageNamed:@"Text.png"] forState:UIControlStateNormal];
    keyboardIsShow=NO;
}
#pragma mark - 文本框代理方法
#pragma mark 点击textField键盘的回车按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

//    [self dismissKeyBoard];
    // 1、增加数据源
    NSString *content = textField.text;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    fmt.dateFormat = @"MM-dd"; // @"yyyy-MM-dd HH:mm:ss"
    NSString *time = [fmt stringFromDate:date];
    [self addMessageWithContent:content time:time andType:@"text"];
    // 2、刷新表格
    [self.tableView reloadData];
    // 3、滚动至当前行
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_allMessagesFrame.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    textField.text = nil;
    [self sendMsg:content];
    return YES;
}

#pragma mark 给数据源增加内容
- (void)addMessageWithContent:(NSString *)content time:(NSString *)time andType:(NSString *)type{
    
    MessageFrame *mf = [[MessageFrame alloc] init];
    Message *msg = [[Message alloc] init];
    mf.showTime = NO;
    msg.content = content;
    msg.time = time;
    msg.icon = [[RRToken getInstance] getProperty:@"avatarId"];
    msg.type = MessageTypeMe;
    msg.msgType = type;
    mf.message = msg;
    [_allMessagesFrame addObject:mf];
}

#pragma mark - tableView数据源方法

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allMessagesFrame.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell_%d",indexPath.row];
    MessageCell *cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    // 设置数据
    cell.messageFrame = _allMessagesFrame[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [_allMessagesFrame[indexPath.row] cellHeight];
}

- (void)scrollViewDidScroll: (UIScrollView *)ScrollView
{
    if ([ScrollView isEqual:scrollView]) {
        int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
        pageControl.currentPage = page;//pagecontroll响应值的变化
        return;
    }
	if (!ScrollView.isDragging)
	{
		return;
	}
    
	if (refreshHeaderView.state == EGOOPullRefreshPulling && ScrollView.contentOffset.y > -65.0f && ScrollView.contentOffset.y < 0.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshNormal];
	}
	else if (refreshHeaderView.state == EGOOPullRefreshNormal && ScrollView.contentOffset.y < -65.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshPulling];
	}
	
}

- (void)scrollViewDidEndDragging:(UIScrollView *)ScrollView willDecelerate:(BOOL)decelerate
{
	if (ScrollView.contentOffset.y < - 65.0f)
	{
		[refreshHeaderView setState:EGOOPullRefreshLoading];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
        
 		self.tableView.scrollEnabled = YES;
        [self loadOld];
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}
- (void) updateTableView
{
	[refreshHeaderView setState:EGOOPullRefreshNormal];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.2];
	self.tableView.contentInset = UIEdgeInsetsZero;
	[UIView commitAnimations];
	self.tableView.scrollEnabled = YES;
	[self.tableView reloadData];
}


#pragma mark - 代理方法

- (void)scrollViewWillBeginDragging:(UIScrollView *)ScrollView{
    
    if ([ScrollView isEqual:scrollView]) {
        return;
    }

    [self.view endEditing:YES];
    [self dismissKeyBoard];

}

#pragma mark - 语音按钮点击
- (IBAction)faceBtnClick:(UIButton *)sender
{
    if (voiceIsShow) {
        [self showRecordView];
    }

    [self disFaceKeyboard];
}

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)voiceBtnClick:(UIButton *)sender
{
    [self dismissKeyBoard];
    if (!pageControl.hidden) {
        [self disFaceKeyboard];
    }
    [self showRecordView];
}

- (IBAction)imageBtnClick:(UIButton *)sender
{
    [self dismissKeyBoard];
    LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册",@"从相机获取"]];
    [actionSheet showInView:self.view];

}

- (IBAction)btnDown:(id)sender
{
    [self beginRecord];
    
    voiceImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"record_animate_01.png"]];
    voiceImageView.frame = CGRectMake(0, 0, 75, 111);
    voiceImageView.center = self.view.window.center;
    [self.view.window addSubview:voiceImageView];
    
    //设置定时检测
    recorderTimer = [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

- (IBAction)btnUp:(id)sender
{
    double cTime = recorder.currentTime;
    if (cTime > 2) {//如果录制时间<2 不发送
        NSLog(@"发出去");
        [self finishRecord];
    }else {
        [self.view.window makeToast:@"录制时间太短!" duration:2.0 position:@"center"];
        [recorder stop];
    }
    
    if ([recorderTimer isValid])
        [recorderTimer invalidate];
    [voiceImageView removeFromSuperview];
}

- (IBAction)btnDragUp:(id)sender
{
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [recorderTimer invalidate];
    [voiceImageView removeFromSuperview];
    NSLog(@"取消发送");
}

- (void)showRecordView
{
    if (voiceIsShow) {
        [self.recordBtn removeFromSuperview];
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
    }
    else {
        if (self.recordBtn) {
            self.recordBtn = nil;
        }
        self.recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.recordBtn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
        [self.recordBtn addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.recordBtn addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];

        [self.recordBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self.recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        UIImage *image = [UIImage imageNamed:@"VoiceBtnTooShort_Black"];
        UIEdgeInsets insets = UIEdgeInsetsMake(10, 10, 10, 10);
        UIImage *stretchableImage = [image resizableImageWithCapInsets:insets];
        [self.recordBtn setBackgroundImage:stretchableImage forState:UIControlStateNormal];
        self.recordBtn.frame = CGRectMake(50, 0, 187, 42);
        [self.navigationController.toolbar addSubview:self.recordBtn];
        [self.voiceBtn setImage:[UIImage imageNamed:@"ToolViewInputText"] forState:UIControlStateNormal];
    }
    voiceIsShow = !voiceIsShow;
}

-(void)beginRecord
{
    if(recording)return;
    
    recording=YES;
    
    NSDictionary *settings=[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithFloat:8000],AVSampleRateKey,
                            [NSNumber numberWithInt:kAudioFormatLinearPCM],AVFormatIDKey,
                            [NSNumber numberWithInt:1],AVNumberOfChannelsKey,
                            [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                            nil];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *fileName = [NSString stringWithFormat:@"rec_%@.wav",[dateFormater stringFromDate:now]];
    recorderFileName = fileName;
    NSString *filePath=[self documentPathWith:fileName];
    recorderUrl = filePath;
    NSURL *fileUrl=[NSURL fileURLWithPath:filePath];
    NSError *error;
    recorder=[[AVAudioRecorder alloc]initWithURL:fileUrl settings:settings error:&error];
    [recorder prepareToRecord];
    [recorder setMeteringEnabled:YES];
    [recorder peakPowerForChannel:0];
    [recorder record];
    
}

-(void)finishRecord
{
    recording=NO;
    [recorder stop];
    recorder=nil;
    
    NSString *amrFileName = [[[recorderFileName componentsSeparatedByString:@"."] objectAtIndex:0] stringByAppendingString:@".amr"];
    NSString *filePath=[self documentPathWith:amrFileName];

    if ([VoiceConverter wavToAmr:recorderUrl amrSavePath:filePath] == 0) {
        NSLog(@"转换失败!");
        [self delFile:recorderUrl];
        return;
    }
    [self delFile:recorderUrl];
    
    [self sendMsg:[NSData dataWithContentsOfFile:filePath]andType:@"voice"];
    
    NSLog(@"转换成功!");
}


- (NSString *)documentPathWith:(NSString *)fileName
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
}

- (void)delFile:(NSString *)filePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager removeItemAtPath:filePath error:nil];
}

- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [voiceImageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
    
    double cTime = recorder.currentTime;
    if (cTime > 60) {//如果录制时间最长60秒钟
        [self btnUp:nil];
    }
}

#pragma mark-
- (void) initScrollView
{
    //创建表情键盘
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
        for (int i=0; i<6; i++) {
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(33, 43)];
            fview.delegate=self;
            [scrollView addSubview:fview];
        }
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(320*6, keyboardHeight);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    [self.view addSubview:scrollView];
    if (iPhone5) {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, self.view.frame.size.height-100, 150, 30)];
    }
    else
    {
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, self.view.frame.size.height-180, 150, 30)];
    }

    [pageControl setCurrentPage:0];
    pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
    pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
    pageControl.numberOfPages = 6;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.hidden=YES;
    [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
}

//pagecontroll的委托方法

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

-(void)disFaceKeyboard{
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, keyboardHeight)];
        }];
        [self.messageField becomeFirstResponder];
        [pageControl setHidden:YES];
        
        if ([self.faceBtn.imageView.image isEqual:[UIImage imageNamed:@"chat_bottom_smile"]] && IOS7) {
            [UIView animateWithDuration:Time animations:^{
                
                [self.messageField resignFirstResponder];
                if (!IOS7) {
                    [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight + 45,self.view.frame.size.width, keyboardHeight)];
                }
                else{
                    [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight,self.view.frame.size.width, keyboardHeight)];
                }
                [pageControl setHidden:NO];
                keyboardIsShow = NO;
            }];
        }
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            self.tool_bar.frame = CGRectMake(0, self.view.frame.size.height-keyboardHeight-self.tool_bar.frame.size.height,  self.view.bounds.size.width,self.tool_bar.frame.size.height);
        }];
        
        [UIView animateWithDuration:Time animations:^{
            if (!IOS7) {
                [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight + 45,self.view.frame.size.width, keyboardHeight)];
            }
            else{
                [scrollView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight,self.view.frame.size.width, keyboardHeight)];
            }
        }];
        
        [pageControl setHidden:NO];
        [self.messageField resignFirstResponder];
    }
    
}
#pragma mark 隐藏键盘
-(void)dismissKeyBoard{
    //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
    [UIView animateWithDuration:Time animations:^{
        self.tool_bar.frame = CGRectMake(0, self.view.frame.size.height-self.tool_bar.frame.size.height,  self.view.bounds.size.width,self.tool_bar.frame.size.height);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        [scrollView setFrame:CGRectMake(0, self.view.frame.size.height,self.view.frame.size.width, keyboardHeight)];
        self.tableView.transform = CGAffineTransformIdentity;
        self.view.transform = CGAffineTransformIdentity;
        self.navigationController.toolbar.transform = CGAffineTransformIdentity;
        [self.messageField resignFirstResponder];
    }];
    [pageControl setHidden:YES];
    [self.faceBtn setImage:[UIImage imageNamed:@"chat_bottom_smile"] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str
{
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.messageField.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[self.messageField.text substringFromIndex:self.messageField.text.length-2]]) {
                newStr=[self.messageField.text substringToIndex:self.messageField.text.length-2];
                self.messageField.text=newStr;
            }else{
                 NSMutableString *text = [NSMutableString stringWithString:self.messageField.text];
                [text replaceOccurrencesOfRegex:@"\\[([^\\]]+?)\\]"
                                             usingBlock:
                 ^NSString *(NSInteger captureCount,
                             NSString * const capturedStrings[],
                             const NSRange capturedRanges[],
                             volatile BOOL * const stop) {
                     NSString *face = [NSString stringWithFormat:@"[%@]",capturedStrings[captureCount - 1]] ;
                     [self getDelFace:face];
                      return @"";
                 }];
            }
        }
    }else{
        [faceArray addObject:str];
        lastFace = str;
        NSString *newStr=[NSString stringWithFormat:@"%@%@",self.messageField.text,str];
        [self.messageField setText:newStr];
    }
}


- (void)getDelFace:(NSString *)face
{
    if ([lastFace isEqualToString:face]) {
        if (self.messageField.text.length == face.length) {
            self.messageField.text = nil;
        }
        else{
            self.messageField.text = [self.messageField.text substringToIndex:(self.messageField.text.length - face.length)];
        }
        [faceArray removeObject:lastFace];
        if ([faceArray count]) {
            lastFace = [faceArray objectAtIndex:[faceArray count]-1];
        }
    }
}

- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [self.tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [self.tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}

- (void)btn_content_click:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *type = btn.accessibilityHint;
    NSString *srcUrl = btn.accessibilityIdentifier;
    if ([type isEqualToString:@"voice"]) {
        voice_image = [[btn subviews] objectAtIndex:[btn.subviews count]-1];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@&token=%@",BASE_URL,srcUrl,[[RRToken getInstance] getProperty:@"tokensn"]]];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:@"voice"];
        NSFileManager * fm = [NSFileManager defaultManager];
        if (![fm fileExistsAtPath:fileDirectory])
        {
            [fm createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *path = [fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.amr",[RWDidist getCurrentTime]]];
        NSString *desPath = [fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[RWDidist getCurrentTime]]];

        if (![DownloadManager readFromFile:path]) {
            [url downloadWithDelegate:self Title:nil WithToFileName:path];
        }
        else{
            [self amrToWavFrom:path To:desPath];
        }
    }
}

- (void) btn_avatar_click:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSUInteger msgtype = [btn.accessibilityIdentifier integerValue];

    NSString *uid;
    if (0 == msgtype) {
        return;
    }
    else {
        uid = fromMemberId;
    }
    MemberDetailViewController *ctrl = [[MemberDetailViewController alloc] initWithNibName:@"MemberDetailViewController" bundle:nil];
    ctrl.uid = uid;
    if ([type length]) {
        ctrl.type = type;
    }
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

#pragma mark -
- (void)loadData
{
    if ([_allMessagesFrame count] == 0) {
        [SVProgressHUD showWithStatus:@"数据加载中..."];
    }
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, TALK_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:@"1" forKey:@"pageIndex"];
	[req setParam:@"20" forKey:@"pageSize"];
    if (self.userId)
        [req setParam:self.userId forKey:@"userId"];
    if (self.msgId)
        [req setParam:self.msgId forKey:@"minId"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    
    NSLog(@"%@",json);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        [self updateTableView];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        [self updateTableView];
        return;
    }
    [SVProgressHUD dismiss];
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue] + 1;
    maxId = [data objectForKey:@"maxId"];
    minId = [data objectForKey:@"minId"];
    toMemberId = [data objectForKey:@"publicMemberId"];
    type = [data objectForKey:@"type"];

    [buffer removeAllObjects];
    [buffer addObjectsFromArray:arr];
    arr = [self filtBufferWithArray:buffer];
    NSString *previousTime = nil;
    [_allMessagesFrame removeAllObjects];
    for (NSDictionary *dict in arr) {
        
        if ([fromMemberId length] == 0) {
            fromMemberId = [dict objectForKey:@"fromMemberId"];
        }

        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        previousTime = message.time;
        messageFrame.message = message;
        [_allMessagesFrame addObject:messageFrame];
    }
    [RWHomeCache writeToFile:[NSMutableArray arrayWithArray:arr] withName:self.userId];
    [self updateTableView];
    [self scrollTableToFoot:NO];
}

- (void)loadOld
{
    if ([minId length] == 0) {
        [self updateTableView];
        return;
    }
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, TALK_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:@"20" forKey:@"pageSize"];
    [req setParam:self.userId forKey:@"userId"];
    [req setParam:minId forKey:@"minId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoadOld:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onLoadOld: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [SVProgressHUD showErrorWithStatus:@"暂无数据!" duration:1.5f];
        [self updateTableView];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [self updateTableView];
        return;
    }
    pageIndex = [[data objectForKey:@"pageIndex"] integerValue] + 1;
    minId = [data objectForKey:@"minId"];
    [buffer addObjectsFromArray:arr];
    arr = [self filtBufferWithArray:buffer];
    
    NSString *previousTime = nil;
    
    _allMessagesFrame = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        previousTime = message.time;
        messageFrame.message = message;
        [_allMessagesFrame addObject:messageFrame];
    }
    
    [self updateTableView];
}

- (void)updataMsg
{
    if ([maxId length] == 0) {
        return;
    }
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, TALK_DETAIL_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:self.userId forKey:@"userId"];
    [req setParam:maxId forKey:@"maxId"];
	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUpdataMsg:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onUpdataMsg: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    
    NSLog(@"%@",json);
    
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
        [self updateTableView];
		return;
	}
    
    NSDictionary *data = [json objectForKey:@"data"];
    NSArray *arr = [data objectForKey:@"records"];
    if ([arr count] == 0) {
        [self updateTableView];
        return;
    }
    
    maxId = [data objectForKey:@"maxId"];
    [buffer removeObjectAtIndex:[buffer count]-1];
    [buffer addObjectsFromArray:arr];
    arr = [self filtBufferWithArray:buffer];
    NSString *previousTime = nil;
    _allMessagesFrame = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        
        MessageFrame *messageFrame = [[MessageFrame alloc] init];
        Message *message = [[Message alloc] init];
        message.dict = dict;
        messageFrame.showTime = ![previousTime isEqualToString:message.time];
        
        previousTime = message.time;
        messageFrame.message = message;
        [_allMessagesFrame addObject:messageFrame];
    }
    [self.tableView reloadData];
    [self scrollTableToFoot:NO];
}


- (void)sendMsg:(NSString *)msg
{
    if ([self.userId length] == 0) {
        return;
    }
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_MSG_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
	[req setParam:msg forKey:@"content"];
    [req setParam:self.userId forKey:@"toUserId"];
    NSLog(@"--- -- %@",self.userId);

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSend:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void)sendMsg:(NSData *)data andType:(NSString *)type
{
    if ([self.userId length] == 0) {
        return;
    }
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, SEND_MULTIMSG_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    if ([type isEqual:@"voice"]) {
        [RRURLRequest setFlag:YES];
    }
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    NSDictionary *dic = @{@"toUserId": self.userId,@"type":type,@"storeId":[token getProperty:@"storeId"]};
    NSString *args = [dic JSONRepresentation];
    [req setParam:args forKey:@"args"];
    [req setData:data forKey:@"file"];

	[req setHTTPMethod:@"POST"];
	
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onSend:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}


- (void) onSend: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
    
    NSLog(@"%@",json);
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[json objectForKey:@"success"] boolValue])
	{
		return;
	}
    
    [self updataMsg];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"获取数据失败!" afterDelay:1.5f];
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
}

- (NSArray *)filtBufferWithArray:(NSArray *)arr
{
    NSSortDescriptor  *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:YES];
    NSArray *tempArray = [arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    return tempArray;
}

- (void)downloadManagerDataDownloadFinished:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileDirectory = [documentsDirectory stringByAppendingPathComponent:@"voice"];

    NSString *desPath = [fileDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav",[RWDidist getCurrentTime]] ];
    [self amrToWavFrom:fileName To:desPath];
}

- (void)downloadManagerDataDownloadFailed:(NSString *)reason
{
    NSLog(@"%@",reason);
}

- (void)amrToWavFrom:(NSString *)src To:(NSString *)des
{
    [timer invalidate];
    voice_image.hidden = NO;
    
    if ([VoiceConverter amrToWav:src wavSavePath:des] == 0) {
        return;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self
                                           selector:@selector(changeView) userInfo:nil
                                            repeats:YES];

  	NSURL* url = [NSURL fileURLWithPath:des];
    if(audioPlayer)
    {
        [audioPlayer stop];
        audioPlayer = nil;
    }
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
    audioPlayer.delegate = self;
    //准备播放
    [audioPlayer prepareToPlay];
    [audioPlayer play];
    
}

#pragma mark - AVAudioPlayer delegate

- (void)changeView
{
    voice_image.hidden = !voice_image.hidden;
}

//播放结束调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [timer invalidate];
    voice_image.hidden = NO;
}

- (void)cleanCache
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
	NSString *document_directory=[paths objectAtIndex:0];
	NSFileManager *file_manager = [NSFileManager defaultManager];
	NSString *file_path = nil;
	NSArray *cache_files = [file_manager contentsOfDirectoryAtPath:document_directory error:NULL];
	for (int i=0; i<[cache_files count]; i++)
	{
		NSString *str = [cache_files objectAtIndex:i];
		if ([str hasPrefix:@"voice"])
		{
			file_path = [document_directory stringByAppendingPathComponent:[cache_files objectAtIndex:i]];
			[file_manager removeItemAtPath:file_path error:NULL];
		}
	}
}

#pragma mark - LXActionSheetDelegate

- (void)didClickOnButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *ctrl_img_picker = [[UIImagePickerController alloc] init];
	ctrl_img_picker.delegate = self;
	ctrl_img_picker.allowsEditing = NO;
    
	if (0 == buttonIndex)
	{
		ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
		ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
		ctrl_img_picker.allowsEditing = NO;
        ctrl_img_picker.navigationController.delegate = self;
        [self presentViewController:ctrl_img_picker animated:YES completion:nil];
        
	}
	else if (1 == buttonIndex)
	{
		if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO)
		{
			UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil
														 message:@"无法使用相机。可能此机器没有配备照相设备。"
														delegate:self
											   cancelButtonTitle:@"确定"
											   otherButtonTitles:nil];
			[av show];
			return;
		}
		
		ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
		ctrl_img_picker.allowsEditing = NO;
        [self presentViewController:ctrl_img_picker animated:YES completion:nil];
	}
}

- (void)didClickOnDestructiveButton
{
    
}

- (void)didClickOnCancelButton
{
    
}

#pragma mark UIImagePickerControllerDelegate

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *img = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
	
	if (UIImagePickerControllerSourceTypeCamera == picker.sourceType)
	{
		UIImageWriteToSavedPhotosAlbum(img, nil, nil , nil);
	}
	
	CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
	CGFloat scale = 1.0f;
	
	if (rect.size.width > 1000.0f || rect.size.height > 1000.0f)
	{
		if (rect.size.width > rect.size.height)
		{
			scale = 1000.0f / rect.size.width;
		}
		else
		{
			scale = 1000.0f / rect.size.height;
		}
	}
	
	UIGraphicsBeginImageContext(rect.size);
	UIGraphicsBeginImageContextWithOptions(rect.size, YES, scale);
	[img drawInRect:rect];
	UIImage *new_img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	NSData *data_avatar = UIImageJPEGRepresentation(new_img, 0.5f);
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [self sendMsg:data_avatar andType:@"image"];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}


@end
