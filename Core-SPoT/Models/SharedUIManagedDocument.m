//
//  SharedUIManagedDocument.m
//  Core-SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/21/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "SharedUIManagedDocument.h"

#define DIRECTORY_NAME @"CoreDB"

@implementation SharedUIManagedDocument

static SharedUIManagedDocument *_sharedInstance;

+ (SharedUIManagedDocument *)sharedDocument
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if(self) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:DIRECTORY_NAME];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    return self;
}

- (void)performWithDocument:(OnDocumentReady)onDocumentReady
{
    BOOL createDB = ![[NSFileManager defaultManager] fileExistsAtPath:[self.document.fileURL path]];
    void (^OnDocumentDidLoad)(BOOL) = ^(BOOL success) {
        onDocumentReady(self.document, createDB);
    };
    
    if(createDB) {
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateClosed) {
        [self.document openWithCompletionHandler:OnDocumentDidLoad];
    } else if (self.document.documentState == UIDocumentStateNormal) {
        OnDocumentDidLoad(YES);
    }
}

- (void)saveDocument
{
    [self.document saveToURL:self.document.fileURL
            forSaveOperation:UIDocumentSaveForOverwriting
           completionHandler:^(BOOL success) {
               if (!success) NSLog(@"failed to save document %@", self.document.localizedName);
    }];
}

@end
