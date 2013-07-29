//
//  GameCollection.h

#import <Foundation/Foundation.h>
#import "QueuedOperationManager.h"
#import "Game.h"

@protocol GameCollectionDelegate <NSObject>
@optional
- (void) newDataAdded;
- (void) dataChanged;
@end

typedef id<GameCollectionDelegate> ID_CONFORMS_GAME_COLLECTION_DELEGATE;

@interface GameCollection : NSObject <QueuedOperationManagerDelegate>
{
    NSLock* cachingLock;
    BOOL _caching;
}

@property (atomic, weak) ID_CONFORMS_GAME_COLLECTION_DELEGATE dataChangesDelegate; // has to be assign to avoid retain loops

@property (atomic, strong) NSMutableDictionary* gameDictionary;
@property (nonatomic) BOOL caching;

- (GameCollection*)initWithDelegate:(ID_CONFORMS_GAME_COLLECTION_DELEGATE)iDelegate;

- (BOOL) addGame:(Game*)game;

- (void) sendGameRequest;
- (void) sendGameRequest:(NSInteger)gamesCount;
- (BOOL) moreGamesNeeded;
- (void) cacheGames:(BOOL)cachingFinished;

- (BOOL) loadGamesFromDisk;
- (void) persistGamesToDisk;
- (void) persistToDisk;
- (void) loadFromDisk;
- (void) retryLastGameRequest;
@end