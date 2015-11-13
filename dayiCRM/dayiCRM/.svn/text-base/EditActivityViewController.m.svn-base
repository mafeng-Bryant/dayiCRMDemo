//
//  EditActivityViewController.m
//  dayiCRM
//
//  Created by Fang on 14-9-17.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import "EditActivityViewController.h"
#import "RRToken.h"
#import "RRLoader.h"
#import "SVProgressHUD.h"
#import "Toast+UIView.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SBJson.h"
#import "ActivityDetailViewController.h"

#define ORIGINAL_MAX_WIDTH 640.0f

@interface EditActivityViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>


@end

@implementation EditActivityViewController
@synthesize dataDict;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *btn_cancels;
    UIBarButtonItem *btn_done;
    if (IOS7) {
        btn_cancels = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navitem_back"] style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_click:)];
        
        btn_done = [[UIBarButtonItem alloc] initWithTitle:@"完成"style:UIBarButtonItemStyleBordered target:self action:@selector(btn_done_click:)];
    }
    else
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"navitem_back"] forState:UIControlStateNormal];
        [btn setFrame:CGRectMake(0.0f, 0.0f, 35, 28)];
        [btn addTarget:self action:@selector(btn_cancel_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_cancels = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
        [done setTitle:@"完成" forState:UIControlStateNormal];
        [done setFrame:CGRectMake(0.0f, 0.0f, 40,40)];
        [done addTarget:self action:@selector(btn_done_click:) forControlEvents:UIControlEventTouchUpInside];
        btn_done = [[UIBarButtonItem alloc] initWithCustomView:done];
        self.navigationItem.hidesBackButton = YES;
        self.tableView.separatorColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.navigationItem.hidesBackButton = YES;
        self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat_bg_default.jpg"]];
    }
    
    self.navigationItem.leftBarButtonItem = btn_cancels;
    self.navigationItem.rightBarButtonItem = btn_done;
    
    btn_certain_tmp = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btn_certain_tmp_click:)];
    btn_cancel = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(btn_cancel_tmp_click:)];
    btn_title = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    NSArray *arr = @[btn_cancel,flex,btn_title,flex,btn_certain_tmp];
    tool_bar_tmp = [[UIToolbar alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    tool_bar_tmp.barStyle = UIBarStyleDefault;
    tool_bar_tmp.translucent = YES;
    [tool_bar_tmp setItems:arr animated:NO];

    activityImages = [NSMutableArray array];
    addImages = [NSMutableArray array];
    delImages = [NSMutableArray array];
    orignalImages = [NSMutableArray array];
    
    if ([dataDict count]) {
        self.title = @"编辑活动";
        activityImages = [dataDict objectForKey:@"activityImages"];
        orignalImages = [dataDict objectForKey:@"activityImages"];
        [self initHeadView];
    }
    else{
        self.title = @"新增活动";
        UIButton *btn_add = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_add setImage:[UIImage imageNamed:@"img43"] forState:UIControlStateNormal];
        btn_add.frame = CGRectMake((10 + 64)*[activityImages count], 0, 64,64);
        [btn_add addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn_add];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 3;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell_id = [NSString stringWithFormat:@"cell_%d_%d",indexPath.section,indexPath.row];
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_id];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_id];
    }
    UIFont *fnt = [UIFont fontWithName:@"Helvetica" size:13.0f];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
     if ([cell.contentView viewWithTag:indexPath.section*10+indexPath.row+2]) {
        [[cell.contentView viewWithTag:indexPath.section*10+indexPath.row+2] removeFromSuperview];
    }
    UIImageView *im = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 24, 24)];
    im.tag = indexPath.section*10+indexPath.row+2;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                im.image = [UIImage imageNamed:@"img39"];
            }
            else if (indexPath.row == 1) {
                im.image = [UIImage imageNamed:@"img45"];
            }
            else if (indexPath.row == 2) {
                im.image = [UIImage imageNamed:@"img46"];
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                im.image = [UIImage imageNamed:@"img42"];
            }
            else if (indexPath.row == 1) {
                im.image = [UIImage imageNamed:@"img57"];
            }
            break;
        default:
            break;
    }
    [cell.contentView addSubview:im];
    
    if ([cell.contentView viewWithTag:indexPath.section*100+indexPath.row+1]) {
        [[cell.contentView viewWithTag:indexPath.section*100+indexPath.row+1] removeFromSuperview];
    }
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(44,3, 200, 30)];
    lb.textAlignment = NSTextAlignmentLeft;
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0f];
    lb.tag = indexPath.section*100+indexPath.row+1;
    lb.backgroundColor = [UIColor clearColor];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                lb.text = @"活动时间";
                if (!btn_start) {
                    btn_start = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn_start setBackgroundImage:[UIImage imageNamed:@"img54"] forState:UIControlStateNormal];
                    btn_start.titleLabel.adjustsFontSizeToFitWidth = YES;
                    [btn_start setFrame:CGRectMake(12, 40.0f, 130,34)];
                    [btn_start addTarget:self action:@selector(btn_start_click:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn_start];
                    if (dataDict) {
                        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                        [date_formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
                        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"activityStartDate"] doubleValue]/1000]];
                        [btn_start setTitle:post_date forState:UIControlStateNormal];
                        [btn_start setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    }
                }

                if (!im_sigleLine) {
                    im_sigleLine = [[UIImageView alloc] initWithFrame:CGRectMake(150, 55, 18, 1)];
                    im_sigleLine.image = [UIImage imageNamed:@"img55"];
                    [cell.contentView addSubview:im_sigleLine];
                }
                if (!btn_end) {
                    btn_end = [UIButton buttonWithType:UIButtonTypeCustom];
                    [btn_end setBackgroundImage:[UIImage imageNamed:@"img54"] forState:UIControlStateNormal];
                    [btn_end setFrame:CGRectMake(180, 40.0f, 130,34)];
                    btn_end.titleLabel.adjustsFontSizeToFitWidth = YES;
                    [btn_end addTarget:self action:@selector(btn_end_click:) forControlEvents:UIControlEventTouchUpInside];
                    if (dataDict) {
                        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
                        [date_formatter setDateFormat:@"YYYY-MM-dd HH:MM:SS"];
                        NSString *post_date = [date_formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:[[dataDict objectForKey:@"activityEndDate"] doubleValue]/1000]];
                        [btn_end setTitle:post_date forState:UIControlStateNormal];
                        [btn_end setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    }
                    [cell.contentView addSubview:btn_end];
                }

            }
            else if (indexPath.row == 1) {
                lb.text = @"活动地址";
                if (!tf_address) {
                    tf_address = [[UITextField alloc] initWithFrame:CGRectMake(12, 30, 300, 30)];
                    tf_address.borderStyle = UITextBorderStyleNone;
                    tf_address.backgroundColor = [UIColor clearColor];
                    tf_address.textAlignment = NSTextAlignmentLeft;
                    tf_address.font = fnt;
                    tf_address.textColor = [UIColor darkGrayColor];
                    tf_address.delegate = self;
                    tf_address.returnKeyType = UIReturnKeyNext;
                    if (dataDict) {
                        tf_address.text = [dataDict objectForKey:@"address"];
                    }
                    [cell.contentView addSubview:tf_address];
                }
            }
            else if (indexPath.row == 2) {
                lb.text = @"活动主办方";
                if (!tf_sponsor) {
                    tf_sponsor = [[UITextField alloc] initWithFrame:CGRectMake(12, 30, 300, 30)];
                    tf_sponsor.borderStyle = UITextBorderStyleNone;
                    tf_sponsor.backgroundColor = [UIColor clearColor];
                    tf_sponsor.textAlignment = NSTextAlignmentLeft;
                    tf_sponsor.font = fnt;
                    tf_sponsor.textColor = [UIColor darkGrayColor];
                    tf_sponsor.delegate = self;
                    tf_sponsor.returnKeyType = UIReturnKeyNext;
                    if (dataDict) {
                        tf_sponsor.text = [dataDict objectForKey:@"activitySponsor"];
                    }
                    [cell.contentView addSubview:tf_sponsor];
                }
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                lb.text = @"活动参与方式";
                if (!tx_participation) {
                    tx_participation = [[UITextView alloc] initWithFrame:CGRectMake(12, 30, 300,60)];
                    tx_participation.backgroundColor = [UIColor clearColor];
                    tx_participation.textAlignment = NSTextAlignmentLeft;
                    tx_participation.font = fnt;
                    tx_participation.textColor = [UIColor darkGrayColor];
                    tx_participation.delegate = self;
                    tx_participation.returnKeyType = UIReturnKeyNext;
                    if (dataDict) {
                        tx_participation.text = [dataDict objectForKey:@"activityParticipation"];
                    }
                    [cell.contentView addSubview:tx_participation];
                }
            }
            else if (indexPath.row == 1) {
                lb.text = @"活动限制人数";
                if (!tf_limitTheNumber) {
                    tf_limitTheNumber = [[UITextField alloc] initWithFrame:CGRectMake(12, 30, 300, 30)];
                    tf_limitTheNumber.borderStyle = UITextBorderStyleNone;
                    tf_limitTheNumber.backgroundColor = [UIColor clearColor];
                    tf_limitTheNumber.textAlignment = NSTextAlignmentLeft;
                    tf_limitTheNumber.font = fnt;
                    tf_limitTheNumber.textColor = [UIColor darkGrayColor];
                    tf_limitTheNumber.delegate = self;
                    tf_limitTheNumber.returnKeyType = UIReturnKeyDone;
                    if (dataDict) {
                        tf_limitTheNumber.text = [dataDict objectForKey:@"limitTheNumber"];
                    }
                    [cell.contentView addSubview:tf_limitTheNumber];
                }
            }
            break;
            
        default:
            break;
    }
    [cell.contentView addSubview:lb];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (1 == indexPath.section && 0 == indexPath.row) {
        return 100;
    }
    else if (1 == indexPath.section && 1 == indexPath.row){
        return 60.0f;
    }
    else if (0 == indexPath.section && 0 == indexPath.row){
        return 90;
    }
    return 70.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 456;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return head_view;
    }
    return nil;
}

