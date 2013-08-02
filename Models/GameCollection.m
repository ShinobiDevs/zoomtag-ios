//
//  GameCollection.m

#import "GameCollection.h"

#define kInitialCapacity 100
#define kRetryTime 10.0f

#define kGameCollectionUserDefaultsKey @"GameCollectionKey"
//#define kGigsArrayKey @"GigsArrayKey"


@implementation GameCollection

@synthesize dataChangesDelegate;
@synthesize gameDictionary;
@synthesize caching = _caching;

- (GameCollection*)initWithDelegate:(ID_CONFORMS_GAME_COLLECTION_DELEGATE)iDelegate
{
    self = [super init];
    if (self)
    {
        self.dataChangesDelegate = iDelegate;
        
        self.gameDictionary = [[NSMutableDictionary alloc] initWithCapacity:kInitialCapacity];

        _caching = NO;
        cachingLock = [NSLock new];
    }
    return self;
}

- (BOOL) addGame:(Game *)game
{
    if (nil == [gameDictionary objectForKey:game.id])
    {
        [gameDictionary setObject:game forKey:game.id];
        return YES;
    }
    
    return NO;
}

- (BOOL) caching
{
    return _caching;
}

- (void) setCaching:(BOOL)iCaching
{
    [cachingLock lock];
    _caching = iCaching;
    [cachingLock unlock];
}

- (void) sendGameRequest
{
    [[QueuedOperationManager sharedInstance] requestGamesForPage:[NSNumber numberWithInt:1] CustomData:nil RequestDelegate:self];
}

- (void) sendGameRequest:(NSInteger)gamesCount
{
    
}

- (BOOL)moreGamesNeeded
{
    return YES;
}

-(void) cacheGames:(BOOL)cachingFinished
{
    [cachingLock lock];
    
    // we will start caching only if we aren't already caching
    // or if previois caching has just completed(marked by the cachingFinished param)
    if (!_caching || cachingFinished)
    {
        if ([self moreGamesNeeded])
        {
            _caching = YES;
            [self sendGameRequest];
        }
        else
        {
            _caching = NO;
        }
    }
    
    [cachingLock unlock];
}

- (void) retryLastGameRequest
{
    [self cacheGames:NO];
}

- (BOOL) loadGamesFromDisk
{
//    BOOL newDataAdded = NO;
//    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];	
//	if (standardUserDefaults)
//    {
//        NSArray* dictGigArray = [standardUserDefaults objectForKey:[_UserDefaultsKey stringByAppendingString:kGigsArrayKey]];
//        for (NSDictionary* iGigDict in dictGigArray)
//        {
//            newDataAdded |= [self addGig:[[FiverrGig alloc] initWithContentOfDictionary:iGigDict]];
//        }
//    }
//    
//    if (newDataAdded)
//    {
//        [dataChangesDelegate newDataAdded];
//    }
//    
//    return newDataAdded;
    return false;
}


- (void) persistGamesToDisk
{
//    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    
//	if (standardUserDefaults)
//    {   
//        NSMutableArray* persistArray = [NSMutableArray new];
//        
//        for (FiverrGig* iGig in [gigsArray copy])
//        {
//            [persistArray addObject:[iGig contentsTodictionary]];
//        }
//        
//        [standardUserDefaults setObject:persistArray forKey:[_UserDefaultsKey stringByAppendingString:kGigsArrayKey]];
//        
//        [standardUserDefaults synchronize];
//	}
}

- (void) persistToDisk
{

}

- (void) loadFromDisk
{

}

- (void) dealloc
{
    // MIKI - cancel pending requests!!
}

#pragma mark - QueuedOperationManagerDelegate protocol methods

- (void)gameRequestFinished:(NSArray*)gamePages
{    
    BOOL newDataArrived = NO;
    
    // add all the new pages
    for(Game* game in gamePages)
    {
        // bitwise set of newData flag so it'll be YES at end of add loop
        // if atleast one add returned YES
        newDataArrived |= [self addGame:game];
    }
    
    if (gamePages)
    {
        NSDLog(@"game count is %d", [gameDictionary count]);
    }
    else
    {
        NSDLog(@"games request returned with no results for page:%d", 1);
    }
    
    // notify delegate if one exists and if new data was actually added
    if (newDataArrived && nil != self.dataChangesDelegate)
    {
        [self.dataChangesDelegate newDataAdded];
        [self cacheGames:YES];
    }
    else
    {
        // since we didn't receive any new data treat this is an error
        [self gameRequestError];
    }
}

- (void)gameRequestError
{
    // since request has failed we will try to perform caching again as if the request 
    // finished - after a delay
    self.caching = NO;
    [MBDispatch MBDispatchASyncTo:dispatch_get_main_queue() DispatchBlock:^
    {
        //NSDLog(@"dispatching retry after failure for categoryID:%d", [self.categoryID intValue]);
        [self performSelector:@selector(retryLastGameRequest) withObject:nil afterDelay:kRetryTime];
    }];
}
@end
