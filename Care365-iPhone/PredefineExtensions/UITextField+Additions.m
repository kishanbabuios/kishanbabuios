//
//  UITextField+Additions.m
//  DealsWeb
//
//  Created by ESS Mac Pro on 12/19/16.
//  Copyright © 2016 NGA Group Inc. All rights reserved.
//

#import "UITextField+Additions.h"

@implementation UITextField (Additions)

@dynamic placeholderColor;


-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    
    if (placeholderColor) {
        NSMutableAttributedString * attString = [self.attributedPlaceholder mutableCopy];
        [attString setAttributes:@{NSForegroundColorAttributeName:placeholderColor} range:NSMakeRange(0, attString.length)];
        self.attributedPlaceholder = attString;
    }
    
}

-(UIColor *)placeholderColor{
    
    return [self.attributedPlaceholder attribute: NSForegroundColorAttributeName atIndex: 0 effectiveRange: NULL];
    
}

@end