#pragma mark -

- (void)initHeadView
{
    if (dataDict) {
        [btn_avatar setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dataDict objectForKey:@"pictures"]]];
        tf_title.text = [dataDict objectForKey:@"name"];
        if ([[dataDict objectForKey:@"detailExplain"] length]) {
            tv_des.text = [dataDict objectForKey:@"detailExplain"];
            lb_placeholder.text = @"";
        }
        startTime = [dataDict objectForKey:@"activityStartDate"];
        endTime = [dataDict objectForKey:@"activityEndDate"];
    }
    
    scrollView.contentSize = CGSizeMake(100*[activityImages count], 64);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    
    for (UIView *v in [scrollView subviews]) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < [activityImages count]; i++) {
        NSDictionary *dic = [activityImages objectAtIndex:i];
        UrlImageButton *btn = [[UrlImageButton alloc] initWithFrame:CGRectMake((10 + 64)*i, 0, 64,64)];
        [btn setImageFromUrl:YES withUrl:[BASE_URL stringByAppendingString:[dic objectForKey:@"pictureId"]]];
        btn.tag = i + 1;
        btn.accessibilityIdentifier = [dic objectForKey:@"id"];
        btn.layer.borderWidth = 1.0f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn addTarget:self action:@selector(btn_pic_click:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:btn];
    }
    
    UIButton *btn_add = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn_add setImage:[UIImage imageNamed:@"img43"] forState:UIControlStateNormal];
    btn_add.frame = CGRectMake((10 + 64)*[activityImages count], 0, 64,64);
    [btn_add addTarget:self action:@selector(btn_add_click:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:btn_add];

}

