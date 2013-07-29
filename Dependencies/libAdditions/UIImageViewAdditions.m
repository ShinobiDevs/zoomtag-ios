//
//  UIImageViewAdditions.m
//  ZoomTag
//
//  Created by Miki Bergin on 7/20/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "UIImageViewAdditions.h"

@implementation UIImageView (Additions)

- (void) fitToParent
{
    UIView* parent = self.superview;
    
    float imageViewAspectRatio = self.image.size.width / self.image.size.height;
    float parentAspectRatio = parent.width / parent.height;
    float widthScale = parent.width / self.image.size.width;
    float heightScale = parent.height / self.image.size.height;
    
    float newWidth = 0;
    float newHeight = 0;
    if (imageViewAspectRatio > parentAspectRatio)
    {
        newWidth = parent.width;
        newHeight = self.image.size.height * widthScale;
    }
    else
    {
        newWidth = self.image.size.width / heightScale;
        newHeight = parent.height;
    }
    
    [self setWidth:newWidth];
    [self setHeight:newHeight];
    
    [self setToCenter];
}

- (void) setToCenter
{
    [self setTop:(self.superview.height - self.height) / 2];
    [self setLeft:(self.superview.width - self.width) / 2];
}

- (void) zoomByScale:(CGFloat)scale animated:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.3f
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^
         {
             [self setWidth:(self.width * scale)];
             [self setHeight:(self.height * scale)];
         }
         completion:^(BOOL finished)
         {
             
         }];
    }
    else
    {
        [self setWidth:(self.width * scale)];
        [self setHeight:(self.height * scale)];
    }

    [self setToCenter];
}
@end