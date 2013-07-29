//
//  GameRequest.h

#import <Foundation/Foundation.h>
#import "RequestBase.h"

@protocol GameRequestDelegate <RequestBaseDelegate>
@optional
- (void)gameRequestFinished:(NSArray*)gamePages;
- (void)gameRequestError;
@end

typedef id<GameRequestDelegate> ID_CONFORMS_GAME_REQ_DELEGATE;

@interface GameRequest : RequestBase
{
    NSURL* urlGameServer;
}

// needed as property for comparsion between requests
@property (nonatomic, readonly) NSNumber* pageNum;

- (id) initWithPageNum:(NSNumber*)iPageNum Delegate:(ID_CONFORMS_GAME_REQ_DELEGATE)delegate;
@end
