//
//  CreateGameRequest.h
//  ZoomTag
//
//  Created by Miki Bergin on 8/11/13.
//  Copyright (c) 2013 Shinobi Devs. All rights reserved.
//

#import "RequestBase.h"
#import "Game.h"

@protocol CreateGameRequestDelegate <RequestBaseDelegate>
@optional
- (void)createGameRequestFinished:(Game*)game;
- (void)createGameRequestError;
@end

typedef id<CreateGameRequestDelegate> ID_CONFORMS_CREATE_GAME_REQ_DELEGATE;

@interface CreateGameRequest : RequestBase
{
    NSURL* urlGameServer;
}

// needed as property for comparsion between requests
@property (nonatomic, readonly) Player* opponent;

- (id) initWithOpponent:(Player*)iOpponent Delegate:(ID_CONFORMS_CREATE_GAME_REQ_DELEGATE)delegate;

@end
