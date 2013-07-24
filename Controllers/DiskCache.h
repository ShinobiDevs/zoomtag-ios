
#define kMaxDiskCacheSize 10e6

// Uncomment to enable debugging NSLog statements
//#define DiskCacheDebug



@interface DiskCache : NSObject {
@private
	NSString *_cacheDir;
	NSString *_savedCacheDir;
	NSUInteger _cacheSize;
	NSUInteger _cacheCapacity;
	BOOL trimming;
}

@property (nonatomic, assign) NSUInteger cacheCapacity;
@property (nonatomic, readonly) NSUInteger sizeOfCache;
@property (nonatomic, readonly) NSString *cacheDir;
@property (nonatomic, readonly) NSString *savedCacheDir;

+ (DiskCache *)sharedCache;

- (NSData *)dataInCacheForURLString:(NSString *)urlString;
- (void) cacheData:(NSData *)data forUrlString:(NSString *)urlString;
- (void) clearCachedDataForURLString:(NSString *)urlString;
- (void) saveURLString:(NSString*)urlString; // url must already be cached
- (void) clearSaved:(BOOL)keepRecent;

@end
