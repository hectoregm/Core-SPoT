//
//  FlickrPhotoCache.h
//  SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/11/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlickrFetcher.h"

@interface FlickrPhotoCache : NSObject
+ (void)addPhoto:(NSData *)photo key:(NSURL *)key;
+ (NSData *)getPhoto:(NSURL *)key;
+ (BOOL)photoInCache:(NSURL *)key;
@end
