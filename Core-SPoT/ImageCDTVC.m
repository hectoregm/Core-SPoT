//
//  ImageCDTVC.m
//  Core-SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/21/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "ImageCDTVC.h"

@implementation ImageCDTVC

- (id)splitViewDetailWithBarButtonItem
{
    id detail = [self.splitViewController.viewControllers lastObject];
    if (![detail respondsToSelector:@selector(setSplitViewBarButtonItem:)] ||
        ![detail respondsToSelector:@selector(splitViewBarButtonItem)]) detail = nil;
    return detail;
}

- (void)transferSplitViewBarButtonItemToViewController:(id)destinationViewController
{
    id splitViewDetail = [self splitViewDetailWithBarButtonItem];
    if (splitViewDetail) {
        UIBarButtonItem *splitViewBarButtomItem = [splitViewDetail performSelector:@selector(splitViewBarButtonItem)];
        [splitViewDetail performSelector:@selector(setSplitViewBarButtonItem:)
                              withObject:nil];
        UIPopoverController *popover = [splitViewDetail performSelector:@selector(popover)];
        if (splitViewBarButtomItem && [destinationViewController respondsToSelector:@selector(setSplitViewBarButtonItem:)]) {
            [[splitViewDetail performSelector:@selector(popover)] dismissPopoverAnimated:YES];
            [destinationViewController performSelector:@selector(setPopover:) withObject:popover];
            [destinationViewController performSelector:@selector(setSplitViewBarButtonItem:)
                                            withObject:splitViewBarButtomItem];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath;
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        indexPath = [self.tableView indexPathForCell:sender];
    }
    
    if (indexPath) {
        if ([segue.identifier isEqualToString:@"setImageURL:"]) {
            Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            if ([segue.destinationViewController respondsToSelector:@selector(setImageURL:)]) {
                NSURL *url;
                [self transferSplitViewBarButtonItemToViewController:segue.destinationViewController];
                if (self.splitViewController) {
                    url = [[NSURL alloc] initWithString:photo.originalURL];
                } else {
                    url = [[NSURL alloc] initWithString:photo.imageURL];
                }
                [segue.destinationViewController performSelector:@selector(setImageURL:)
                                                      withObject:url];
                [segue.destinationViewController setTitle:photo.title];
                photo.accessed_at = [NSDate date];
            }
        }
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
