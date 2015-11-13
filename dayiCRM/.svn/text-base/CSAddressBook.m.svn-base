
#import <QuartzCore/QuartzCore.h>
#import "CSAddressBook.h"

enum{
	CSAddressBookBookTag = -100,
	CSAddressBookPersonTag
};

@interface UITableView(ABAddressBook)
@end

@implementation UITableView(ABAddressBook)
//选中通讯录某个人以后执行这个方法 4
- (void)checkCellAtIndexPath:(NSIndexPath *)indexPath
{
	//NSInteger tag = -([indexPath row] * 100 + [indexPath section] + 100);
	CGRect rect = [[self cellForRowAtIndexPath:indexPath] frame];
	rect = CGRectMake(rect.size.width - 44.f, rect.origin.y + (rect.size.height - 20.f) * .5f, 20.f, 20.f);
	//there is a image with choose flag
	//[CSUIElement addImageViewToView:self frame:rect path:[CSUIElement getResourcePath:@"choose.png"] tag:tag];
}

- (BOOL)uncheckCellAtIndexPath:(NSIndexPath *)indexPath
{
	UIImageView *chooseView;
	NSInteger tag = -([indexPath row] * 100 + [indexPath section] + 100);
	if ((chooseView = (UIImageView *)[self viewWithTag:tag])) {
		[chooseView removeFromSuperview];
		return YES;
	}
	return NO;
}
//选中通讯录某个人以后执行这个方法 5
- (BOOL)changeSelectedCellCheckState
{
	NSIndexPath *indexPath = [self indexPathForSelectedRow];
	
	if (![self uncheckCellAtIndexPath:indexPath]) {
		 //第一个模块
		[self checkCellAtIndexPath:indexPath];
		return YES;
	}
	return NO;
}
@end


@implementation CSABPeoplePickerNavigationController
@synthesize csDelegate;

- (id)init
{
	if (self = [super init]) {
		recipientsList = [[NSMutableArray alloc] initWithCapacity:0];
        nameList = [[NSMutableArray alloc] initWithCapacity:0];
		personDic = [[NSMutableDictionary alloc] initWithCapacity:0];
		[self setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonPhoneProperty]]];
		for (UIView *subView in [[[self topViewController] view] subviews]) {
			if ([subView isKindOfClass:[UITableView class]]) {
				pickerTableView = (UITableView *)subView;
				break;
			}
		}
	}
	return self;
}

