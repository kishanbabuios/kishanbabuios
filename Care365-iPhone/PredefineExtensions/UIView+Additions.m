//
//  UIView+Additions.m
//  EyeSpot
//
//  Created by cbl73 on 11/06/16.
//  Copyright © 2016 DCC. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

@dynamic cornerRadius, borderColor, borderWidth, shadowColor, shadowOffset, shadowRadius, shadowOpacity, masksToBounds;

- (void)setBorderColor:(UIColor *)borderColor{
    [self.layer setBorderColor:borderColor.CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth{
    [self.layer setBorderWidth:borderWidth];
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setShadowColor:(UIColor *)shadowColor{
    [self.layer setShadowColor:shadowColor.CGColor];
}

- (void)setShadowOpacity:(float)shadowOpacity{
    [self.layer setShadowOpacity:shadowOpacity];
}

- (void)setShadowOffset:(CGSize)shadowOffset{
    
    [self.layer setShadowOffset:CGSizeMake(shadowOffset.width, shadowOffset.height)];
}
- (void)setShadowRadius:(CGFloat)shadowRadius{
    [self.layer setShadowRadius:shadowRadius];
}

- (void)setMasksToBounds:(BOOL)masksToBounds{
    [self.layer setMasksToBounds:masksToBounds];
}



/*
 -(void)setShadowColorIB:(UIColor*)color
 {
 self.shadowColor = color.CGColor;
 }
 
 -(UIColor*)shadowColorIB
 {
 return [UIColor colorWithCGColor:self.shadowColor];
 }
 */
@end