#pragma mark - EventHanle
- (void)btn_cancel_click:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NO];
}

- (void)btn_done_click:(id)sender
{
    if ([dataDict count]) {
        if ([startTime longLongValue] > [endTime longLongValue]) {
            [self.view.window makeToast:@"开始日期不能晚于结束日期"];
            return;
        }
        [self updateActivity];
    }
    else{
        if ([startTime longLongValue] > [endTime longLongValue]) {
            [self.view.window makeToast:@"开始日期不能晚于结束日期"];
            return;
        }
        if ([tf_address.text length] == 0 ) {
            [self.view.window makeToast:@"还没有填写活动地址"];
            return;
        }
        if ([tf_title.text length] == 0) {
            [self.view.window makeToast:@"还没有填写活动名称"];
            return;
        }
        if ([tv_des.text length] == 0) {
            [self.view.window makeToast:@"还没有填写活动说明"];
            return;
        }
        if ([tx_participation.text length] == 0) {
            [self.view.window makeToast:@"还没有填写活动参与方式"];
            return;
        }
        if ([tf_sponsor.text length] == 0) {
            [self.view.window makeToast:@"还没有填写活动主办方"];
            return;

        }
        if ([startTime length] == 0 ) {
            [self.view.window makeToast:@"还没有选择活动开始时间"];
            return;
        }
        if ([endTime length] == 0) {
            [self.view.window makeToast:@"还没有选择活动结束时间"];
            return;
        }
        if ([picturesId length] == 0) {
            [self.view.window makeToast:@"还没有上传封面图"];
            return;
        }
        if ([addImages count] == 0) {
            [self.view.window makeToast:@"还没有上传活动图片"];
            return;
        }
        if ([tf_limitTheNumber.text length] == 0) {
            [self.view.window makeToast:@"还没有填写活动限制人数"];
            return;
        }

        [self addActivity];
    }
}

