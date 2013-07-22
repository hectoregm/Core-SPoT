//
//  PhotosByTagCDTVC.h
//  Core-SPoT
//
//  Created by Hector Enrique Gomez Morales on 7/21/13.
//  Copyright (c) 2013 Hector Enrique Gomez Morales. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "ImageCDTVC.h"

@interface PhotosByTagCDTVC : ImageCDTVC
@property (nonatomic, strong) Tag *tag;
@end
