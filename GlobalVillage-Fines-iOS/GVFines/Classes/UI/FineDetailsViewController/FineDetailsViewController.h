//
//  FineDetailsViewController.h
//  GVFines
//
//  Created by Mina Zaklama on 10/16/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "BusinessCategory.h"
#import "SubCategory.h"
#import "CaptureImagesViewController.h"
#import "CustomIOS7AlertView.h"
#import "ReissueViewController.h"


@class Fine;

@protocol FineDetailsViewDelegate <NSObject>
@required
- (void)didFinishUpdatingFine;
- (void)closeFineDetailsPopup;
@end

@interface FineDetailsViewController : UIViewController <UIAlertViewDelegate, SFRestDelegate,UIScrollViewDelegate,CaptureImagesViewControllerDelegate,UIPopoverControllerDelegate,CustomIOS7AlertViewDelegate,ReissueViewDelegate>
{
    Fine *currentFine;
    BusinessCategory *currentCategory;
    SubCategory *currentSubCategory;
    NSString *fineQueueId;
    NSString *GR1QueueId;
}

@property (strong, nonatomic) NSArray *imagesArray;

@property (strong, nonatomic) IBOutlet UILabel *fineNumberLabel;
@property (strong, nonatomic) IBOutlet UILabel *violationClauseLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UITextView *fineDescriptionTextView;
@property (strong, nonatomic) IBOutlet UITextView *commentsTextView;
@property (strong, nonatomic) IBOutlet UILabel *issuedByLabel;
@property (strong, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *fineAmountLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIButton *rectifiedButton;
@property (strong, nonatomic) IBOutlet UIButton *rePrintButton;
@property (strong, nonatomic) IBOutlet UIButton *reIssueButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;

@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageDownloadingIndicator;
@property (weak, nonatomic) id <FineDetailsViewDelegate> delegate;
@property (strong, nonatomic) UIPopoverController *imagesSelectionPopover;
@property (strong,nonatomic) UIPopoverController *reissueFinePopover;


- (IBAction)rectifiedButtonClicked:(id)sender;
- (IBAction)rePrintButtonClicked:(id)sender;
- (IBAction)reIsuueButtonClicked:(id)sender;
- (IBAction)closeButtonClicked:(id)sender;

- (id)initFineDetailsViewControllerWithFine:(Fine*)fine FineQueueId:(NSString*)fineQueueIdValue GR1QueueId:(NSString*)GR1QueueIdValue BusinessCategory:(BusinessCategory *)category SubCategory:(SubCategory *)subCategory;
- (id)initFineDetailsViewControllerWithFine:(Fine*)fine FineQueueId:(NSString*)fineQueueIdValue GR1QueueId:(NSString*)GR1QueueIdValue;

@end