- (IBAction)btn_avatar_click:(id)sender
{
    pictureType = 0;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];

}

- (void)btn_add_click:(id)sender
{
    pictureType = 1;
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

- (void)btn_pic_click:(id)sender
{
    NSLog(@"%@",[sender accessibilityIdentifier]);
}

- (void)btn_end_click:(id)sender
{
    timeType = 1;
    [self showDatePicker];

}

- (void)btn_start_click:(id)sender
{
    timeType = 0;
    [self showDatePicker];
}

#pragma mark -
-(void)textViewDidChange:(UITextView *)textView
{
    if ([textView isEqual:tv_des]) {
        if (textView.text.length == 0) {
            lb_placeholder.text = @"请输入活动说明";
        }else{
            lb_placeholder.text = @"";
        }
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if ([textView isEqual:tx_participation]) {
            [tf_limitTheNumber becomeFirstResponder];
        }
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark UITextFieldDelegate

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
    if ([textField isEqual:tf_title]) {
        [tv_des becomeFirstResponder];
    }
    else if ([textField isEqual:tf_address]) {
        [tf_sponsor becomeFirstResponder];
    }
    else if ([textField isEqual:tf_sponsor]) {
        [tx_participation becomeFirstResponder];
    }
    return YES;
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    if (pictureType == 0) {
        activityImage = editedImage;
        [btn_avatar setBackgroundImage:activityImage forState:UIControlStateNormal];
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
    
    if (ActionSheet.tag > 0) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        return;
    }

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
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f,pictureType?self.view.frame.size.width:296, pictureType?self.view.frame.size.width:136) limitScaleRatio:3.0];
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
            picturesId =[json objectForKey:@"pictureId"];
        }
        else{
            NSDictionary *dic = @{@"pictureId": [json objectForKey:@"pictureId"],@"name":@"123456"};
            [addImages addObject:dic];
            
            NSDictionary *dic1 = @{@"pictureId": [@"Ecp.Picture.view.img?pictureId=" stringByAppendingString: [json objectForKey:@"pictureId"] ],@"name":@"123456"};
            [activityImages insertObject:dic1 atIndex:0];
            [self initHeadView];

        }
    }
}

