//
//  MBString.m
//  ShinobiDevs
//
//  Created by Miki Bergin on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MBNSString.h"

@implementation NSString (MB)

// tests for nil and if it's nil returns empty string instead
// otherwise returns the same string
+ (NSString*) nilToEmpty:(NSString*)inputString
{
    if ((id)[NSNull null] == inputString || nil == inputString)
    {
        inputString = @"";
    }
    
    return inputString;
}

- (BOOL) containsString:(NSString *) string
{
    NSRange rng = [self rangeOfString:string options:0];
    return rng.location != NSNotFound;
}

- (NSString*) stringByConvertingUnicodeLineBreaks
{
    NSString* ret = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%C", 0x000d] withString:@""];
    return [ret stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%C", 0x000a] withString:@"\n"];
}

- (NSString*) stringByTrimmingUnicodeLineBreaks
{
    
    NSString* ret = [self stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%C", 0x000d] withString:@""];
    return [ret stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%C", 0x000a] withString:@" "];
}

- (NSString*) stringWithEncoding:(NSStringEncoding)iEncoding
{
    return [[NSString alloc] initWithData:[self dataUsingEncoding:iEncoding allowLossyConversion:YES] encoding:iEncoding];
}

- (NSString*) shuffle
{
    NSMutableString *randomizedText = [NSMutableString stringWithString:self];
    
    NSString *buffer;
    for (NSInteger i = randomizedText.length - 1, j; i >= 0; i--)
    {
        j = arc4random() % (i + 1);
        
        buffer = [randomizedText substringWithRange:NSMakeRange(i, 1)];
        [randomizedText replaceCharactersInRange:NSMakeRange(i, 1) withString:[randomizedText substringWithRange:NSMakeRange(j, 1)]];
        [randomizedText replaceCharactersInRange:NSMakeRange(j, 1) withString:buffer];
    }
    
    return randomizedText;
}
@end
