//
//  RecentPhotosCDTVC.m
//  Core-SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/21/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "RecentPhotosCDTVC.h"
#import "Photo.h"
#import "SharedUIManagedDocument.h"

@implementation RecentPhotosCDTVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.managedObjectContext) [self openDB];
}

- (void)openDB
{
    [[SharedUIManagedDocument sharedDocument] performWithDocument:^(UIManagedDocument *document, BOOL refresh) {
        self.managedObjectContext = document.managedObjectContext;
    }];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    _managedObjectContext = managedObjectContext;
    if (managedObjectContext) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"accessed_at" ascending:NO]];
        request.predicate = [NSPredicate predicateWithFormat:@"accessed_at != nil"];
        request.fetchLimit = 5;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
}

@end
