//
//  FacialView.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacialView.h"


@implementation FacialView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        faces=[Emoji allEmoji];
     }
    return self;
}

-(void)loadFacialView:(int)page size:(CGSize)size
{
	//row number
	for (int i=0; i<3; i++) {
		//column numer
		for (int y=0; y<7; y++) {
            
            int index = i*7+y+(page*20);
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width + y*10, i*size.height + i*10, size.width, size.height)];
            if (i==2&&y==6) {
                [button setImage:[UIImage imageNamed:@"faceDelete"] forState:UIControlStateNormal];
                button.tag=10000;
                
            }
            
            else if ([[faces objectAtIndex:index] hasPrefix:@"["])
            {
                [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d", index-19]]
                            forState:UIControlStateNormal];
                button.tag=index;
            }
            else{
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:20.0]];
                [button setTitle: [faces objectAtIndex:index]forState:UIControlStateNormal];
                button.tag=index;
            }
            
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
	}
    

}


-(void)selected:(UIButton*)bt
{
    if (bt.tag==10000) {
        NSLog(@"点击删除");
        [delegate selectedFacialView:@"删除"];
    }else{
        
        NSString *str = nil;
        if (bt.tag >=20) {
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults]objectForKey:@"FaceMap"];
            str = [dic objectForKey:[NSString stringWithFormat:@"%03d", bt.tag-19]];
        }
        else{
            str=[faces objectAtIndex:bt.tag];
        }
        NSLog(@"点击其他%@",str);
        [delegate selectedFacialView:str];
    }	
}

- (void)dealloc {
    [super dealloc];
}
@end
