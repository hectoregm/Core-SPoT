//
//  SharedUIManagedDocument.h
//  Core-SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/21/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OnDocumentReady) (UIManagedDocument *document, BOOL refresh);

@interface SharedUIManagedDocument : NSObject
@property (strong, nonatomic) UIManagedDocument *document;

+ (SharedUIManagedDocument *)sharedDocument;
- (void)performWithDocument:(OnDocumentReady)onDocumentReady;

@end
