
#import "DiskCache.h"

#define kPermCacheDir @"SavedData"

static inline NSString* documentsDirectory() 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

static DiskCache *sharedInstance;

@interface DiskCache (Privates)

- (void)trimDiskCache;

@end


@implementation DiskCache

@synthesize cacheCapacity = _cacheCapacity;

@dynamic sizeOfCache, cacheDir;


- (id)init 
{
	
	if ((self = [super init])) 
    {
		_cacheCapacity = 10000000U; // default size 10Mb
		trimming = NO;
		//[self performSelectorInBackground:@selector(trimDiskCache) withObject:nil];//not yet, disk capacity not set
	}
	return self;
	
}


- (NSString *)cacheDir 
{
	
	if (_cacheDir == nil) 
    {
//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//		_cacheDir = [[NSString alloc] initWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"]];
		_cacheDir = [[NSString alloc] initWithString:[NSTemporaryDirectory() stringByAppendingPathComponent:@"URLCache"]];
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:_cacheDir]) {
		return _cacheDir;
	}
	
	if (![[NSFileManager defaultManager] createDirectoryAtPath:_cacheDir withIntermediateDirectories:YES
													attributes:nil error:nil]) {
		NSLog(@"Error creating cache directory");
	}

	return _cacheDir;
	
}

- (NSString *)savedCacheDir {
	
	if (_savedCacheDir == nil) {
		//		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		//		_cacheDir = [[NSString alloc] initWithString:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"URLCache"]];
		_savedCacheDir = [[NSString alloc] initWithString:[documentsDirectory() stringByAppendingPathComponent:kPermCacheDir]];
	}
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:_savedCacheDir]) {
		return _savedCacheDir;
	}
	
	if (![[NSFileManager defaultManager] createDirectoryAtPath:_savedCacheDir withIntermediateDirectories:YES
													attributes:nil error:nil]) {
		NSLog(@"Error creating cache directory");
	}
	
	return _savedCacheDir;
	
}

- (NSString*) cacheKey:(NSString*)urlString
{
    int len =  urlString.length;
    NSRange pathRange = [urlString rangeOfString:@"/" options:0 range:NSMakeRange(7,len-7)];
    NSRange queryRange = [urlString rangeOfString:@"?" options:0 range:NSMakeRange(7,len-7)];
    if (queryRange.location == NSNotFound)
    {
        pathRange.length = len - pathRange.location;
    } else
    {
        pathRange.length = queryRange.location - pathRange.location;
    }
    NSUInteger hash = [[urlString substringWithRange:pathRange] hash]; // this includes the part after the ? May not be needed
    NSString* pathExtension = [urlString pathExtension];
    
    NSString* key;
    NSString* ext;
    if (nil != pathExtension && ![@"" isEqual: pathExtension])
    {
        ext = [pathExtension substringWithRange:NSMakeRange(0, 3)];
        key = [NSString stringWithFormat:@"%lu.%@",(unsigned long)hash,ext];

    }
    else
    {
        key = [NSString stringWithFormat:@"%lu",(unsigned long)hash];
    }
    
    
    return key;
}

- (NSString *)localPathForURLString:(NSString *)urlString 
{
	return [[self cacheDir] stringByAppendingPathComponent:[self cacheKey:urlString]];
}

- (NSString *)savedPathForURLString:(NSString *)urlString 
{
	return [[self savedCacheDir] stringByAppendingPathComponent:[self cacheKey:urlString]];
}

- (NSString*) bundlePathForURLString:(NSString *)urlString 
{
	return [[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"cache.bundle"] stringByAppendingPathComponent:[self cacheKey:urlString]];
}

- (NSData *)dataInCacheForURLString:(NSString *)urlString 
{
	NSString *localPath = [self localPathForURLString:urlString];
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {
		// "touch" the file so we know when it was last used
		[[NSFileManager defaultManager] setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], NSFileModificationDate, nil] 
										 ofItemAtPath:localPath 
												error:nil];
		//NSDLog(@"found cached url %@",urlString);
        return [NSData dataWithContentsOfFile:localPath];
//		return [[NSFileManager defaultManager] contentsAtPath:localPath];
	}
	
	NSString *savedPath = [self savedPathForURLString:urlString];
	if ([[NSFileManager defaultManager] fileExistsAtPath:savedPath]) {
		//NSDLog(@"found saved url %@",urlString);
        return [NSData dataWithContentsOfFile:savedPath];
		//return [[NSFileManager defaultManager] contentsAtPath:savedPath];
	}
    
    NSString *bundlePath = [self bundlePathForURLString:urlString];
    if ([[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        return [NSData dataWithContentsOfFile:bundlePath];
    }
	
	//NSDLog(@"Didn't find data for url %@",urlString);
	
	return nil;
}



- (void)cacheData:(NSData *)data   
			   forUrlString:(NSString *)urlString {
	
	if (urlString != nil && data != nil) {		
		if ([self sizeOfCache] > _cacheCapacity && !trimming) {
			[self performSelectorInBackground:@selector(trimDiskCache) withObject:nil];
		}
		
		NSString *localPath = [self localPathForURLString:urlString];
		if ( [[NSFileManager defaultManager] fileExistsAtPath:localPath] == NO ) {	
	//		NSDLog(@"caching %@", [localPath lastPathComponent] );
			if ( [[NSFileManager defaultManager] createFileAtPath:localPath contents:data attributes:nil] == NO ) {
				NSLog(@"  ERROR: Could not create file at path: %@", localPath);
			} else {
				_cacheSize += [data length];
			}
		}
		
  //      [cachedResponse release];
	}
	
}


- (void)clearCachedDataForURLString:(NSString *)urlString {
	
//	[[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
	NSData *data = [self dataInCacheForURLString:urlString];
	_cacheSize -= [data length];
	[[NSFileManager defaultManager] removeItemAtPath:[self localPathForURLString:urlString] 
											   error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:[self savedPathForURLString:urlString] 
											   error:nil];
	
}


- (NSUInteger)sizeOfCache {
	
	NSString *cacheDir = [self cacheDir];
	if (_cacheSize <= 0 && cacheDir != nil) {
		NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDir error:nil];
		NSString *file;
		NSDictionary *attrs;
		NSNumber *fileSize;
		NSUInteger totalSize = 0;
		
		for (file in dirContents) {
			NSString *pathExt = [file pathExtension];
			if ( [pathExt isEqualToString:@"jpg"] || [pathExt isEqualToString:@"png"] ) {
				attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[cacheDir stringByAppendingPathComponent:file]
																error:nil];
				
				fileSize = [attrs objectForKey:NSFileSize];
				totalSize += [fileSize integerValue];
			}
		}
		
		_cacheSize = totalSize;
	}

