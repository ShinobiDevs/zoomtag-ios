//
//  MBString.h
//  Fiverr
//
//  Created by Miki Bergin on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MB)

// tests for nil and if it's nil returns empty string instead
// otherwise returns the same string
+ (NSString*) nilToEmpty:(NSString*)inputString;

- (BOOL) containsString:(NSString *) string;
- (NSString*) stringByConvertingUnicodeLineBreaks;
- (NSString*) stringByTrimmingUnicodeLineBreaks;
- (NSString*) stringWithEncoding:(NSStringEncoding)iEncoding;
@end
