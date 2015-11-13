
#import <UIKit/UIKit.h>
#import "DownloadManager.h"

#define DELEGATE_CALLBACK(X, Y) if (self.delegate && [self.delegate respondsToSelector:@selector(X)]) [self.delegate performSelector:@selector(X) withObject:Y];
#define kIMGCancel @"x.png"

#define DEFAULT_BLUE [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]


static const CGSize progressViewSize = {50.0f, 20.0f };

@implementation DownloadManager


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)start
{
	if (_fileURL == nil) {
		
		return;
	}
    buff = [[NSMutableData alloc] init];

	NSURLRequest *request = [NSURLRequest requestWithURL:_fileURL];
	self.URLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	if (_URLConnection)
    {
//        if (_viewDelegate)
//        {
//            [self createCircularProgressView];
//        }
//        else if (_title)
//        {
//            [self createProgressionAlertWithMessage:_title];
//        }
	}
    else
    {
        
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createProgressionAlertWithMessage:(NSString *)message 
{	
	self.progressAlertView = [[UIAlertView alloc] initWithTitle:message
														message:NSLocalizedString(@"请稍后...",nil) 
													   delegate:self 
											  cancelButtonTitle:nil
											  otherButtonTitles:nil];
    
	// Create the progress bar and add it to the alert
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 90.0f, 225.0f, 90.0f)];
    [_progressView setProgressViewStyle:UIProgressViewStyleBar];
	[_progressAlertView addSubview:_progressView];
	
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90.0f, 90.0f, 225.0f, 40.0f)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.text = @"";
    label.tag = 1;
    [_progressAlertView addSubview:label];
	[label release];
	
    [_progressAlertView show];
}


-(void)cancelLoadAction:(UIButton *)sender{
	[_URLConnection cancel];
	NSError *error;
	NSString *filePath=[NSString stringWithFormat:@"%@",_fileName];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
	}
	[_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	self.currentSize = 0;
    self.totalFileSize = [NSNumber numberWithLongLong:[response expectedContentLength]];
	
    // Check for bad connection
    if ([response suggestedFilename])
    {
        DELEGATE_CALLBACK(downloadManagerDidReceiveData:, [response suggestedFilename]);
    }
    else
    {
        DELEGATE_CALLBACK(downloadManagerDataDownloadFailed:, @"无效的链接!");

    }

	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
//	self.currentSize = self.currentSize + [data length];
//	NSNumber *resourceLength = [NSNumber numberWithUnsignedInteger:self.currentSize];
//	
//    NSNumber *progress = [NSNumber numberWithFloat:([resourceLength floatValue] / [_totalFileSize floatValue])];
//    self.progressView.progress = [progress floatValue];
//    const unsigned int bytes = 1024 ;
//
//    if (self.viewDelegate)
//    {
//        [bottomProgressView setProgress:[progress floatValue] animated:YES];
//    }
//    else
//    {
//        UILabel *label = (UILabel *)[_progressAlertView viewWithTag:1];
//        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//        [formatter setPositiveFormat:@"##0.00"];
//        NSNumber *partial = [NSNumber numberWithFloat:([resourceLength floatValue] / bytes)];
//        NSNumber *total = [NSNumber numberWithFloat:([_totalFileSize floatValue] / bytes)];
//        label.text = [NSString stringWithFormat:@"%@ KB / %@ KB", [formatter stringFromNumber:partial], [formatter stringFromNumber:total]];
//        [formatter release];
//    }
    [buff appendData:data];
  	
//	[self writeToFile:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	[_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
	
}
-(void)writeToFile:(NSData *)data{
	NSString *filePath=[NSString stringWithFormat:@"%@",_fileName];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
	}

	FILE *file = fopen([_fileName UTF8String], [@"ab+" UTF8String]);
	if(file != NULL){
		fseek(file, 0, SEEK_END);
	}
	unsigned long readSize = [data length];
	fwrite((const void *)[data bytes], readSize, 1, file);
	fclose(file);
}

+ (NSData *) readFromFile: (NSString *)name
{
	NSString *filePath=[NSString stringWithFormat:@"%@",name];
	NSData *data  = [[[NSData alloc] initWithContentsOfFile:filePath] autorelease];
	return data;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *filePath=[NSString stringWithFormat:@"%@",_fileName];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
	}
    
    [buff writeToFile:filePath atomically:YES];
	DELEGATE_CALLBACK(downloadManagerDataDownloadFinished:, _fileName);
	
	///////////////////////////////////////////////////////////////////////////////////////////////////
    
//    if (self.viewDelegate)
//    {
//        [bottomProgressView removeFromSuperview];
//    }
//    else
//    {
//        [_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
//    }
	
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)downloadManagerDidReceiveData:(NSData *)data
{
    
}
@synthesize delegate = _delegate;
@synthesize title = _title;
@synthesize fileURL = _fileURL;
@synthesize fileName = _fileName;
@synthesize currentSize = _currentSize;
@synthesize totalFileSize = _totalFileSize;
@synthesize progressView = _progressView;
@synthesize progressAlertView = _progressAlertView;
@synthesize URLConnection = _URLConnection;
@synthesize viewDelegate = _viewDelegate;

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    _delegate = nil;
    _viewDelegate = nil;
    [_title release];
    [_fileURL release];
    [_fileName release];
    [_totalFileSize release];
    [_progressView release];
    [_progressAlertView release];
    [_URLConnection release];
	[buff release];
    [super dealloc];
}


@end








