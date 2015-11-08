//
//  CaptureImagesViewController.m
//  GVFines
//
//  Created by Mina Zaklama on 10/28/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "CaptureImagesViewController.h"
#import "ImagesCollectionViewCell.h"

@interface CaptureImagesViewController ()

@end

@implementation CaptureImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.imagesCollectionView registerClass:[ImagesCollectionViewCell class] forCellWithReuseIdentifier:@"ImagesCollectionViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteImageWithIndexPath:(NSIndexPath*) indexPath {
    [self.imagesArray removeObjectAtIndex:indexPath.row];
    [self.imagesCollectionView reloadData];
    [self.delegate refreshImagesArray:self.imagesArray];
}

- (IBAction)cameraButtonClicked:(id)sender {
    [self useCamera];
}

- (IBAction)cameraRollButtonClicked:(id)sender {
    [self useCameraRoll];
}

- (void)useCamera {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = YES;
        _newMedia = YES;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
            if (self.mainViewController) {
                [self.mainViewController presentViewController:imagePicker animated:YES completion:nil];
            } else {
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
        
    }
    
}

- (void) useCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        _newMedia = NO;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            [self presentViewController:imagePicker animated:YES completion:nil];
        } else {
            if (self.mainViewController) {
                [self.mainViewController presentViewController:imagePicker animated:YES completion:nil];
            } else {
                [self presentViewController:imagePicker animated:YES completion:nil];
            }
        }
    }
}

#pragma UICollectionViewDataSource Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imagesArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"ImagesCollectionViewCell";

    ImagesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ImagesCollectionViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    cell.imageView.image = [self.imagesArray objectAtIndex:indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        //[self.mainViewController dismissViewControllerAnimated:YES completion:nil];
        ////
        if (self.mainViewController) {
            [self.mainViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        [self.imagesArray addObject:image];
        
        [self.imagesCollectionView reloadData];
        [self.delegate refreshImagesArray:self.imagesArray];
        
        if (_newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (self.mainViewController) {
            [self.mainViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}
@end
