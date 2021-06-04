

#import "NSString+Functions.h"

@implementation NSString (Functions)

+(NSString *)trim:(NSString *)string{
    if (string == nil) {
        return @"";
    }
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
