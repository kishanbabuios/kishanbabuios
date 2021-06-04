//
//  UIView+Additions.h
//  EyeSpot
//
//  Created by cbl73 on 11/06/16.
//  Copyright © 2016 DCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, assign) IBInspectable UIColor *shadowColor;
@property (nonatomic, assign) IBInspectable float shadowOpacity;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;
@property (nonatomic, assign) IBInspectable BOOL masksToBounds;

@end
