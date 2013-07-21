//
//  NetworkActivity.h
//  SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/11/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivity : NSObject
+ (void)startActivity;
+ (void)stopActivity;
+ (BOOL)active;
@end
