

#import <Foundation/Foundation.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@class CSABPeoplePickerNavigationController;

@protocol CSABPeoplePickerNavigationControllerDelegate
- (void)csPeoplePickerNavigationControllerDidFinish:(CSABPeoplePickerNavigationController *)aPeoplePicker withDictionary:(NSDictionary *)dict;
@end

@interface CSABPeoplePickerNavigationController : ABPeoplePickerNavigationController{
	id csDelegate;
@private
	BOOL isReloading;
	UITableView *pickerTableView;
	UITableView *personTableView;
	
	NSIndexPath *cacheIndexPath;
	NSMutableArray *recipientsList;
    NSMutableArray *nameList;

	NSMutableDictionary *personDic;
}

@property (nonatomic, assign) id<CSABPeoplePickerNavigationControllerDelegate> csDelegate;
@end

@class CSAddressBook;
@protocol CSAddressBookDelegate
- (void)csAddressBook:(CSAddressBook *)addressBook selectedDoneWithRecipients:(NSDictionary *)recipients;
@end

@interface CSAddressBook : NSObject
<ABPeoplePickerNavigationControllerDelegate, CSABPeoplePickerNavigationControllerDelegate, UINavigationControllerDelegate> {
	id delegate;
	id cacheObject;

@private
	UIViewController *viewController;
}
@property (nonatomic, assign) id<CSAddressBookDelegate> delegate;
@property (nonatomic, retain) id cacheObject;

- (void)showPickerWithController:(UIViewController *)controller andObject:(id)object;
+ (CSAddressBook *)shared;
@end
