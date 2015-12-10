//
//  FineDetailsViewController.m
//  GVFines
//
//  Created by Mina Zaklama on 10/16/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "FineDetailsViewController.h"
#import "Fine.h"
#import "HelperClass.h"
#import "SFRestAPI+Blocks.h"
#import "SFUserAccountManager.h"
#import "SFOAuthCoordinator.h"
#import "UIViewController+MJPopupViewController.h"
#import "SFDateUtil.h"
#import "NewFinesView.h"

@interface FineDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *reissueButton;
@property(strong,nonatomic) NSMutableArray *arrayOfImages;
@property(strong,nonatomic) NSMutableArray *imageViews;
@property(nonatomic) NSInteger imagesCount;
@end

@implementation FineDetailsViewController

- (id)initFineDetailsViewControllerWithFine:(Fine*)fine FineQueueId:(NSString*)fineQueueIdValue GR1QueueId:(NSString*)GR1QueueIdValue {
    return [self initFineDetailsViewControllerWithFine:fine FineQueueId:fineQueueIdValue GR1QueueId:GR1QueueIdValue BusinessCategory:nil SubCategory:nil];
}

- (id)initFineDetailsViewControllerWithFine:(Fine*)fine FineQueueId:(NSString*)fineQueueIdValue GR1QueueId:(NSString*)GR1QueueIdValue BusinessCategory:(BusinessCategory *)category SubCategory:(SubCategory *)subCategory {
    self =  [super initWithNibName:nil bundle:nil];
    
    currentFine = fine;
    currentCategory = category;
    currentSubCategory = subCategory;
    fineQueueId = fineQueueIdValue;
    GR1QueueId = GR1QueueIdValue;
    
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self reloadFineView];
}

- (void)viewDidLayoutSubviews {
    self.imagesScrollView.contentSize = CGSizeMake(self.imagesCount*60, 59);
}

