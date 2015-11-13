//
//  EditProfileViewController.m
//  dayiCRM
//
//  Created by Fang on 14-10-11.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "EditProfileViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "RRImageBuffer.h"
#import "RRRemoteImage.h"
#import "Toast+UIView.h"
#import "UrlImageView.h"
#import "LXActionSheet.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
@synthesize dict;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"编辑信息";
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_save;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_save = [[UIBarButtonItem alloc] initWithTitle:@"保存"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_save_click:)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancel = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
        [tel setTitle:@"保存" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_save_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_save = [[UIBarButtonItem alloc] initWithCustomView:tel];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    self.navigationItem.rightBarButtonItem = btn_save;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(0 == section){
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cell_id = [NSString stringWithFormat:@"cell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    UIFont *fnt = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    UIFont *textFnt = [UIFont fontWithName:@"Helvetica" size:14.0f];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = fnt;
    
    if (0 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"头像";
                if (!im_avatar) {
                    im_avatar = [[UrlImageView alloc] initWithFrame:CGRectMake(245, 5, 65, 65)];
                    [im_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dict objectForKey:@"avatarId"]]];
                    [cell.contentView addSubview:im_avatar];
                }
                break;
            case 1:
                cell.textLabel.text = @"名称";
                if (!tf_name) {
                    tf_name = [[UITextField alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                    tf_name.textAlignment = NSTextAlignmentRight;
                    tf_name.textColor = [UIColor lightGrayColor];
                    tf_name.font = textFnt;
                    tf_name.backgroundColor = [UIColor clearColor];
                    tf_name.returnKeyType = UIReturnKeyNext;
                    tf_name.text = [dict objectForKey:@"userName"];
                    [cell.contentView addSubview:tf_name];
                }
                break;
            case 2:
                cell.textLabel.text = @"手机号";
                if (!tf_mobile) {
                    tf_mobile = [[UITextField alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                    tf_mobile.textAlignment = NSTextAlignmentRight;
                    tf_mobile.textColor = [UIColor lightGrayColor];
                    tf_mobile.font = textFnt;
                    tf_mobile.returnKeyType = UIReturnKeyDone;
                    tf_mobile.backgroundColor = [UIColor clearColor];
                    tf_mobile.text = [dict objectForKey:@"loginName"];
                    [cell.contentView addSubview:tf_mobile];
                }
                break;
            default:
                break;
        }
    }
    
    else if (1 == indexPath.section) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"性别";
                if (!lb_gender) {
                    lb_gender = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                    lb_gender.textAlignment = NSTextAlignmentRight;
                    lb_gender.textColor = [UIColor lightGrayColor];
                    lb_gender.font = textFnt;
                    lb_gender.backgroundColor = [UIColor clearColor];
                    if ([[dict objectForKey:@"gender"]integerValue] == 1) {
                        lb_gender.text = @"男";
                    }
                    else if ([[dict objectForKey:@"gender"]integerValue] == 2) {
                        lb_gender.text = @"女";
                    }
                    else{
                        lb_gender.text = @"未知";
                    }
                    [cell.contentView addSubview:lb_gender];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;

                break;
            case 1:
                cell.textLabel.text = @"地区";
                if (!lb_region) {
                    lb_region = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 240, 30)];
                    lb_region.textAlignment = NSTextAlignmentRight;
                    lb_region.textColor = [UIColor lightGrayColor];
                    lb_region.font = textFnt;
                    lb_region.backgroundColor = [UIColor clearColor];
                    lb_region.text = [dict objectForKey:@"region"];
                    [cell.contentView addSubview:lb_region];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                break;
            default:
                break;
        }
    }
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && 0 == indexPath.row) {
        return 75;
    }
    return 44.0f;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(0 == indexPath.section && 0 == indexPath.row){
        LXActionSheet *actionSheet = [[LXActionSheet alloc]initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"从手机相册",@"从相机获取"]];
        [actionSheet showInView:self.tableView];
    }
    else if(1 == indexPath.section ){
        selectedIndex = indexPath.row;
        ConditionSelectedViewController *ctrl = [[ConditionSelectedViewController alloc] initWithStyle:UITableViewStyleGrouped];
        ctrl.delegate = self;
        if (0 == indexPath.row) {
            ctrl.titleName = @"选择性别";
            conditionArray = @[@"未知",@"男",@"女"];
        }
        else if (1 == indexPath.row) {
            ctrl.titleName = @"选择地区";
            conditionArray = @[@"华北",@"华南",@"华东",@"华中",@"东北",@"西北",@"西南"];
        }
        [ctrl setUpBuffer:conditionArray];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"]forBarMetrics:UIBarMetricsDefault];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }

}

- (void)conditionDidSelectedIndex:(NSUInteger)index
{
    if (0 == selectedIndex) {
        lb_gender.text = [conditionArray objectAtIndex:index];
        gender = [NSString stringWithFormat:@"%lu",(unsigned long)index ];
    }
    else{
        lb_region.text = [conditionArray objectAtIndex:index];
    }
}

#pragma mark -
#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([textField isEqual:tf_name]) {
        [tf_mobile becomeFirstResponder];
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
    im_avatar.image = new_img;
    UIGraphicsEndImageContext();
    avatar_data = UIImageJPEGRepresentation(new_img, 0.5f);
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

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_save_click:(id)sender
{
    if([avatar_data length]){
        [self uploadImage];
    }
    else{
        [SVProgressHUD showWithStatus:@"数据上传中"];
        [self updateMember];
    }
}

- (void) uploadImage
{
    [SVProgressHUD showWithStatus:@"数据上传中"];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPLOAD_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setData:avatar_data forKey:@"file"];
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
    [self updateMember];
}

- (void) updateMember
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPDATE_INFORMATION_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    if (avatarId) {
        [req setParam:avatarId forKey:@"avatarId"];
    }
    if ([gender length]) {
        [req setParam:gender forKey:@"gender"];
    }
    if ([tf_name.text length]) {
        [req setParam:tf_name.text forKey:@"userName"];
    }
    if ([lb_region.text length]) {
        [req setParam:lb_region.text forKey:@"region"];
    }
    if ([tf_mobile.text length] && ![[dict objectForKey:@"mobile"] isEqualToString:tf_mobile.text]) {
        [req setParam:tf_mobile.text forKey:@"mobile"];
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
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",json);
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [SVProgressHUD dismiss];
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    [SVProgressHUD dismissWithSuccess:@"修改成功!"];
}


- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismissWithError:@"网络请求失败!"];
    
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}

@end
