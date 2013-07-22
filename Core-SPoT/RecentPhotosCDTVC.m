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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
        
    if (indexPath) {
        NSLog(@"Foooooo: %@", segue.identifier);
        if ([segue.identifier isEqualToString:@"setImageURL:"]) {
            NSLog(@"Foooooo");
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                [segue.destinationViewController performSelector:@selector(setImageURL:)
                                                      withObject:[[NSURL alloc] initWithString:photo.imageURL]];
                [segue.destinationViewController setTitle:photo.title];
                photo.accessed_at = [NSDate date];
            }
        }
    }
}

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
        request.fetchBatchSize = 5;
        request.fetchLimit = 5;
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
    } else {
        self.fetchedResultsController = nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Photo"];
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.subtitle;
    
    return cell;
}

@end