- (void)viewDidAppear:(BOOL)animated {
    /*if (self.imagesCount == 0) {
        self.imageDownloadingIndicator.hidden = YES;
    }*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadFineView {
        [self.fineNumberLabel setText:currentFine.CaseNumber];
        [self.violationClauseLabel setText:currentFine.ViolationClause];
        [self.categoryLabel setText:[NSString stringWithFormat:@"%@ - %@", currentFine.BusinessCategory, currentFine.SubCategory]];
        [self.fineDescriptionTextView setText:currentFine.ViolationDescription];
        [self.fineDescriptionTextView setFont:[UIFont systemFontOfSize:16]];
        [self.commentsTextView setText:currentFine.Comments];
        [self.commentsTextView setFont:[UIFont systemFontOfSize:16]];
        [self.issuedByLabel setText:currentFine.CreatedBy];
        [self.statusLabel setText:currentFine.Status];
        [self.createdDateLabel setText:[HelperClass formatDateTimeToString:currentFine.CreatedDate]];
        [self.fineAmountLabel setText:[NSString stringWithFormat:@"%@",currentFine.X1stFineAmount]];
    
        [HelperClass setStatusBackground:currentFine ImageView:self.statusBackgroundImageView];
        
        [self setButtons];
        
        self.imagesScrollView.delegate = self;
        
//        self.imageViews = [[NSMutableArray alloc] init];
//        for(UIView *imageView in self.imagesScrollView.subviews){
//            if ([imageView isKindOfClass:[UIImageView class]]) {
//                UIImageView *image = (UIImageView *) imageView;
//                if (image.tag == 3) {
//                    [self.imageViews addObject:image];
//                    /*
//                     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                     [button addTarget:self
//                     action:@selector(imageTapped)
//                     forControlEvents:UIControlEventTouchUpInside];
//                     button.frame = image.frame;
//                     [self.imagesScrollView addSubview:button];
//                     */
//                }
//            }
//        }
    
        //disable the reissue button
        if ([currentFine.Status isEqualToString:@"Warning Approved"]||
            [currentFine.Status isEqualToString:@"1st Fine Approved"]||
            [currentFine.Status isEqualToString:@"2nd Fine Approved"]) {
            self.reIssueButton.enabled = YES;
        }
        else {
            self.reIssueButton.enabled = NO;
        }
        
        /*
         for (UIView* sview in self.imageViews) {
         UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
         singleTap.numberOfTapsRequired = 1;
         singleTap.numberOfTouchesRequired = 1;
         [sview addGestureRecognizer:singleTap];
         [sview setUserInteractionEnabled:YES];
         }*/
        
        SFRestRequest *requestForImages = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT Id,Body,ParentId FROM Attachment WHERE ParentId='%@'",currentFine.Id]];
    if (self.arrayOfImages) {
        if (self.arrayOfImages.count>0) {
            for(UIView *imageView in self.imagesScrollView.subviews){
                if ([imageView isKindOfClass:[UIImageView class]]) {
                    UIImageView *image = (UIImageView *) imageView;
                    if (image.tag == 3) {
                        [self.imageViews addObject:image];
                    }
                }
            }
            ///
            self.noImageLabel.hidden = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                int imageCounter = 0;
                for (UIImage *singleImage in self.arrayOfImages) {
                    UIImageView *image = [[self.imageViews objectAtIndex:imageCounter] initWithImage:singleImage];
                    //[self.imageViews addObject:image];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.tag = imageCounter;
                    [button addTarget:self
                               action:@selector(imageTapped:)
                     forControlEvents:UIControlEventTouchUpInside];
                    button.frame = image.frame;
                    [self.imagesScrollView addSubview:button];
                }
                [self.imageDownloadingIndicator stopAnimating];
                self.imageDownloadingIndicator.hidden = YES;
            });
        }

    } else {
        [[SFRestAPI sharedInstance] sendRESTRequest:requestForImages failBlock:^(NSError *e) {
            [[[UIAlertView alloc] initWithTitle:@"Sorry." message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
        } completeBlock:^(NSDictionary *dic){
            /*int recordSize = [dic objectForKey:@"totalSize"];
             for (int counter = 0; counter<recordSize; counter++) {
             
             }*/
            
            NSArray *records = [dic objectForKey:@"records"];
            
            self.imagesCount = [records count];
            if (self.imagesCount > 0) {
                //self.imageDownloadingIndicator.hidden = NO;
                [self.imageDownloadingIndicator startAnimating];
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.imageDownloadingIndicator stopAnimating];
                    self.imageDownloadingIndicator.hidden = YES;
                    self.noImageLabel.hidden = NO;
                });
                
            }
            int counter = 0;
            self.imageViews = [[NSMutableArray alloc] init];
            self.arrayOfImages =[[NSMutableArray alloc] init];

            for(UIView *imageView in self.imagesScrollView.subviews){
                if ([imageView isKindOfClass:[UIImageView class]]) {
                    UIImageView *image = (UIImageView *) imageView;
                    if (image.tag == 3) {
                        [self.imageViews addObject:image];
                        /*
                         UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                         [button addTarget:self
                         action:@selector(imageTapped)
                         forControlEvents:UIControlEventTouchUpInside];
                         button.frame = image.frame;
                         [self.imagesScrollView addSubview:button];
                         */
                    }
                }
            }
            
            //change this part
//            if (self.arrayOfImages.count>0) {
//                self.noImageLabel.hidden = YES;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                int imageCounter = 0;
//                for (UIImage *singleImage in self.arrayOfImages) {
//                    UIImageView *image = [[self.imageViews objectAtIndex:imageCounter] initWithImage:singleImage];
//                    //[self.imageViews addObject:image];
//                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//                    button.tag = imageCounter;
//                    [button addTarget:self
//                               action:@selector(imageTapped:)
//                     forControlEvents:UIControlEventTouchUpInside];
//                    button.frame = image.frame;
//                    [self.imagesScrollView addSubview:button];
//                }
//                    [self.imageDownloadingIndicator stopAnimating];
//                    self.imageDownloadingIndicator.hidden = YES;
//                });
//            }
            
            /////

            for (NSDictionary *record in records) {
                ////
                // How to get the correct host, since that is configured after the login.
                NSURL * host = [[[[SFRestAPI sharedInstance] coordinator] credentials] instanceUrl];
                
                // The field Body contains the partial URL to get the file content
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [host absoluteString],[record objectForKey:@"Body"]]];
                
                // Creating the Authorization header. Important to add the "Bearer " before the token
                NSString *authHeader = [NSString stringWithFormat:@"Bearer %@",[[[[SFRestAPI sharedInstance]coordinator] credentials] accessToken]];
                
                NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
                [urlRequest addValue:authHeader forHTTPHeaderField:@"Authorization"];
                [urlRequest setHTTPMethod:@"GET"];
                
                //NSURLRequest *imageUrlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                
                NSURLResponse *response=nil;
                NSError * error =nil;
                NSData * data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.arrayOfImages addObject:[UIImage imageWithData:data]];
                    UIImageView *image = [[self.imageViews objectAtIndex:counter] initWithImage:[self.arrayOfImages objectAtIndex:counter]];
                    //[self.imageViews addObject:image];
                    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                    button.tag = counter;
                    [button addTarget:self
                               action:@selector(imageTapped:)
                     forControlEvents:UIControlEventTouchUpInside];
                    button.frame = image.frame;
                    [self.imagesScrollView addSubview:button];
                    if (counter == ([records count]-1)) {
                        [self.imageDownloadingIndicator stopAnimating];
                    }
                });
                
                ////
                counter++;
            }
        }];
    }

        
}

