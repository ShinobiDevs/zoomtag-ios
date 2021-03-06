//
//  Challenge.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/22/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    HintTypeWhat,
    HintTypeWhere,
    HintTypeWho,
} HintTypes;

@interface Challenge : NSObject

@property (nonatomic, copy) NSString* imageUrlString;
@property (nonatomic, copy) NSString* easyTag;
@property (nonatomic, copy) NSString* mediumTag;
@property (nonatomic, copy) NSString* hardTag;
@property (nonatomic) HintTypes hint;

- (Challenge*)initWithDictionaryJsonValues:(NSDictionary*)dictionary;
@end