- (void) updateActivity
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, UPDATE_ACTIVITY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    [req setParam:[dataDict objectForKey:@"entityId"] forKey:@"entityId"];
    if ([tf_address.text length]) {
        [req setParam:tf_address.text forKey:@"address"];
    }
    if ([tf_title.text length]) {
        [req setParam:tf_title.text forKey:@"name"];
    }
    if ([tv_des.text length]) {
        [req setParam:tv_des.text forKey:@"detailExplain"];
    }
    if ([tx_participation.text length]) {
        [req setParam:tx_participation.text forKey:@"activityParticipation"];
    }
    if ([tf_sponsor.text length]) {
        [req setParam:tf_sponsor.text forKey:@"activitySponsor"];
    }
    if (startTime) {
        [req setParam:startTime forKey:@"activityStartDate"];
    }
    if (endTime) {
        [req setParam:endTime forKey:@"activityEndDate"];
    }
    if (picturesId) {
        [req setParam:picturesId forKey:@"activityPicture"];
    }
    if ([addImages count]) {
        [req setParam:[addImages JSONRepresentation] forKey:@"createPictures"];
    }
    if ([tf_limitTheNumber.text length]) {
        [req setParam:tf_limitTheNumber.text forKey:@"limitTheNumber"];
    }

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
    [SVProgressHUD showSuccessWithStatus:@"更新成功!" duration:1.0f];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activityDidUpdate" object:self];
}

- (void) addActivity
{
    RRToken *token = [RRToken getInstance];
    NSString *full_url = [NSString stringWithFormat:@"%@%@", BASE_URL, CREATE_ACTIVITY_URL];
	RRURLRequest *req = [[RRURLRequest alloc] initWithURLString:full_url];
    [req setParam:[token getProperty:@"tokensn"] forKey:@"token"];
    [req setParam:[token getProperty:@"storeId"] forKey:@"storeId"];
    if ([tf_address.text length]) {
        [req setParam:tf_address.text forKey:@"address"];
    }
    if ([tf_title.text length]) {
        [req setParam:tf_title.text forKey:@"name"];
    }
    if ([tv_des.text length]) {
        [req setParam:tv_des.text forKey:@"detailExplain"];
        
    }
    if ([tx_participation.text length]) {
        [req setParam:tx_participation.text forKey:@"activityParticipation"];
    }
    if ([tf_sponsor.text length]) {
        [req setParam:tf_sponsor.text forKey:@"activitySponsor"];
    }
    if (startTime) {
        [req setParam:startTime forKey:@"activityStartDate"];
    }
    if (endTime) {
        [req setParam:endTime forKey:@"activityEndDate"];
    }
    if (picturesId) {
        [req setParam:picturesId forKey:@"activityPicture"];
    }
    if ([addImages count]) {
        [req setParam:[addImages JSONRepresentation] forKey:@"pictures"];
    }
    if ([tf_limitTheNumber.text length]) {
        [req setParam:tf_limitTheNumber.text forKey:@"limitTheNumber"];
    }

	[req setHTTPMethod:@"POST"];
	RRLoader *loader = [[RRLoader alloc] initWithRequest:req];
	[loader addNotificationListener:RRLOADER_COMPLETE target:self action:@selector(onAddActivity:)];
	[loader addNotificationListener:RRLOADER_FAIL target:self action:@selector(onLoadFail:)];
	[loader loadwithTimer];
}

- (void) onAddActivity: (NSNotification *)notify
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
    [SVProgressHUD showSuccessWithStatus:@"创建成功!" duration:1.0f];
    entityId = [[json objectForKey:@"data"] objectForKey:@"entityId"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"activityDidUpdate" object:self];
    [self performSelector:@selector(popToDetailView) withObject:nil afterDelay:1.0f];
}