- (IBAction)rectifiedButtonClicked:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Rectify" message:@"Are you sure you want to rectify this fine?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    alert.tag = 1;
    
    [alert show];
}

- (IBAction)rePrintButtonClicked:(id)sender {
    [HelperClass printReceiptForFine:currentFine];
}

- (IBAction)reIsuueButtonClicked:(id)sender {
   // CustomIOSAlertView * alert = [[CustomIOSAlertView alloc] initWithTitle:@"Re-Issue" message:@"Are you sure you want to re-issue this fine?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//    
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeAlphabet];
//    [[alert textFieldAtIndex:0] setText:currentFine.Comments];
//    
//    CustomIOS7AlertView * alert = [[CustomIOS7AlertView alloc] init];
//    [alert setDelegate:self];
//    [alert setButtonTitles:@[@"Yes",@"No"]];
//    [alert setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
//        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView tag]);
//        [alertView close];
//    }];
//    UIView *view = [[UIView alloc] init];
//    view.frame =alert.frame;
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btn addTarget:self action:@selector(cameraButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [btn setTitle:@"add Images" forState:UIControlStateNormal];
//    btn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
//    [view addSubview:btn];
//    [alert addSubview:view];
//    
//    alert.tag = 2;
//    
//    [alert show];
    ////////////////////
    ///new view 2015
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    if ([currentFine.Status isEqualToString:@"Warning Approved"]) {
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Case"
    objectId:currentFine.Id
    fields:[NSDictionary dictionaryWithObjects:@[@"1st Fine Printed",GR1QueueId, accountManager.currentUser.credentials.userId]
    forKeys:@[@"Status", @"OwnerId", @"Latest_Fine_Issuer__c"]]];
        [[SFRestAPI sharedInstance] send:request delegate:self];
        currentFine.fineStage = @"1st Fine";
        currentFine.Status = @"1st Fine";
        [HelperClass printReceiptForFine:currentFine];
    }
    else{
    ReissueViewController *reissueViewController = [[ReissueViewController alloc] initWithFine:currentFine FineQueueId:fineQueueId GR1QueueId:GR1QueueId BusinessCategory:currentCategory SubCategory:currentSubCategory];
    
    reissueViewController.delegate = self;
    
    self.reissueFinePopover = [[UIPopoverController alloc] initWithContentViewController:reissueViewController];
    self.reissueFinePopover.delegate = self;
    self.reissueFinePopover.popoverContentSize = reissueViewController.view.frame.size;
    
    CGRect rect = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 1, 1);
    
    [self.reissueFinePopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
    }
}

