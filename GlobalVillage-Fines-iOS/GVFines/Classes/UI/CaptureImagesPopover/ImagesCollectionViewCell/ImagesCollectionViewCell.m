//
//  ImagesCollectionViewCell.m
//  GVFines
//
//  Created by Mina Zaklama on 10/28/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "ImagesCollectionViewCell.h"

@implementation ImagesCollectionViewCell

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ImagesCollectionViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        self.imageView = (UIImageView*)[self viewWithTag:10];
        UIButton *deleteButton = (UIButton*)[self viewWithTag:20];
        
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

- (IBAction)deleteButtonClicked:(id)sender {
    [self.delegate deleteImageWithIndexPath:self.indexPath];
}
@end