//	NSDLog(@"current cache size is: %d", _cacheSize);

	return _cacheSize;
	
}


static NSInteger dateModifiedSort(id file1, id file2, void *reverse) {
	
	NSDictionary *attrs1 = [[NSFileManager defaultManager] attributesOfItemAtPath:file1 error:nil];
	NSDictionary *attrs2 = [[NSFileManager defaultManager] attributesOfItemAtPath:file2 error:nil];
	
	if ((NSInteger *)reverse == NO) {
		return [[attrs2 objectForKey:NSFileModificationDate] compare:[attrs1 objectForKey:NSFileModificationDate]];
	}
	
	return [[attrs1 objectForKey:NSFileModificationDate] compare:[attrs2 objectForKey:NSFileModificationDate]];
	
}

- (void) clearSaved:(BOOL)keepRecent {
	NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self savedCacheDir] error:nil];
	NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:dirContents.count];
	for (NSString *file in dirContents) {
		[filteredArray addObject:[_savedCacheDir stringByAppendingPathComponent:file]];
	}
	int reverse = NO;
	NSMutableArray *sortedDirContents = [NSMutableArray arrayWithArray:[filteredArray sortedArrayUsingFunction:dateModifiedSort context:&reverse]];
	for (NSString *path in sortedDirContents) {
		NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
		if (keepRecent && [[attrs objectForKey:NSFileModificationDate] timeIntervalSinceNow] > -14.*24.*3600.) break;
		[[NSFileManager defaultManager] removeItemAtPath:path error:nil];
	}	
}

- (void)trimDiskCache {
	if (!trimming) {
		trimming = YES;
		@autoreleasepool {		
            NSUInteger targetBytes = _cacheCapacity * 0.75;
            
            //targetBytes = MIN(kMaxDiskCacheSize, MAX(0, targetBytes));
            if ([self sizeOfCache] > targetBytes) {
                NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self cacheDir] error:nil];
                NSLog(@"time to clean the cache! size is: %d, targetBytes=%d", [self sizeOfCache], targetBytes);
                NSLog(@"cache contents=%@", dirContents);
                
                
                NSMutableArray *filteredArray = [NSMutableArray arrayWithCapacity:dirContents.count];
                for (NSString *file in dirContents) {
                    //		NSString *pathExt = [file pathExtension];
                    //		if ( [pathExt isEqualToString:@"jpg"] || [pathExt isEqualToString:@"png"] ) {
                    [filteredArray addObject:[_cacheDir stringByAppendingPathComponent:file]];
                    //		}
                }
                //		NSMutableArray *filteredArray = [NSMutableArray arrayWithArray:dirContents];
                
                int reverse = YES;
                NSMutableArray *sortedDirContents = [NSMutableArray arrayWithArray:[filteredArray sortedArrayUsingFunction:dateModifiedSort context:&reverse]];
                while (_cacheSize > targetBytes && [sortedDirContents count] > 0) {
                    _cacheSize -= [[[NSFileManager defaultManager] attributesOfItemAtPath:[sortedDirContents lastObject] error:nil]
                                   fileSize];
                    [[NSFileManager defaultManager] removeItemAtPath:[sortedDirContents lastObject] error:nil];
#ifdef DiskCacheDebug	
                    NSLog(@"UNCACH %@", [[sortedDirContents lastObject] lastPathComponent]);
#endif
                    [sortedDirContents removeLastObject];
                }
                
                NSLog(@"remaining cache size: %d, target size: %d", _cacheSize, targetBytes);
                
                //       [filteredArray release];
            }
		}
	}
	trimming = NO;
}

- (void) saveURLString:(NSString*)urlString {
	if (![[NSFileManager defaultManager] fileExistsAtPath:[self savedPathForURLString:urlString]] &&
		[[NSFileManager defaultManager] fileExistsAtPath:[self localPathForURLString:urlString]]) {
		[[NSFileManager defaultManager] copyItemAtPath:[self localPathForURLString:urlString]
												toPath:[self savedPathForURLString:urlString]
												 error:nil];
	}
}



+ (DiskCache *)sharedCache {
	
	if (sharedInstance == nil) {
		sharedInstance = [[DiskCache alloc] init]; 
	}
	
    return sharedInstance;
	
}




@end
