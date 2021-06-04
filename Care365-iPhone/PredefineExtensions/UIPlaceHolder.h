//
//  UIPlaceHolder.h
//  DealsWeb
//
//  Created by ESS Mac Pro on 1/16/17.
//  Copyright © 2017 NGA Group Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolder : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
