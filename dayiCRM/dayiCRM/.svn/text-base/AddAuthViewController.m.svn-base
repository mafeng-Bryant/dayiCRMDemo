//
//  AddAuthViewController.m
//  dayiCRM
//
//  Created by Fang on 14/11/16.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "AddAuthViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define ORIGINAL_MAX_WIDTH 640.0f

@interface AddAuthViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>


@end

@implementation AddAuthViewController
@synthesize authId;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    UIBarButtonItem *btn_cancel;
    UIBarButtonItem *btn_edit;
    if (IOS7) {
        btn_cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_edit = [[UIBarButtonItem alloc] initWithTitle:@"提交"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_edit_click:)];
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
        
        UIButton *tel = [UIButton buttonWithType:UIButtonTypeCustom];
        [tel setTitle:@"提交" forState:UIControlStateNormal];
        [tel setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [tel addTarget:self action:@selector(btn_edit_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_edit = [[UIBarButtonItem alloc] initWithCustomView:tel];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancel;
    if (authId) {
        [self loadData];
        return;
    }
    self.navigationItem.rightBarButtonItem = btn_edit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (0 == section) {
        return 3;
    }
    else if (1 == section){
        return 2;
    }
    return 1;
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
    CGRect textFrame = CGRectMake(80, 5, 210, 30);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = fnt;
    if(![dataDict count])
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (0 == indexPath.section) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"真实姓名";
                if (!tf_realName) {
                    tf_realName = [[UITextField alloc] initWithFrame:textFrame];
                    tf_realName.textAlignment = NSTextAlignmentRight;
                    tf_realName.textColor = [UIColor lightGrayColor];
                    tf_realName.font = textFnt;
                    tf_realName.delegate = self;
                    tf_realName.backgroundColor = [UIColor clearColor];
                    tf_realName.returnKeyType = UIReturnKeyNext;
                    [cell.contentView addSubview:tf_realName];
                }
                if (dataDict) {
                    tf_realName.text = [dataDict objectForKey:@"realName"];
                    tf_realName.enabled = NO;
                }
                break;
            case 1:
                cell.textLabel.text = @"身份证号";
                if (!tf_idCard) {
                    tf_idCard = [[UITextField alloc] initWithFrame:textFrame];
                    tf_idCard.textAlignment = NSTextAlignmentRight;
                    tf_idCard.textColor = [UIColor lightGrayColor];
                    tf_idCard.font = textFnt;
                    tf_idCard.delegate = self;
                    tf_idCard.backgroundColor = [UIColor clearColor];
                    tf_idCard.returnKeyType = UIReturnKeyNext;
                    [cell.contentView addSubview:tf_idCard];
                }
                if (dataDict) {
                    tf_idCard.text = [dataDict objectForKey:@"cardNo"];
                    tf_idCard.enabled = NO;
                }
                break;
            case 2:
                cell.textLabel.text = @"银行卡号";
                if (!tf_bankCard) {
                    tf_bankCard = [[UITextField alloc] initWithFrame:textFrame];
                    tf_bankCard.textAlignment = NSTextAlignmentRight;
                    tf_bankCard.textColor = [UIColor lightGrayColor];
                    tf_bankCard.font = textFnt;
                    tf_bankCard.backgroundColor = [UIColor clearColor];
                    tf_bankCard.returnKeyType = UIReturnKeyDone;
                    tf_bankCard.delegate = self;
                    [cell.contentView addSubview:tf_bankCard];
                }
                if (dataDict) {
                    tf_bankCard.text = [dataDict objectForKey:@"bankCard"];
                    tf_bankCard.enabled = YES;
                }
                break;
 
            default:
                break;
        }
    }
    
    else if (1 == indexPath.section){
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"身份证正面照片";
                if (!im_idCardY) {
                    im_idCardY = [[UrlImageView alloc] initWithFrame:CGRectMake(190, 5, 100, 50)];
                    [cell.contentView addSubview:im_idCardY];
                }
                if (dataDict) {
                    [im_idCardY setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [dataDict objectForKey:@"idCardY"]]]];
                }
                break;
            case 1:
                cell.textLabel.text = @"身份证背面照片";
                if (!im_idCardN) {
                    im_idCardN = [[UrlImageView alloc] initWithFrame:CGRectMake(190, 5, 100, 50)];
                    [cell.contentView addSubview:im_idCardN];
                }
                if (dataDict) {
                    [im_idCardN setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [dataDict objectForKey:@"idCardN"]]]];
                }
                break;
            default:
                break;
        }
    }
    
    else if (2 == indexPath.section){
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textLabel.text = @"银行卡照片";
        if (!im_copyOfBankCard) {
            im_copyOfBankCard = [[UrlImageView alloc] initWithFrame:CGRectMake(190, 5, 100, 50)];
            [cell.contentView addSubview:im_copyOfBankCard];
        }
        if (dataDict) {
            [im_copyOfBankCard setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [dataDict objectForKey:@"copyOfBankCard"]]]];
        }

    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section || 2 == indexPath.section) {
        return 60;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (1 == indexPath.section) {
        if ([authId length]) {
            return;
        }
        pictureType = indexPath.row;
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];

    }
    else if (2 == indexPath.section){
        if ([authId length]) {
            return;
        }
        pictureType = 2;
        UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"从相册中选取", nil];
        [choiceSheet showInView:self.view];
    }
    
}

