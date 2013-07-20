//
//  UIImageViewAdditions.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/20/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImageView (Additions)

- (void) fitToParent;
- (void) setToCenter;

- (void) zoomByScale:(CGFloat)scale animated:(BOOL)animated;

@end