- (IBAction)closeButtonClicked:(id)sender {
    [self.delegate closeFineDetailsPopup];
}

- (void)setButtons {
    if ([currentFine.Status isEqualToString:@"Rectified"] ||
        [currentFine.Status isEqualToString:@"Warning"] ||
        [currentFine.Status isEqualToString:@"Fine Rejected"] ||
        [currentFine.Status isEqualToString:@"1st Fine Printed"] ||
        [currentFine.Status isEqualToString:@"2nd Fine Printed"] ||
        [currentFine.Status isEqualToString:@"3rd Fine Printed"] ||
        [currentFine.Status isEqualToString:@"3rd Fine Approved"])
    {
        [self.rectifiedButton setEnabled:NO];
        [self.reIssueButton setEnabled:NO];
    }
    
    if ([currentFine.Status isEqualToString:@"Rectified"] ||
        [currentFine.Status isEqualToString:@"Fine Rejected"])
    {
        [self.rePrintButton setEnabled:NO];
    }
}

- (void)initializeAndStartActivityIndicatorSpinner {
    if(![self.loadingView isHidden])
        return;
    
    [self.loadingView setHidden:NO];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)stopActivityIndicatorSpinner {
    [self.loadingView setHidden:YES];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)imageTapped:(UIButton *) button{
   // NSLog(@"it works");
    UIViewController *controller = [[UIViewController alloc] init];
    UIImage *image = [self imageWithImage:[self.arrayOfImages objectAtIndex:button.tag] scaledToSize:CGSizeMake(300, 300)];
    //UIImageView *imageView = [self.imageViews objectAtIndex:button.tag];
    //image.frame = CGRectMake(20,20 , 300, 300);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    controller.view = imageView;
    [self presentPopupViewController:controller animationType:MJPopupViewAnimationFade];
    
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)cameraButtonClicked:(id)sender {
    //[self dismissKeyboard];
    
    CaptureImagesViewController *captureImagesController = [[CaptureImagesViewController alloc] init];
    
    captureImagesController.mainViewController = self.parentViewController;
    //captureImagesController.mainViewController = self;
    captureImagesController.imagesArray = [[NSMutableArray alloc] initWithArray:self.imagesArray];
    captureImagesController.delegate = self;
    
    self.imagesSelectionPopover = [[UIPopoverController alloc] initWithContentViewController:captureImagesController];
    self.imagesSelectionPopover.popoverContentSize = captureImagesController.view.frame.size;
    
    self.imagesSelectionPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.imagesSelectionPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)resetImageViews {
    self.noImageLabel.hidden = YES;
    self.arrayOfImages = nil;
    for (UIImageView *imageView in self.imageViews) {
        imageView.image = nil;
    }
}


/*-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    for (UIView* sview in self.images) {
        for (UIGestureRecognizer* recognizer in sview.gestureRecognizers) {
            [recognizer addTarget:self action:@selector(touchEvent:)];
        }
    }

    //if ([self.images containsObject:[touch view]])
    //{
        NSLog(@"it works");
    //}
    
}*/

#pragma CaptureImagesViewControllerDelegate
- (void)refreshImagesArray:(NSMutableArray*)imagesMutableArray {
    self.imagesArray = [NSArray arrayWithArray:imagesMutableArray];
}