- (void) onLoadFail: (NSNotification *)notify
{
    [SVProgressHUD dismiss];
    [SVProgressHUD showErrorWithStatus:@"网络请求失败!" duration:1.0f];
    
	RRLoader *loader = (RRLoader *)[notify object];
	[loader removeNotificationListener:RRLOADER_COMPLETE target:self];
	[loader removeNotificationListener:RRLOADER_FAIL target:self];
}

- (IBAction)btn_cancel_tmp_click:(id)sender
{
    [self actionSheet:actionSheet clickedButtonAtIndex:0];
    btn_start.titleLabel.textColor = [UIColor darkGrayColor];
    btn_end.titleLabel.textColor = [UIColor darkGrayColor];
}

- (void)btn_certain_tmp_click:(id)sender
{
    [self actionSheet:actionSheet clickedButtonAtIndex:0];
    UIDatePicker *datePicker = (UIDatePicker *)[actionSheet viewWithTag:101];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (actionSheet.tag == 50)
    {
        [btn_start setTitle: [formatter stringFromDate:datePicker.date] forState:UIControlStateNormal  ];
        btn_start.titleLabel.textColor = [UIColor darkGrayColor];
        startTime = [self getTimeStringWithDate:datePicker.date];
    }
    
    if (actionSheet.tag == 51)
    {
        [btn_end setTitle: [formatter stringFromDate:datePicker.date] forState:UIControlStateNormal  ];
        endTime = [self getTimeStringWithDate:datePicker.date];
        btn_end.titleLabel.textColor = [UIColor darkGrayColor];

    }
}

- (NSString *)getTimeStringWithDate:(NSDate *)date
{
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    NSString * curTime = [formater stringFromDate:date];
    NSDate *theDate=[formater dateFromString:curTime];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formater setTimeZone:timeZone];
    NSTimeInterval b =[theDate timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%0.0f",b];
    return timeString;
}

- (void)showDatePicker
{
    if(!IOS8){
        UIDatePicker *datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(0.0f,40.0f, 320.0f, 216.0f)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        datePicker.locale = locale;
        datePicker.tag = 101;
        datePicker.datePickerMode = 2;
        datePicker.backgroundColor = [UIColor clearColor];

        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n\n" ;
        actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        actionSheet.tag = 50 + timeType;
        switch (timeType)
        {
            case 0:
                btn_title.title = @"选择开始时间";
                break;
            case 1:
                btn_title.title = @"选择结束时间";
                break;
            default:
                break;
        }
        [actionSheet showInView:self.view.window];
        [actionSheet addSubview:datePicker];
        [actionSheet addSubview:tool_bar_tmp];
    }
    else{
        UIDatePicker *datePicker =[[UIDatePicker alloc] initWithFrame:CGRectMake(-10.0f,0.0f, 320.0f, 216.0f)];
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        datePicker.locale = locale;
        datePicker.tag = 101;
        datePicker.datePickerMode = 2;
        datePicker.backgroundColor = [UIColor clearColor];

        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
        NSString *cancelButtonTitle = @"取消";
        NSString *destructiveButtonTitle = @"确定";

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController.view addSubview:datePicker];

        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert action sheet's cancel action occured.");
        }];
        
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            switch (timeType)
            {
                case 0:
                    [btn_start setTitle: [formatter stringFromDate:datePicker.date] forState:UIControlStateNormal  ];
                    [btn_start setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    startTime = [self getTimeStringWithDate:datePicker.date];
                    break;
                case 1:
                    [btn_end setTitle: [formatter stringFromDate:datePicker.date] forState:UIControlStateNormal  ];
                    endTime = [self getTimeStringWithDate:datePicker.date];
                    [btn_end setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }];
        
//        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:destructiveAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)popToDetailView
{
    ActivityDetailViewController *ctrl = [[ActivityDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    ctrl.aid = entityId;
    [self.navigationController pushViewController:ctrl animated:YES];

}
@end
