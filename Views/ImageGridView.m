//
//  ImageGridView.m
//  ZoomTag
//
//  Created by Miki Bergin on 9/14/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "ImageGridView.h"
#import "NSMutableArrayStack.h"

#define NCOLS 4
#define MARGIN 4

@interface ImageGridView () <QueuedOperationManagerDelegate>
@property (nonatomic, retain) NSMutableArray *queue;
@property (nonatomic, strong) NSMutableArray *contentViews;
@end

@implementation ImageGridView
{
    float imageSize;
    int lastWidth;
    int firstImageShowing;
    int lastImageShowing;
}

@synthesize imageUrlArray;
@synthesize queue;
@synthesize contentViews;

- (NSMutableArray*) queue
{
    if (!queue)
    {
        queue = [NSMutableArray array];
    }
    return queue;
}
- (NSMutableArray*) contentViews {
    if (!contentViews) {
        contentViews = [NSMutableArray array];
    }
    return contentViews;
}

- (void) addToQueue:(UIImageView*)view {
    view.image = nil;
    view.tag = 0;
    [view removeFromSuperview];
    [self.queue push:view];
    [self.contentViews removeObject:view];
}

- (void) showImageAtRow:(int)row column:(int)col {
    int imageIndex = row*NCOLS + col;
    NSString *imageUrl = [imageUrlArray objectAtIndex:imageIndex];
    if (imageUrl)
    {
        UIImageView *image = [self.queue pop];
        
        if (!image) {
            image = [[UIImageView alloc] initWithFrame:CGRectZero];
        }
        image.frame = CGRectMake(col*(imageSize+MARGIN), row*(imageSize+MARGIN), imageSize, imageSize);
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.tag = 10000 + imageIndex;
        image.clipsToBounds = YES;
        image.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:image];
        [self.contentViews addObject:image];
        [[QueuedOperationManager sharedInstance] requestDataForUrlString:imageUrl CustomData:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:image.tag], @"tag", image, @"view",nil] Delegate:self
         ];
    }
    else
    {
        NSLog(@"no image?");
    }
}

- (void) showImageIndex:(int)imageIndex
{
    [self showImageAtRow:imageIndex/NCOLS column:imageIndex % NCOLS];
}


- (void)dataFinishedLoading:(NSData*)urlData CustomData:(id)customData
{
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:
     ^{
         UIImageView *iv = [(NSDictionary*)customData objectForKey:@"view"];
         int tag = [(NSDictionary*)customData integerForKey:@"tag"];
         if (iv.tag == tag)
         {
             iv.image = [UIImage imageWithData:urlData];
         }
     }];
}

- (NSInteger) imageIndexForPoint:(CGPoint)p
{
    int col = p.x / (imageSize + MARGIN);
    int row = p.y / (imageSize + MARGIN);
    return row * NCOLS + col;
}

- (void)populate
{
    //if (!self.dragging)
    {
        CGRect visibleRect = self.visibleRect;
        int firstImage = [self imageIndexForPoint:visibleRect.origin];
        int lastImage = [self imageIndexForPoint:CGPointMake(visibleRect.size.width, visibleRect.origin.y + visibleRect.size.height + imageSize)];
        if (firstImage < 0)
        {
            firstImage = 0;
        }
        
        if (lastImage > [imageUrlArray count])
        {
            lastImage = [imageUrlArray count];
        }
        if (firstImage != firstImageShowing || lastImage != lastImageShowing)
        {
            NSMutableArray *viewsToRemove = [NSMutableArray array];
            for (UIImageView *iv in self.contentViews)
            {
                int imageIndex = iv.tag - 10000;
                if (imageIndex < firstImage || imageIndex > lastImage)
                {
                    [viewsToRemove addObject:iv];
                }
            }
            [viewsToRemove enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
            {
                [self addToQueue:obj];
            }];
            for (int index = firstImage; index < firstImageShowing; index++)
            {
                [self showImageIndex:index];
            }
            for (int index = lastImage-1; index >= lastImageShowing; index--)
            {
                [self showImageIndex:index];
            }
            lastImageShowing = lastImage;
            firstImageShowing = firstImage;
        }
    }
}

- (void) layoutSubviews
{
    if (self.width != lastWidth)
    {
        imageSize = rintf((self.width - (NCOLS - 1) *MARGIN)/NCOLS);
        self.contentSize = CGSizeMake(self.width, [imageUrlArray count] / NCOLS * (imageSize + MARGIN));
        for (UIView *iv in self.contentViews)
        {
            int imageIndex = iv.tag - 10000;
            int col = imageIndex % NCOLS;
            int row = imageIndex / NCOLS;
            iv.frame = CGRectMake(col*(imageSize+MARGIN)+MARGIN, row*(imageSize+MARGIN)+MARGIN, imageSize, imageSize);
        }
        lastWidth = self.width;
    }
    [self populate];
    [super layoutSubviews];
}

- (void) becomeActive
{
    self.contentSize = CGSizeMake(self.width, ([imageUrlArray count]/NCOLS+1) * (imageSize + MARGIN));
    self.userInteractionEnabled = YES;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
    }
    return self;
}

- (void) tappedImage:(NSString*)image inView:(UIView*)view
{
    id vc = self.viewController;
    if ([vc respondsToSelector:@selector(tappedGig:inView:)])
    {
        self.userInteractionEnabled = NO;
        //[vc tappedGig:gig inView:view];
    }
}

- (void) tap:(UITapGestureRecognizer*)rec
{
    if (rec.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint where = [rec locationInView:self];
        int imageIndex = [self imageIndexForPoint:where];
        if (imageIndex >= 0 && imageIndex < [imageUrlArray count])
        {
            NSString* imageUrl = [imageUrlArray objectAtIndex:imageIndex];
            if (imageUrl)
            {
                [self tappedImage:imageUrl inView:[self viewWithTag:imageIndex+10000]];
            }
        }
    }
}
@end
