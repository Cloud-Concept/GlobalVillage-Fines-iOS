//
//  NewFInesViewController.h
//  GVFines
//
//  Created by Mina Zaklama on 9/28/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopoverPickerViewController.h"
#import "SFRestAPI.h"
#import "ESCPOSPrinter.h"
#import "EABluetoothPort.h"
#import "CaptureImagesViewController.h"
#import "FineDetailsViewController.h"

@class PavilionFineType;
@class NewFinesTabViewController;

@interface NewFinesView : UIView <PopoverPickerViewControllerDelegate, UIPopoverControllerDelegate, SFRestDelegate, UITextViewDelegate, CaptureImagesViewControllerDelegate, FineDetailsViewDelegate>
{
    NSString *selectedBusinessCategoryId;
    NSString *selectedSubCategoryId;
    
    NSInteger selectedBusinessCategoryIndex;
    NSInteger selectedSubCategoryIndex;
    NSInteger selectedPavilionFineDepartmentIndex;
    NSInteger selectedPavilionFineDescriptionIndex;
    
    NSInteger totalAttachmentsToUpload;
    NSInteger attachmentsReturned;
    BOOL isUploadingAttachments;
    NSArray *imagesArray;
    NSMutableArray *failedImagedArray;
    NSString *attachmentParentId;
    
    BOOL isLoadingBusinessCategories;
    BOOL isLoadingSubCategories;
    BOOL isLoadingRecordTypes;
    BOOL isLoadingCaseNumber;
    BOOL isLoadingPavilionFines;
    BOOL isSubmitPavilionFine;
    BOOL isLoadingQueueId;
    BOOL isCheckingFineExists;
    
    NSString *pavilionFineRecordTypeId;
    NSString *fineQueueId;
    NSString *GR1QueueId;
    
    NSString *selectedPavilionFineDepartment;
    PavilionFineType *selectedPavilionFineObject;
    
    NSMutableArray *pavilionFineDepartmentStringArray;
    NSMutableArray *pavilionFineTypeFilteredArray;
    
    NSString *caseNumber;
}

@property (strong, nonatomic) IBOutlet UIButton *printButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIButton *businessCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *subCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *departmentButton;
@property (strong, nonatomic) IBOutlet UIButton *fineButton;
@property (strong, nonatomic) IBOutlet UITextField *fineAmountTextField;
@property (strong, nonatomic) IBOutlet UITextView *fineDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) UIPopoverController *businessCategoryPickerPopover;
@property (strong, nonatomic) UIPopoverController *subCategoryPickerPopover;
@property (strong, nonatomic) UIPopoverController *pavilionFineDepartmentPickerPopover;
@property (strong, nonatomic) UIPopoverController *pavilionFineDescriptionPickerPopover;
@property (strong, nonatomic) UIPopoverController *imagesSelectionPopover;
@property (strong, nonatomic) UIPopoverController *fineDetailspopover;

@property (strong, nonatomic) NSMutableArray *businessCategoriesArray;
@property (strong, nonatomic) NSMutableArray *subCategoriesArray;
@property (strong, nonatomic) NSMutableArray *pavilionFineTypeArray;

@property (strong, nonatomic) Fine *fine;

@property (strong, nonatomic) NewFinesTabViewController *parentViewController;

//- (id)initNewFinesViewController;
- (IBAction)businessCategoryButtonClicked:(id)sender;
- (IBAction)subCategoryButtonClicked:(id)sender;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)printButtonClicked:(id)sender;
- (IBAction)departmentButtonClicked:(id)sender;
- (IBAction)fineButtonClicked:(id)sender;
- (IBAction)cameraButtonClicked:(id)sender;

- (void)tapInView;
- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;
-(id) initWithFine:(Fine *)fine;

@end
