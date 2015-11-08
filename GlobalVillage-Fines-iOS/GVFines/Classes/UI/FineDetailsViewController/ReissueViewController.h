//
//  ReissueViewController.h
//  GVFines
//
//  Created by omer gawish on 10/28/15.
//  Copyright © 2015 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "SFRestAPI+Blocks.h"
#import "SFUserAccountManager.h"
#import "SFOAuthCoordinator.h"
#import "SFDateUtil.h"
#import "Fine.h"
#import "BusinessCategory.h"
#import "SubCategory.h"
#import "CaptureImagesViewController.h"
#import "HelperClass.h"

@protocol ReissueViewDelegate <NSObject>
@required
- (void)didFinishUpdatingFine:(Fine *)fine;
- (void)closeFineDetailsPopup;
@end


@interface ReissueViewController : UIViewController<CaptureImagesViewControllerDelegate,SFRestDelegate,UIPopoverControllerDelegate,UITextViewDelegate>

@property (weak,nonatomic) id<ReissueViewDelegate> delegate;
@property (strong,nonatomic) Fine *fine;
@property (strong,nonatomic) BusinessCategory *category;
@property (strong,nonatomic) SubCategory *subCategory;
@property (strong,nonatomic) NSString *fineQueueId;
@property (strong,nonatomic) NSString *GR1QueueId;
@property (strong,nonatomic) UIPopoverController *imagesSelectionPopover;
@property (strong,nonatomic) NSArray *imagesArray;

- (id)initWithFine:(Fine*)fine FineQueueId:(NSString*)fineQueueIdValue GR1QueueId:(NSString*)GR1QueueIdValue BusinessCategory:(BusinessCategory *)category SubCategory:(SubCategory *)subCategory;

@end
