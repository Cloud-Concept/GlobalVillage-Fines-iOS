//
//  CaseDetailsViewController.h
//  GVFines
//
//  Created by omer gawish on 9/15/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Case;

@protocol CaseDetailsViewDelegate <NSObject>
@required
- (void)didFinishUpdatingCase;
- (void)closeCaseDetailsPopup;
@end

@interface CaseDetailsViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *caseNumber;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *nationalityLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseNationality;
@property (weak, nonatomic) IBOutlet UILabel *passportNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *basePassportLabel;
@property (weak, nonatomic) IBOutlet UILabel *visaNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *baseVisaLabel;
@property (weak, nonatomic) IBOutlet UILabel *passportIssueDateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *imagesScrollView;
@property (weak, nonatomic) IBOutlet UIView *loadingView;
@property (weak, nonatomic) IBOutlet UILabel *rejectionReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rejectionReason;
@property (weak, nonatomic) IBOutlet UILabel *dateOfRejection;

@property (weak, nonatomic) IBOutlet UILabel *noImageLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageDownloadingIndicator;
@property (weak,nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak,nonatomic) IBOutlet UILabel *statusLabel;
//@property (weak,nonatomic) IBOutlet UILabel *issuedByLabel;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;


@property (weak, nonatomic) id <CaseDetailsViewDelegate> delegate;


@property(strong,nonatomic) Case *currentCase;

@property(strong,nonatomic) NSMutableArray *arrayOfImages;
@property(strong,nonatomic) NSMutableArray *imageViews;
@property(nonatomic) NSInteger imagesCount;

-(instancetype) initWithCase:(Case *)anyCase;
@end
