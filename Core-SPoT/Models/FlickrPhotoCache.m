//
//  FlickrPhotoCache.m
//  SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/11/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "FlickrPhotoCache.h"

@interface FlickrPhotoCache()
@end

@implementation FlickrPhotoCache

#define ALL_CACHED_PHOTOS_KEY @"Flickr Cached Photos Key"
#define PHOTO_CACHE_DIR @"Photos"
#define MAX_CACHE_SIZE 5

static NSURL *photosCacheURL = nil;
static NSLock *journal_lock;

+ (void)initialize
{
    journal_lock = [[NSLock alloc] init];
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSURL *cachePath = [manager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask][0];
    NSError *error;
    NSURL *photosPath = [cachePath URLByAppendingPathComponent:PHOTO_CACHE_DIR];
    BOOL success = [manager createDirectoryAtURL:photosPath withIntermediateDirectories:NO
                                      attributes:nil
                                           error:&error];
    if (success == NO) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    photosCacheURL = photosPath;
}

+ (NSMutableDictionary *)cacheJournal
{
    NSMutableDictionary *cacheJournal = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_CACHED_PHOTOS_KEY] mutableCopy];
    if (!cacheJournal) cacheJournal = [[NSMutableDictionary alloc] init];
    return cacheJournal;
}

+ (void)addToJournal:(NSURL *)key
{
    NSMutableDictionary *cacheJournal = [self cacheJournal];
    NSDictionary *photoAttributes = @{@"filename": [key lastPathComponent]};
    [cacheJournal setObject:photoAttributes forKey:[key lastPathComponent]];
    
    [[NSUserDefaults standardUserDefaults] setObject:cacheJournal forKey:ALL_CACHED_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)removeFromJournal:(NSURL *)key
{
    NSMutableDictionary *cacheJournal = [self cacheJournal];
    [cacheJournal removeObjectForKey:[key lastPathComponent]];
    [[NSUserDefaults standardUserDefaults] setObject:cacheJournal forKey:ALL_CACHED_PHOTOS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)addPhoto:(NSData *)photo key:(NSURL *)key
{
    if (!photo) return;
    [self manageCacheSize];
    [photo writeToURL:[photosCacheURL URLByAppendingPathComponent:[key lastPathComponent]]
           atomically:YES];
    
    [journal_lock lock];
    [self addToJournal:key];
    [journal_lock unlock];
}

+ (void)manageCacheSize
{
    if ([[self cacheJournal] count] >= MAX_CACHE_SIZE) {
        NSLog(@"Cache is full, removing last accessed photo");
        NSError *error;
        NSFileManager *manager = [[NSFileManager alloc] init];
        NSArray *photos = [manager contentsOfDirectoryAtURL:photosCacheURL includingPropertiesForKeys:@[NSURLAttributeModificationDateKey] options:NSDirectoryEnumerationSkipsHiddenFiles error:&error];
        
        NSDate *accessDate;
        NSMutableArray *photosAttributes = [[NSMutableArray alloc] init];
        for (NSURL *photo in photos) {
            [photo getResourceValue:&accessDate forKey:NSURLAttributeModificationDateKey error:&error];
            [photosAttributes addObject:@{@"url": photo, @"date": accessDate}];
        }
        
        NSArray *sorted = [photosAttributes sortedArrayUsingComparator:^(id obj1, id obj2){
            return [obj1[@"date"] compare:obj2[@"date"]];
        }];
        NSURL *photoToRemove = sorted[0][@"url"];
        [manager removeItemAtURL:photoToRemove error:&error];
        [journal_lock lock];
        [self removeFromJournal:photoToRemove];
        [journal_lock unlock];
    }
}

+ (NSData *)getPhoto:(NSURL *)key
{
    if (![self photoInCache:key]) return nil;

    NSString *filename = [key lastPathComponent];
    NSURL *filePath = [photosCacheURL URLByAppendingPathComponent:filename];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:filePath];
    NSFileManager *manager = [[NSFileManager alloc] init];
    [manager setAttributes:@{NSFileModificationDate: [NSDate date]} ofItemAtPath:[filePath path] error:nil];
    
    return imageData;
}

+ (BOOL)photoInCache:(NSURL *)key
{
    return [FlickrPhotoCache cacheJournal][[key lastPathComponent]] ? YES : NO;
}
@end
