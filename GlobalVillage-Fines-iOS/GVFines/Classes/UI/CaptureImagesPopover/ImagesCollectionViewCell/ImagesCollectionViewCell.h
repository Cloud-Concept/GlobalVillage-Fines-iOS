//
//  ImagesCollectionViewCell.h
//  GVFines
//
//  Created by Mina Zaklama on 10/28/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImagesCollectionViewCellDelegate <NSObject>

- (void)deleteImageWithIndexPath:(NSIndexPath*) indexPath;
@end

@interface ImagesCollectionViewCell : UICollectionViewCell

@property (weak) id<ImagesCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)deleteButtonClicked:(id)sender;
@end
