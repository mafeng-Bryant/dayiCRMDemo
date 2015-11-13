//
//  CompileMemberMsgViewController.m
//  dayiCRM
//
//  Created by Fang on 14-4-21.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "CompileMemberMsgViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "AgeGroupViewController.h"

@interface CompileMemberMsgViewController ()

@end

@implementation CompileMemberMsgViewController
@synthesize dict,delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([dict count]) {
        self.title = @"编辑资料";
    }
    else {
        self.title = @"添加会员";
        if (delegate) {
            self.title = @"添加执行人";
        }
    }
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_save;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_save = [[UIBarButtonItem alloc] initWithTitle:@"保存"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_save_click:)];
        UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
        self.navigationItem.backBarButtonItem = backBtn;
        
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
        [save setTitle:@"保存" forState:UIControlStateNormal];
        [save setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [save addTarget:self action:@selector(btn_save_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_save = [[UIBarButtonItem alloc] initWithCustomView:save];
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    gender = [dict objectForKey:@"gender"];
    ageGroup = [dict objectForKey:@"ageGroup"];
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_save;

}

- (void)dealloc
{
    self.view=nil;
    avatar = nil;
    tf_nickname = nil;
    tf_telnumber = nil;
    tv_remark = nil;
    tf_address = nil;
    avatarId = nil;
    dict = nil;
    data_avatar = nil;
    delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if([self isViewLoaded] && self.view.window == nil)
    {
        self.view = nil;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (delegate) {
        return 8;
    }
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"empty_cell";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cell_id];
    }
    
    UIFont *font = [UIFont systemFontOfSize:15.0f];
    
    if (!IOS7)
    {
        UIImage *originalImage = [UIImage imageNamed:@"checkBox"];
        UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        
        UIImage *originalImageSelected = [UIImage imageNamed:@"city_btn_selected"];
        UIImage *stretchableImageSelected = [originalImageSelected resizableImageWithCapInsets:insets];
        
        UIImageView *messageBackgroundView = [[UIImageView alloc] initWithImage:stretchableImage];
        messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 44);
        if (0 == indexPath.row) {
            messageBackgroundView.frame = CGRectMake(0.0f, -1.0f, 300.0f, 60);
        }
        [cell.contentView insertSubview:messageBackgroundView belowSubview:cell.textLabel];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:stretchableImageSelected];
    }

    switch (indexPath.row) {
        case 1:
            cell.textLabel.text = @"性别";
            
            if (!male_box) {
                male_box = [[QCheckBox alloc] initWithDelegate:self];
                male_box.frame = CGRectMake(180, 2, 80, 40);
                [male_box setTitle:@"男" forState:UIControlStateNormal];
                [male_box setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [male_box.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [male_box setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
                [male_box setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
                [cell.contentView addSubview:male_box];
                [male_box setChecked:NO];
                if ([[dict objectForKey:@"gender"] integerValue] == 1) {
                    [male_box setChecked:YES];
                }
            }
            
            if (!femal_box) {
                femal_box = [[QCheckBox alloc] initWithDelegate:self];
                femal_box.frame = CGRectMake(260, 2, 80, 40);
                [femal_box setTitle:@"女" forState:UIControlStateNormal];
                [femal_box setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                [femal_box.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
                [femal_box setImage:[UIImage imageNamed:@"uncheck_icon.png"] forState:UIControlStateNormal];
                [femal_box setImage:[UIImage imageNamed:@"check_icon.png"] forState:UIControlStateSelected];
                [cell.contentView addSubview:femal_box];
                [femal_box setChecked:NO];
                if ([[dict objectForKey:@"gender"] integerValue] == 2) {
                    [femal_box setChecked:YES];
                }
            }
            break;
        case 2:
            cell.textLabel.text = @"年龄段";
            if (!lb_age) {
                lb_age = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                lb_age.backgroundColor = [UIColor clearColor];
                lb_age.textAlignment = NSTextAlignmentRight;
                lb_age.font = font;
                lb_age.textColor = [UIColor lightGrayColor];
                lb_age.text = @"请选择";
                if ([[dict objectForKey:@"ageGroup"] integerValue]) {
                    ageGroup = [dict objectForKey:@"ageGroup"];
                }
                [cell.contentView addSubview:lb_age];
            }
            if ([ageGroup integerValue] > 0) {
                
                lb_age.textColor = [UIColor darkGrayColor];
                
                switch ([ageGroup integerValue]) {
                    case 1:
                        lb_age.text = @"20岁以下";
                        break;
                    case 2:
                        lb_age.text = @"20岁-29岁";
                        break;
                    case 3:
                        lb_age.text = @"30岁-39岁";
                        break;
                    case 4:
                        lb_age.text = @"40岁-45岁";
                        break;
                    case 5:
                        lb_age.text = @"46岁-50岁";
                        break;
                    case 6:
                        lb_age.text = @"51岁-55岁";
                        break;
                    case 7:
                        lb_age.text = @"56岁-60岁";
                        break;
                    case 8:
                        lb_age.text = @"61岁-65岁";
                        break;
                    case 9:
                        lb_age.text = @"66岁-70岁";
                        break;
                    case 10:
                        lb_age.text = @"70岁以上";
                        break;
                    default:
                        break;
                }
            }
            break;
        case 0:
            cell.textLabel.text = @"姓名";
            if (!tf_name) {
                tf_name = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_name.placeholder = @"请输入姓名";
                tf_name.borderStyle = UITextBorderStyleNone;
                tf_name.backgroundColor = [UIColor clearColor];
                tf_name.textAlignment = NSTextAlignmentRight;
                tf_name.font = font;
                tf_name.textColor = [UIColor darkGrayColor];
                tf_name.delegate = self;
                tf_name.returnKeyType = UIReturnKeyDone;
                if (dict) {
                    tf_name.text = [dict objectForKey:@"name"];
                }
                [cell.contentView addSubview:tf_name];
            }
            
            break;
        case 3:
            cell.textLabel.text = @"手机号码";
            if (!tf_telnumber) {
                tf_telnumber = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_telnumber.placeholder = @"请输入手机号";
                tf_telnumber.borderStyle = UITextBorderStyleNone;
                tf_telnumber.backgroundColor = [UIColor clearColor];
                tf_telnumber.textAlignment = NSTextAlignmentRight;
                tf_telnumber.font = font;
                tf_telnumber.delegate = self;
                tf_telnumber.textColor = [UIColor darkGrayColor];
                tf_telnumber.returnKeyType = UIReturnKeyNext;
                if (dict) {
                    tf_telnumber.text = [dict objectForKey:@"mobile"];
                }
                [cell.contentView addSubview:tf_telnumber];
            }

            break;
        case 4:
            cell.textLabel.text = @"邮箱";
            if (!tf_email) {
                tf_email = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_email.placeholder = @"请输入邮箱地址";
                tf_email.borderStyle = UITextBorderStyleNone;
                tf_email.backgroundColor = [UIColor clearColor];
                tf_email.textAlignment = NSTextAlignmentRight;
                tf_email.font = font;
                tf_email.delegate = self;
                tf_email.textColor = [UIColor darkGrayColor];
                tf_email.returnKeyType = UIReturnKeyNext;
                if (dict) {
                    tf_email.text = [dict objectForKey:@"email"];
                }
                [cell.contentView addSubview:tf_email];
            }
            
            break;
        case 5:
            cell.textLabel.text = @"新浪微博";
            if (!tf_sinaWeibo) {
                tf_sinaWeibo = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_sinaWeibo.placeholder = @"请输入新浪微博账号";
                tf_sinaWeibo.borderStyle = UITextBorderStyleNone;
                tf_sinaWeibo.backgroundColor = [UIColor clearColor];
                tf_sinaWeibo.textAlignment = NSTextAlignmentRight;
                tf_sinaWeibo.font = font;
                tf_sinaWeibo.delegate = self;
                tf_sinaWeibo.textColor = [UIColor darkGrayColor];
                tf_sinaWeibo.returnKeyType = UIReturnKeyNext;
                if (dict) {
                    tf_sinaWeibo.text = [dict objectForKey:@"sinaWeibo"];
                }
                [cell.contentView addSubview:tf_sinaWeibo];
            }
            
            break;
        case 6:
            cell.textLabel.text = @"腾讯微博";
            if (!tf_qqWeibo) {
                tf_qqWeibo = [[UITextField alloc] initWithFrame:CGRectMake(50, 5, 240, 30)];
                tf_qqWeibo.placeholder = @"请输入腾讯微博账号";
                tf_qqWeibo.borderStyle = UITextBorderStyleNone;
                tf_qqWeibo.backgroundColor = [UIColor clearColor];
                tf_qqWeibo.textAlignment = NSTextAlignmentRight;
                tf_qqWeibo.font = font;
                tf_qqWeibo.delegate = self;
                tf_qqWeibo.textColor = [UIColor darkGrayColor];
                tf_qqWeibo.returnKeyType = UIReturnKeyDone;
                if (dict) {
                    tf_qqWeibo.text = [dict objectForKey:@"tencentWeibo"];
                }
                [cell.contentView addSubview:tf_qqWeibo];
            }
            
            break;

        default:
            break;
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = font;
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (0 == indexPath.row) {
//        return 60;
//    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (0 == indexPath.row) {
//        [active_tf resignFirstResponder];
//        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从相册中选取",@"从相机拍摄"]];
//        [actionSheet showInView:self.tableView];
//
//    }
//    else if (2 == indexPath.row){
     if (2 == indexPath.row){
        AgeGroupViewController *ctrl = [[AgeGroupViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.delegate = self;
        ctrl.ageGroup = ageGroup;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark event handle

- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)btn_save_click:(id)sender
{
    [active_tf resignFirstResponder];
    if ([tf_name.text length] == 0) {
        [self.view.window makeToast:@"姓名不能为空!"];
        return;
    }
    if ([tf_telnumber.text length] == 0) {
        [self.view.window makeToast:@"手机号码不能为空!"];
        return;
    }
    if (![self isValidateMobile:tf_telnumber.text]) {
        [self.view.window makeToast:@"手机号码不符合规定!"];
        return;
    }
    if (![self isEmailAddress:tf_email.text]) {
        [self.view.window makeToast:@"邮箱地址不符合规定!"];
        return;
    }

    if (data_avatar)
    {
        [self uploadImage];
        return;
    }
    
    if ([dict count]) {
        [self updateMember];
    }
    else {
        if (delegate) {
            //                self.title = @"添加执行人";
            [self addExcetor];
            return;
        }
        [self addMember];
    }

}

#pragma mark -
#pragma UITextFieldDelegate

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSRange range;
    range.location = 0;
    range.length  = 0;
    textView.selectedRange = range;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    active_tf = textField;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:tf_name]) {
        [tf_nickname becomeFirstResponder];
    }
    else if ([textField isEqual:tf_nickname]) {
        [tf_telnumber becomeFirstResponder];
    }
    else if ([textField isEqual:tf_telnumber]) {
        [tf_email becomeFirstResponder];
    }
    else if ([textField isEqual:tf_email]) {
        [tf_sinaWeibo becomeFirstResponder];
    }
    else if ([textField isEqual:tf_sinaWeibo]) {
        [tf_qqWeibo becomeFirstResponder];
    }

    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if (delegate) {
            [tf_address becomeFirstResponder];
        }
        return NO;
    }
    return YES;
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
	if (avatar)
	{
		avatar = nil;
	}
	avatar.image = new_img;
	data_avatar = UIImageJPEGRepresentation(new_img, 0.2f);
	[self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

- (void) uploadImage
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPLOAD_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setData:data_avatar forKey:@"file"];
	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUploadImage:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onUploadImage: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	
	NSDictionary *json = [loader getJSONData];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    if ([json objectForKey:@"pictureId"]) {
        avatarId =[json objectForKey:@"pictureId"];
    }
    
    if ([dict count]) {
        [self updateMember];
    }
    else {
        if (delegate) {
            //                self.title = @"添加执行人";
            return;
        }
        if ([tv_remark.text length] == 0) {
            [self.view.window makeToast:@"备注不能为空!"];
            return;
        }
        [self addMember];
    }

}

- (void) updateMember
{
    [SVProgressHUD showWithStatus:@"数据上传中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPDATE_MEMBER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    if (tf_telnumber.text) {
        [req setParam:tf_telnumber.text forKey:@"mobile"];
    }
    if (tf_name.text) {
        [req setParam:tf_name.text forKey:@"name"];
    }
    if (tf_nickname.text) {
        [req setParam:tf_nickname.text forKey:@"nickName"];
    }
    if ([ageGroup integerValue]) {
        [req setParam:ageGroup forKey:@"ageGroup"];
    }
    if (avatarId) {
        [req setParam:avatarId forKey:@"avatarId"];
    }
    if (tv_remark.text) {
        [req setParam:tv_remark.text forKey:@"description"];
    }
    if ([gender length]) {
        [req setParam:gender forKey:@"gender"];
    }
    if (tf_email.text) {
        [req setParam:tf_email.text forKey:@"email"];
    }
    if (tf_sinaWeibo.text) {
        [req setParam:tf_sinaWeibo.text forKey:@"sinaWeibo"];
    }
    if (tf_qqWeibo.text) {
        [req setParam:tf_qqWeibo.text forKey:@"tencentWeibo"];
    }
    [req setParam:[dict objectForKey:@"id"] forKey:@"id"];
	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onAddMember:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) addExcetor
{
    [SVProgressHUD showWithStatus:@"数据上传中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, ADD_EMPLOYEE_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:tf_telnumber.text forKey:@"mobile"];
    [req setParam:tf_nickname.text forKey:@"name"];
    if (avatarId) {
        [req setParam:avatarId forKey:@"avatarId"];
    }
    if (tv_remark.text) {
        [req setParam:tv_remark.text forKey:@"remark"];
    }
    
	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onAddMember:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];

}

- (void) addMember
{
    [SVProgressHUD showWithStatus:@"数据上传中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, IMPORT_MEMBER_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:tf_telnumber.text forKey:@"mobile"];
    [req setParam:tf_name.text forKey:@"name"];
    if (avatarId) {
        [req setParam:avatarId forKey:@"avatarId"];
    }
    if (tf_nickname.text) {
        [req setParam:tf_nickname.text forKey:@"nickName"];
    }
    
    if (tf_email.text) {
        [req setParam:tf_email.text forKey:@"email"];
    }
    if (tf_sinaWeibo.text) {
        [req setParam:tf_sinaWeibo.text forKey:@"sinaWeibo"];
    }
    if (tf_qqWeibo.text) {
        [req setParam:tf_qqWeibo.text forKey:@"tencentWeibo"];
    }
    if ([ageGroup integerValue]) {
        [req setParam:ageGroup forKey:@"ageGroup"];
    }
    if (tv_remark.text) {
        [req setParam:tv_remark.text forKey:@"remark"];
    }
    if ([gender length]) {
        [req setParam:gender forKey:@"gender"];
    }
	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onAddMember:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];

}

- (void) onAddMember: (NSNotification *)notify
{
	RRLoader *loader = (RRLoader *)[notify object];
	NSDictionary *json = [loader getJSONData];
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
	
	//login fail
	if (![[[json objectForKey:@"data"] objectForKey:@"operationState"] isEqualToString:@"success"])
	{
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
		return;
	}
    [SVProgressHUD dismissWithSuccess:@"添加成功!"];
    [self performSelector:@selector(dismissViewController) withObject:nil afterDelay:1.0f];
    
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"网络请求失败!"];

	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
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
	
	[avatar setImage:empty_image];
}

- (void) remoteImageDidLoaded:(RRRemoteImage *)remoteImage newImage:(UIImage *)newImage
{
	[avatar setImage:newImage];
	
	[RRImageBuffer writeToFile:newImage withName:remoteImage.url];
}

#pragma mark - QCheckBoxDelegate

- (void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked {
    NSLog(@"did tap on CheckBox:%@ checked:%d", checkbox.titleLabel.text, checked);
    if ([checkbox isEqual:femal_box]) {
        [male_box setChecked:!checked];
        [femal_box setChecked:checked];
        if (checkbox)
            gender = @"2";
        else
            gender = @"1";
    }
    else if ([checkbox isEqual:male_box]) {
        [femal_box setChecked:!checked];
        [male_box setChecked:checked];

        if (checkbox)
            gender = @"1";
        else
            gender = @"2";
    }

}

- (void)ageGroupDidSelected:(NSString *)index
{
    ageGroup = index;
    [self.tableView reloadData];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

-(BOOL) isEmailAddress:(NSString*)email
{
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


- (void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