#pragma mark -
#pragma mark event handle
- (void)btn_cancel_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btn_edit_click:(id)sender
{
    if ([tf_realName.text length] == 0) {
        [self.view makeToast:@"还没有填写真实姓名!"];
        return;
    }
    if ([tf_bankCard.text length] == 0) {
        [self.view makeToast:@"还没有填写银行卡号!"];
        return;
    }
    if ([tf_idCard.text length] == 0) {
        [self.view makeToast:@"还没有填写身份证号!"];
        return;
    }
    
    if ([idCardYId length] == 0) {
        [self.view makeToast:@"还没有上传身份证正面照片!"];
        return;
    }
    if ([idCardNId length] == 0) {
        [self.view makeToast:@"还没有上传身份证背面照片!"];
        return;
    }
    if ([copyOfBankCardId length] == 0) {
        [self.view makeToast:@"还没有上传银行卡照片!"];
        return;
    }

    [self updateActivity];

}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:tf_realName]) {
        [tf_idCard becomeFirstResponder];
    }
    else if ([textField isEqual:tf_idCard]) {
        [tf_bankCard becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    if (pictureType == 0) {
        im_idCardY.image = editedImage;
    }
    else if (pictureType == 1){
        im_idCardN.image = editedImage;
    }
    else if(pictureType == 2){
        im_copyOfBankCard.image = editedImage;
    }
    [self uploadImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)ActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *ctrl_img_picker = [[UIImagePickerController alloc] init];
    ctrl_img_picker.delegate = self;
    ctrl_img_picker.allowsEditing = NO;
    
    if (1 == buttonIndex)
    {
        ctrl_img_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        ctrl_img_picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        ctrl_img_picker.allowsEditing = NO;
        ctrl_img_picker.navigationController.delegate = self;
        [self presentViewController:ctrl_img_picker animated:YES completion:nil];
        
    }
    else if (0 == buttonIndex)
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

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f,self.view.frame.size.width,136) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark loadData

- (void) uploadImage:(UIImage *)image
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPLOAD_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setData:UIImageJPEGRepresentation(image, 0.5f) forKey:@"file"];
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
        if (pictureType == 0) {
           // idCardYId =[@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [json objectForKey:@"pictureId"]];
			idCardYId = [json objectForKey:@"pictureId"];

        }
        else if (pictureType == 1){
            //idCardNId =[@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [json objectForKey:@"pictureId"]];
			idCardNId = [json objectForKey:@"pictureId"];

        }
        else if (pictureType == 2){
          //  copyOfBankCardId =[@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [json objectForKey:@"pictureId"]];
			
			copyOfBankCardId = [json objectForKey:@"pictureId"];

        }

    }
}

- (void) updateActivity
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, APPLY_AUTH_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:tf_realName.text forKey:@"realName"];
    [req setParam:tf_idCard.text forKey:@"idCard"];
    [req setParam:tf_bankCard.text forKey:@"bankCard"];
    [req setParam:idCardYId forKey:@"idCardY"];
    [req setParam:idCardNId forKey:@"idCardN"];
    [req setParam:copyOfBankCardId forKey:@"copyOfBankCard"];

    [req setHTTPMethod:@"POST"];
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onUpdateActivity:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onUpdateActivity: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
    RRLoader *loader = (RRLoader *)[notify object];
    
    NSDictionary *json = [loader getJSONData];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    if (![[json objectForKey:@"success"] boolValue])
    {
        [self.view.window makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    [SVProgressHUD showSuccessWithStatus:@"上传成功!" duration:1.0f];
}

- (void)loadData
{
    if ([dataDict count] == 0)
        [self.view makeToastActivity];
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, AUTH_DETAIL_URL];
    RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:authId forKey:@"authId"];

    [req setHTTPMethod:@"POST"];
    
    RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
    [loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onLoaded:)];
    [loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
    [loader loadwithTimer];
}

- (void) onLoaded: (NSNotification *)notify
{
    [self.view hideToastActivity];
    RRLoader *loader = (RRLoader *)[notify object];
    NSDictionary *json = [loader getJSONData];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
    
    NSLog(@"%@",json);
    NSLog(@"%@",[[json objectForKey:@"data"] objectForKey:@"msg"]);
    
    //login fail
    if (![[json objectForKey:@"success"] boolValue])
    {
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    
    NSDictionary *data = [json objectForKey:@"data"];
    if ([[[json objectForKey:@"data"] objectForKey:@"msg"] length]) {
        [self.view makeToast:[[json objectForKey:@"data"] objectForKey:@"msg"] ];
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = YES;
    dataDict = [NSDictionary dictionaryWithDictionary:data];
    [self.tableView reloadData];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络请求失败!" duration:1.0f];
    
    RRLoader *loader = (RRLoader *)[notify object];
    [loader removeNotificationListener:RRLOADER_COMPLETE target:self];
    [loader removeNotificationListener:RRLOADER_FAIL target:self];
}


@end
