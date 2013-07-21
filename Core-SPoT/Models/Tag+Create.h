//
//  Tag+Create.h
//  Core-SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/21/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "Tag.h"

@interface Tag (Create)
+ (Tag *)tagWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
@end