#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        return;
    
    if (alertView.tag == 1 && buttonIndex == 1) //Rectify AlertView
    {
        [self initializeAndStartActivityIndicatorSpinner];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Case" objectId:currentFine.Id fields:[NSDictionary dictionaryWithObject:@"Rectified" forKey:@"Status"]];
        
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
    else if(alertView.tag == 2 && buttonIndex == 1) //Re-Issue AlertView
    {
        [self initializeAndStartActivityIndicatorSpinner];
        
        NSString *newStatus = @"";
        NSString *ownerId = @"";
        UITextField *alertTextField = [alertView textFieldAtIndex:0];
        NSString *Comments = alertTextField.text;
        NSLog(@"%@",currentFine.Status);
        if ([currentFine.Status isEqualToString:@"1st Fine Approved"]) {
            newStatus = @"2nd Fine Printed";
            ownerId = fineQueueId;
        }
        else if ([currentFine.Status isEqualToString:@"2nd Fine Approved"]) {
            newStatus = @"3rd Fine Printed";
            ownerId = GR1QueueId;
        }
        else if ([currentFine.Status isEqualToString:@"3rd Fine Open"]) {
            newStatus = @"3rd Fine Printed";
            ownerId = GR1QueueId;
        }
        else if([currentFine.Status isEqualToString:@"Warning"]){ //Discuss
            newStatus = @"2nd Fine Printed";
            ownerId = GR1QueueId;
        }
        /*NewFinesView *fineview = [[NewFinesView alloc] initWithFine:currentFine];
        [self presentViewController:fineview animated:YES completion:nil];*/
        
        SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
        
       /* SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Case"
                                                                                   objectId:currentFine.Id
                                                                                     fields:[NSDictionary dictionaryWithObjects:@[newStatus, ownerId, commetns, accountManager.currentUser.credentials.userId]
                                                                                                                        forKeys:@[@"Status", @"OwnerId", @"Comments__c", @"Latest_Fine_Issuer__c"]]];
        */
        NSString *dateInString = [SFDateUtil toSOQLDateTimeString:[NSDate date] isDateTime:true];
        //selectedPavilionFineObject.Id, @"Pavilion_Fine_Type__c",
        SFRestRequest *getRecordTypeRequest = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'Re_Issue_Fine'"];
        [[SFRestAPI sharedInstance] sendRESTRequest:getRecordTypeRequest failBlock:^(NSError *e) {
            [[[UIAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        } completeBlock:^(NSDictionary *dic){
            NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                                    currentFine.Id,@"Parent_Fine__c",
                                    ownerId, @"OwnerId",
                                    accountManager.currentUser.credentials.userId, @"Latest_Fine_Issuer__c",
                                    [dic objectForKey:@"id"], @"RecordTypeId",
                                    currentCategory.Id, @"AccountId",
                                    currentSubCategory.Id, @"Shop__c",
                                    Comments, @"Comments__c",
                                    newStatus,@"Status",
                                    dateInString, @"Fine_Last_Status_Update_Date__c",
                                    nil];
            SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Case" fields:fields];
            
            [[SFRestAPI sharedInstance] send:request delegate:self];
        }];

        //012g00000000l68 SandbBox
        //01220000000Mbt7 Production
        
    }
}

#pragma SFRestDelegate
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSLog(@"%@",jsonResponse);
    
    currentFine.Status = [request.queryParams objectForKey:@"Status"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicatorSpinner];
        if (![currentFine.Status isEqualToString:@"Rectified"])
        [self.delegate didFinishUpdatingFine];
    });
}

- (void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicatorSpinner];
        [HelperClass messageBox:@"An error occured while updating the fine." withTitle:@"Error"];
    });
}

#pragma FineDetailsViewDelegate
- (void)didFinishUpdatingFine:(Fine *)reissuedFine ImagesArray:(NSMutableArray *)imagesArray {
    if (reissuedFine) {
        [self resetImageViews];
        currentFine = reissuedFine;
        if (imagesArray) {
            if (imagesArray.count>0) {
                self.arrayOfImages = imagesArray;
            }
        }
    dispatch_async(dispatch_get_main_queue(), ^{
        [HelperClass printReceiptForFine:currentFine];
        [self reloadFineView];
        [self.reissueFinePopover dismissPopoverAnimated:YES];
    });
    }
    //[self loadFines];
}

- (void)closeFineDetailsPopup {
    [self.reissueFinePopover dismissPopoverAnimated:YES];
}


@end
