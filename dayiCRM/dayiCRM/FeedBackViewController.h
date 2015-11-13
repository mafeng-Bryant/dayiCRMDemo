//
//  FeedBackViewController.h
//  dayiCRM
//
//  Created by Fang on 14/10/24.
//  Copyright (c) 2014年 meetrend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackViewController : UIViewController<UITextViewDelegate>
{
    IBOutlet UITextView *tv_content;
    IBOutlet UIButton *btn_send;
}


@end
