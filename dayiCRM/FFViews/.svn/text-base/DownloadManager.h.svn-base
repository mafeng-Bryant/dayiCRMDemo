

#import <Foundation/Foundation.h>

@protocol DownloadManagerDelegate <NSObject>
- (void) downloadManagerDataDownloadFinished: (NSString *) fileName;
- (void) downloadManagerDataDownloadFailed: (NSString *) reason;
@end

@interface DownloadManager : NSObject {
	
@private
	id <DownloadManagerDelegate> _delegate;
    UITableViewCell  *_viewDelegate;
	NSString	*_title;
	NSURL		*_fileURL;
	NSString	*_fileName;
	

	NSUInteger _currentSize;
	
	NSNumber *_totalFileSize;
	UIProgressView *_progressView;
	UIAlertView *_progressAlertView;
	NSURLConnection *_URLConnection;
    
    NSMutableData		*buff;

	
}

@property (nonatomic, assign) id <DownloadManagerDelegate> delegate;
@property (nonatomic, assign) UITableViewCell *viewDelegate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, assign) NSUInteger currentSize;
@property (nonatomic, retain) NSNumber *totalFileSize;
@property (nonatomic, retain) UIProgressView *progressView;
@property (nonatomic, retain) UIAlertView *progressAlertView;
@property (nonatomic, retain) NSURLConnection *URLConnection;



- (void)start;

- (void)createProgressionAlertWithMessage:(NSString *)message;

- (void)writeToFile:(NSData *)data;

+ (NSData *) readFromFile: (NSString *)name;

@end



