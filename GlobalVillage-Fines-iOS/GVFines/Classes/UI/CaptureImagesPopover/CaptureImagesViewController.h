//
//  CaptureImagesViewController.h
//  GVFines
//
//  Created by Mina Zaklama on 10/28/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesCollectionViewCell.h"
#import <MobileCoreServices/MobileCoreServices.h>

@protocol CaptureImagesViewControllerDelegate <NSObject>

- (void)refreshImagesArray:(NSMutableArray*)imagesMutableArray;

@end


@interface CaptureImagesViewController : UIViewController <UICollectionViewDataSource, ImagesCollectionViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property BOOL newMedia;
@property (weak) id<CaptureImagesViewControllerDelegate> delegate;
@property (strong, nonatomic) UIViewController *mainViewController;
@property (strong, nonatomic) NSMutableArray *imagesArray;

@property (nonatomic, strong) IBOutlet UICollectionView *imagesCollectionView;

- (IBAction)cameraButtonClicked:(id)sender;
- (IBAction)cameraRollButtonClicked:(id)sender;

@end
