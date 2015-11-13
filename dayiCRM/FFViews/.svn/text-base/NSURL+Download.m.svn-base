

#import "NSURL+Download.h"
#import "DownloadManager.h"


@implementation NSURL (NSURL_Download)

- (void)downloadWithDelegate:(id)delegate Title:(NSString *)title WithToFileName:(NSString *)fileName
{
	DownloadManager *download	=[[DownloadManager alloc]init];
	download.title=title;
	download.fileURL=self;
	download.fileName=fileName;
	download.delegate = delegate;
	[download start];
}


@end