- (void)dealloc
{
	
	[recipientsList release];
	[personDic release];
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	[super dealloc];
}
//选中通讯录某个人以后执行这个方法 3
- (void)tableView:(UITableView *)aTableView selectCellWithPerson:(ABRecordRef)person andIndexForIdentifier:(CFIndex)index
{
    
    NSString *first = (NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
	NSString *last = (NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
    NSMutableString *name = nil;
    if (last && [first length]==0)
    {	 //第一个模块
        name = [NSMutableString stringWithString:last];
    }
    else if([last length] == 0 && first)
    {
        name = [NSMutableString stringWithString:first];
    }
    else if (last && first)
    {
        name = [NSMutableString stringWithFormat:@"%@%@",last,first];
    }

    ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    NSString *label = (NSString *)ABMultiValueCopyLabelAtIndex(phoneMulti, index);
	
	//分割字符串
	NSString *tempValue = (NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
	NSArray *array = [tempValue componentsSeparatedByString:@"-"];
	
	
	NSString *value = [array componentsJoinedByString:@""];
	NSLog(@"value === %@",value);
 	
	BOOL checked = NO;
	if ((checked = [aTableView changeSelectedCellCheckState]))
    { //第一个模块
		[recipientsList addObject:value];
        [nameList addObject:name];
	}
    else
    {
        if([recipientsList count])
            [recipientsList removeObjectAtIndex:[recipientsList indexOfObject:value]];
	}
	
	NSMutableDictionary *dic = nil;
	NSNumber *key = [[NSNumber alloc] initWithInt:ABRecordGetRecordID(person)];
	dic = [[personDic objectForKey:key] retain];
	if (checked) {
		if (nil == dic) {
			 //第一个模块
			dic = [[NSMutableDictionary alloc] initWithCapacity:0];
			[personDic setObject:dic forKey:key];
			if (aTableView != pickerTableView) {
				[pickerTableView changeSelectedCellCheckState];
			}
		}
		[dic setObject:value forKey:label];
	} else {
		[dic removeObjectForKey:label];
		if (0 == [dic count]) {
			[personDic removeObjectForKey:key];
			if (aTableView != pickerTableView) {
				[pickerTableView changeSelectedCellCheckState];
			}
		}
	}
	[dic release];
	[key release];
	
	[label release];
	[value release];
    
    NSDictionary *dict = @{@"name": [nameList objectAtIndex:0],@"tel":[recipientsList objectAtIndex:0]};
    
    [csDelegate csPeoplePickerNavigationControllerDidFinish:self withDictionary:dict];
}

- (void)mockDidSelectedTableView:(UITableView *)aTableView
{
	
	if (aTableView) {	
		for (UIView *subView in [aTableView subviews]) {
			if ([subView isKindOfClass:[UIImageView class]]) {
				[subView removeFromSuperview];
			}
		}
		for (NSInteger section = 0; section < [aTableView numberOfSections]; section++) {
			for (NSInteger row = 0; row < [aTableView numberOfRowsInSection:section]; row++) {
				NSUInteger indexes[2] = {section, row};
				cacheIndexPath = [[NSIndexPath alloc] initWithIndexes:indexes length:2];
				[aTableView.delegate tableView:aTableView didSelectRowAtIndexPath:cacheIndexPath];
				[cacheIndexPath release];
			}
		}
		[aTableView setUserInteractionEnabled:YES];
	}
}

//called when application entryforeground again
- (BOOL)pickerPreSelectCellWithPerson:(ABRecordRef)person
{
	
	NSNumber *key = [[NSNumber alloc] initWithInt:ABRecordGetRecordID(person)];
	NSMutableDictionary *dic = [personDic objectForKey:key];
	if (dic) {
		// all selected label for the person
		NSMutableArray *labelsOfDic = [[NSMutableArray alloc] initWithArray:[dic allKeys]];
		//all phone number
		ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
		//check each phone number
		for (CFIndex index = 0; index < ABMultiValueGetCount(phoneMulti); index++) {
			NSString *label = (NSString *)ABMultiValueCopyLabelAtIndex(phoneMulti, index);
			NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
			
			NSString *originValue = [dic objectForKey:label];
			if (nil != originValue) {
				if (![originValue isEqualToString:value]){
					[dic removeObjectForKey:label];			
				} else {
					[labelsOfDic removeObjectAtIndex:[labelsOfDic indexOfObject:label]];
				}
			}

			[label release];
			[value release];
		}
		//the value of the label must be changed or deleted,so we should remove from the dic
		for (NSString *label in labelsOfDic) {
			[dic removeObjectForKey:label];
		}
		[labelsOfDic release];
		
		if (0 == [dic count]) {
			[personDic removeObjectForKey:key];
		} else {
			[pickerTableView checkCellAtIndexPath:cacheIndexPath];
		}
	}
	[key release];
	return NO;
}
//选中通讯录某个人以后执行这个方法 2
- (BOOL)pickerSelectCellWithPerson:(ABRecordRef)person
{
	
	ABMultiValueRef phoneMulti;
	if ((phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty))) {
		CFIndex count = ABMultiValueGetCount(phoneMulti);
		if (count > 1) {
			isReloading = YES;
			return YES;
		} else if (1 == count){
			 //第一个模块
			[self tableView:pickerTableView selectCellWithPerson:person andIndexForIdentifier:0];
		}
	}
	isReloading = NO;
	return NO;
}
//选中通讯录某个人以后执行这个方法 1

- (BOOL)selectPickerCellWithPerson:(ABRecordRef)person
{
	
	if (isReloading) {
		return [self pickerPreSelectCellWithPerson:person];
	}
	 //第一个模块
	return [self pickerSelectCellWithPerson:person];
}

//show person detail view

//点击导入通讯录执行这个方法 2

- (void)showPersonDetailWithViewController:(UIViewController *)aViewController
{
	
	if (isReloading) {
		for (UIView *subView in [[aViewController view] subviews]) {
			if ([subView isKindOfClass:[UITableView class]]) {
				personTableView = (UITableView *)subView;
				[self mockDidSelectedTableView:personTableView];
				break;
			}
		}
		isReloading = NO;
	} else {
		personTableView = nil;
	}
}

//called when entry person detail view
- (void)personPreSelectCellWithPerson:(ABRecordRef)person andIndexForIdentifier:(CFIndex)index
{
	
	ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSString *label = (NSString *)ABMultiValueCopyLabelAtIndex(phoneMulti, index);
	NSString *value = (NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);	
	
	NSMutableDictionary *dic = nil;
	NSNumber *key  = [[NSNumber alloc] initWithInt:ABRecordGetRecordID(person)];
	if ((dic = [personDic objectForKey:key])) {
		NSString *originValue = [dic objectForKey:label];
		if (nil != originValue) {
			if ([originValue isEqualToString:value]){
				[personTableView checkCellAtIndexPath:cacheIndexPath];
			} else {
				[dic removeObjectForKey:label];
				if (0 == [dic count]) {
					[personDic removeObjectForKey:key];
					[personTableView changeSelectedCellCheckState];
				}				
			}
		}
	}
	[key release];
	
	[label release];
	[value release];
}

- (void)personSelectCellWithPerson:(ABRecordRef)person andIndexForIdentifier:(CFIndex)index
{
	
	[self tableView:personTableView selectCellWithPerson:person andIndexForIdentifier:index];
}

- (void)selectPersonCellWithPerson:(ABRecordRef)person identifier:(ABMultiValueIdentifier)identifier
{
	
	ABMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
	if (isReloading) {
		[self personPreSelectCellWithPerson:person andIndexForIdentifier:index];
	} else {
		[self personSelectCellWithPerson:person andIndexForIdentifier:index];
	}
}

- (NSArray *)recipientsList
{
	return recipientsList;
}

//active entry foreground again

- (void)checkRecordeChanged
{
	
	isReloading = YES;
	[self mockDidSelectedTableView:pickerTableView];
	[self mockDidSelectedTableView:personTableView];
	isReloading = NO;
}

- (void)recordChanged:(NSNotification*)notification 
{
	
	//now we remove all choose flags
	[pickerTableView setUserInteractionEnabled:NO];
	if (personTableView) {
		[personTableView setUserInteractionEnabled:NO];
	}
	[self performSelector:@selector(checkRecordeChanged) withObject:nil afterDelay:.1f];
}

@end

@implementation CSAddressBook
@synthesize delegate, cacheObject;
//点击导入通讯录首先执行这个方法 1
- (void)showPickerWithController:(UIViewController *)controller andObject:(id)object
{
	
	CSABPeoplePickerNavigationController *peoplePicker = [[CSABPeoplePickerNavigationController alloc] init];
    peoplePicker.navigationBar.tintColor = IOS7?[UIColor whiteColor]:dayiColor;
    [peoplePicker.navigationBar setBackgroundImage:[UIImage imageNamed:IOS7?@"navigationbar_tall": @"navigationbar"] forBarMetrics:UIBarMetricsDefault];
    if (IOS7)
    {
        peoplePicker.edgesForExtendedLayout = UIRectEdgeNone;
        peoplePicker.extendedLayoutIncludesOpaqueBars = NO;
        peoplePicker.modalPresentationCapturesStatusBarAppearance = NO;
        [peoplePicker.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    }

	[peoplePicker setCsDelegate:self];
	[peoplePicker setPeoplePickerDelegate:self];
	[peoplePicker setDelegate:self];
    [controller presentViewController:peoplePicker animated:YES completion:nil];
	[[[peoplePicker navigationBar] topItem] setTitle:@"选择联系人"];
	[peoplePicker release];

	viewController = controller;
	[self setDelegate:object];
}

#pragma mark UINavigationController delegate methods
//点击导入通讯录首先执行这个方法 3

- (void)navigationController:(CSABPeoplePickerNavigationController *)aPeoplePicker willShowViewController:(UIViewController *)aViewController animated:(BOOL)animated
{
	
	[aPeoplePicker showPersonDetailWithViewController:aViewController];
}
//点击导入通讯录首先执行这个方法 4
- (void)navigationController:(CSABPeoplePickerNavigationController *)aPeoplePicker didShowViewController:(UIViewController *)aViewController animated:(BOOL)animated
{
	
}

#pragma mark ABPeoplePickerNavigationController delegate methods

//选中通讯录某个人以后执行这个方法6
- (void)csPeoplePickerNavigationControllerDidFinish:(CSABPeoplePickerNavigationController *)aPeoplePicker withDictionary:(NSDictionary *)dict
{
	
	[delegate csAddressBook:self selectedDoneWithRecipients:dict];
    [viewController dismissViewControllerAnimated:YES completion:nil];
	[cacheObject release];

}

- (void)peoplePickerNavigationControllerDidCancel:(CSABPeoplePickerNavigationController *)aPeoplePicker
{
	
    [viewController dismissViewControllerAnimated:YES completion:nil];
	[cacheObject release];
}

- (BOOL)peoplePickerNavigationController:(CSABPeoplePickerNavigationController *)aPeoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	return [aPeoplePicker selectPickerCellWithPerson:person];
}

- (BOOL)peoplePickerNavigationController:(CSABPeoplePickerNavigationController *)aPeoplePicker 
	  shouldContinueAfterSelectingPerson:(ABRecordRef)person
								property:(ABPropertyID)property 
							  identifier:(ABMultiValueIdentifier)identifier
{
	
	[aPeoplePicker selectPersonCellWithPerson:person identifier:identifier];
	return NO;
}


+ (CSAddressBook *)shared
{
	static CSAddressBook *instance = nil;
	if (nil == instance) {
		instance = [[CSAddressBook alloc] init];
	}
	return instance;
}
@end
