//
//  NetworkActivity.m
//  SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/11/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "NetworkActivity.h"

static NSLock *connections_lock;
static NSUInteger connections = 0;

@implementation NetworkActivity

+ (void)initialize
{
    if (!connections_lock) connections_lock = [[NSLock alloc] init];
}

+ (void)startActivity
{
    [connections_lock lock];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    connections += 1;
    [connections_lock unlock];
}

+ (void)stopActivity
{
    if (connections > 0) {
        [connections_lock lock];
        connections -= 1;
        if (connections == 0) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [connections_lock unlock];
    }
}

+ (BOOL)active
{
    return connections > 0 ? YES : NO;
}

@end
