//
//  FacebookFriendsRequest.h
//  ZoomTag
//
//  Created by Miki Bergin on 7/30/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestBase.h"

@protocol FBFriendsRequestDelegate <RequestBaseDelegate>
@optional
- (void)FBFriendsRequestFinished:(NSArray*) players;
- (void)FBFriendsRequestError;
@end

typedef id<FBFriendsRequestDelegate> ID_CONFORMS_FB_FRIENDS_REQ_DELEGATE;

@interface FBFriendsRequest : RequestBase
{
    NSURL* urlFacebookFriends;
}

- (id) initWithDelegate:(ID_CONFORMS_FB_FRIENDS_REQ_DELEGATE)delegate;
@end
