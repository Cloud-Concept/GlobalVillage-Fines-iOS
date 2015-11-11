//
//  ReissueViewController.m
//  GVFines
//
//  Created by omer gawish on 10/28/15.
//  Copyright © 2015 CloudConcept. All rights reserved.
//

#import "ReissueViewController.h"
#import "SVProgressHUD.h"

@interface ReissueViewController ()
@property (weak, nonatomic) IBOutlet UITextView *commentsView;
@property (strong, nonatomic) Fine *reissuedFine;

@end

@implementation ReissueViewController


- (id)initWithFine:(Fine*)fine FineQueueId:(NSString*)fineQueueIdValue GR1QueueId:(NSString*)GR1QueueIdValue BusinessCategory:(BusinessCategory *)category SubCategory:(SubCategory *)subCategory {
    self =  [super initWithNibName:nil bundle:nil];
    
    self.fine = fine;
    self.category = category;
    self.subCategory = subCategory;
    self.fineQueueId = fineQueueIdValue;
    self.GR1QueueId = GR1QueueIdValue;
    
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentsView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelBtnClicked:(id)sender {
    [self.delegate closeFineDetailsPopup];
}
- (IBAction)printClicked:(id)sender {
        //[self initializeAndStartActivityIndicatorSpinner];

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Loading..."];
    
        NSString *newStatus = @"";
        NSString *ownerId = @"";
        //        UIAlertController *addImages = [UIAlertController alertControllerWithTitle:@"More Images" message:@"Do went to upload more images?" preferredStyle:UIAlertControllerStyleAlert];
        //        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            [self cameraButtonClicked:self];
        //        }];
        //        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //            //[self cameraButtonClicked:self];
        //        }];
        //        [addImages addAction:yesAction];
        //        [addImages addAction:noAction];
        //
        //        dispatch_sync(dispatch_get_main_queue(), ^{
        //        [self presentViewController:addImages animated:YES completion:nil];
        //        });
        //UITextField *alertTextField = [alertView textFieldAtIndex:0];
        NSString *commetns = self.commentsView.text;
        NSLog(@"%@",self.fine.Status);
        if ([self.fine.Status isEqualToString:@"1st Fine Approved"]) {
            newStatus = @"2nd Fine Printed";
            ownerId = self.fineQueueId;
        }
        else if ([self.fine.Status isEqualToString:@"2nd Fine Approved"]) {
            newStatus = @"3rd Fine Printed";
            ownerId = self.GR1QueueId;
        }
        else if ([self.fine.Status isEqualToString:@"3rd Fine Open"]) {
            newStatus = @"3rd Fine Printed";
            ownerId = self.GR1QueueId;
        }
        else if([self.fine.Status isEqualToString:@"Warning Approved"]){ //Discuss
            newStatus = @"1st Fine Printed";
            ownerId = self.GR1QueueId;
        }
        /*NewFinesView *fineview = [[NewFinesView alloc] initWithFine:currentFine];
         [self presentViewController:fineview animated:YES completion:nil];*/
        
        SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
        //update issued checkbox
         SFRestRequest *issuedRequest = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:@"Case"
         objectId:self.fine.Id
         fields:[NSDictionary dictionaryWithObjects:@[@YES, self.GR1QueueId, accountManager.currentUser.credentials.userId]
         forKeys:@[@"issued__c", @"OwnerId", @"Latest_Fine_Issuer__c"]]];
    
        NSString *dateInString = [SFDateUtil toSOQLDateTimeString:[NSDate date] isDateTime:true];
        //selectedPavilionFineObject.Id, @"Pavilion_Fine_Type__c",
    //SELECT Id, CaseNumber, Account.Name, Shop__r.Name,issued__c, Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c,Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c FROM Case WHERE RecordType.DeveloperName = 'Re_Issue_Fine' AND Issued__c != true
    //012g00000000l68 Sand
    //01220000000Mbt7 Production
        NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                                self.fine.Id,@"Parent_Fine__c",
                                ownerId, @"OwnerId",
                                self.fine.pavilionFineType,@"Pavilion_Fine_Type__c",
                                self.fine.shopId,@"Shop__c",
                                accountManager.currentUser.credentials.userId, @"Latest_Fine_Issuer__c",
                                @"012g00000000l68", @"RecordTypeId",
                                self.category.Id, @"AccountId",
                                self.fine.Comments, @"Comments__c",
                                newStatus,@"Status",
                                dateInString, @"Fine_Last_Status_Update_Date__c",
                                nil];
        SFRestRequest *createFineRequest = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Case" fields:fields];
    /*self.fine.ViolationClause,@"Violation_Clause__c"
    ,self.fine.ViolationDescription,@"Violation_Description__c",
    self.fine.ViolationShortDescription,@"Violation_Short_Description__c",
    self.fine.X1stFineAmount,@"Fine_Amount__c",
    self.fine.X2ndFineAmount,@"X2nd_Fine_Amount__c",*/
        //[[SFRestAPI sharedInstance] send:request1 delegate:self];
    [[SFRestAPI sharedInstance] sendRESTRequest:issuedRequest failBlock:^(NSError *e) {
        [[[UIAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
    } completeBlock:^(NSDictionary *dic){
        [[SFRestAPI sharedInstance] send:createFineRequest delegate:self];
    }];
    
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

- (void)uploadAttachmentsWithCaseId:(NSString *)caseId{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:@"Uploading..."];

    totalAttachmentsToUpload = self.imagesArray.count;
    attachmentsReturned = 0;
    failedImagedArray = [NSMutableArray new];
    attachmentParentId = caseId;
    
    for (UIImage *image in self.imagesArray) {
        
        void (^errorBlock) (NSError*) = ^(NSError *e) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [failedImagedArray addObject:image];
            [self uploadDidReturn];
            });
        };
        
        void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
            dispatch_async(dispatch_get_main_queue(), ^{
            [self uploadDidReturn];
            });
        };
        
        UIImage *resizedImage = [HelperClass imageWithImage:image ScaledToSize:CGSizeMake(480, 640)];
        
        NSData *imageData = UIImagePNGRepresentation(resizedImage);
        
        NSString *string = [imageData base64EncodedStringWithOptions:0];
        
        NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Image.png", @"Name",
                                caseId, @"ParentId",
                                @"image/png",@"ContentType",
                                string, @"Body",
                                nil];
        
        isUploadingAttachments = YES;
        [[SFRestAPI sharedInstance] performCreateWithObjectType:@"Attachment"
                                                         fields:fields
                                                      failBlock:errorBlock
                                                  completeBlock:successBlock];
    }

}

- (void)uploadDidReturn {
    attachmentsReturned++;
    
    if (attachmentsReturned == totalAttachmentsToUpload) {
        isUploadingAttachments = NO;
        //[self stopActivityIndicatorSpinner];
        
            [SVProgressHUD dismiss];
        
        if (failedImagedArray.count > 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                             message:@"Uploading the images failed."
                                                            delegate:self
                                                   cancelButtonTitle:@"Cancel"
                                                   otherButtonTitles:@"Retry", nil];
            [alert show];
        }
    }
}

#pragma CaptureImagesViewControllerDelegate
- (void)refreshImagesArray:(NSMutableArray*)imagesMutableArray {
    self.imagesArray = [NSArray arrayWithArray:imagesMutableArray];
}

#pragma SFRestDelegate
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSLog(@"%@",jsonResponse);
//    NSString *selectQuery = [request.queryParams objectForKey:@"q"];
//    if([selectQuery rangeOfString:@"FROM Case"].location != NSNotFound)
    self.fine.Status = [request.queryParams objectForKey:@"Status"];
    
    [self uploadAttachmentsWithCaseId:[jsonResponse objectForKey:@"id"]];
    NSString *requestString = [NSString stringWithFormat:@"SELECT Id, CaseNumber, Account.Name, Shop__r.Id,Shop__r.Name,Fine_Stage__c,issued__c, Violation_Clause__c,Pavilion_Fine_Type__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c,Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c FROM Case WHERE Id='%@' Limit 1",[jsonResponse objectForKey:@"id"]];
    SFRestRequest *requestForFine = [[SFRestAPI sharedInstance] requestForQuery:requestString];
    //[NSString stringWithFormat:@"",[jsonResponse objectForKey:@"Id"]];
    [[SFRestAPI sharedInstance] sendRESTRequest:requestForFine failBlock:^(NSError *e) {
        NSLog(@"Can't get the saved fine.");
    } completeBlock: ^(NSDictionary *dic){
        NSDictionary *obj = [[dic objectForKey:@"records"] objectAtIndex:0];
        if (obj) {
            NSString *shopId = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopId = [[obj objectForKey:@"Shop__r"] objectForKey:@"Id"];
            NSString *shopName = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopName = [[obj objectForKey:@"Shop__r"] objectForKey:@"Name"];
            self.reissuedFine = [[Fine alloc] initFineWithId:[obj objectForKey:@"Id"]
                                                  CaseNumber:[obj objectForKey:@"CaseNumber"]
                                            BusinessCategory:[[obj objectForKey:@"Account"] objectForKey:@"Name"]
                                                 SubCategory:shopName
                                             ViolationClause:[obj objectForKey:@"Violation_Clause__c"]
                                        ViolationDescription:[obj objectForKey:@"Violation_Description__c"]
                                   ViolationShortDescription:[obj objectForKey:@"Violation_Short_Description__c"]
                                              FineDepartment:[obj objectForKey:@"Fine_Department__c"]
                                              X1stFineAmount:(NSNumber*)[obj objectForKey:@"Fine_Amount__c"]
                                              X2ndFineAmount:(NSNumber*)[obj objectForKey:@"Fine_Amount__c"]
                                                    Comments:[obj objectForKey:@"Comments__c"]
                                                      Status:[obj objectForKey:@"Status"]
                                                   CreatedBy:[[obj objectForKey:@"CreatedBy"] objectForKey:@"Name"]
                                                 CreatedDate:[obj objectForKey:@"CreatedDate"]
                                    FineLastStatusUpdateDate:[obj objectForKey:@"Fine_Last_Status_Update_Date__c"]
                                                      Issued:[obj objectForKey:@"issued__c"]
                                                      shopId:shopId
                                            PavilionFineType:[obj objectForKey:@"Pavilion_Fine_Type__c"]
                                 Stage:[obj objectForKey:@"Fine_Stage__c"]];
            //[HelperClass printReceiptForFine:self.reissuedFine];
            [self.delegate didFinishUpdatingFine:self.reissuedFine ImagesArray:[self.imagesArray mutableCopy]];
            //[HelperClass printReceiptForFine:self.reissuedFine];
            if (![self.fine.Status isEqualToString:@"Rectified"])
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self stopActivityIndicatorSpinner];
                //[HelperClass printReceiptForFine:self.reissuedFine];
                [SVProgressHUD dismiss];
            });
        } else{
        //[self.delegate didFinishUpdatingFine:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[self stopActivityIndicatorSpinner];
                [SVProgressHUD dismiss];
            });
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Data recived is empty." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
}

- (void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self stopActivityIndicatorSpinner];
        [HelperClass messageBox:@"An error occured while updating the fine." withTitle:@"Error"];
        [SVProgressHUD dismiss];
    });
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Comments"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Comments";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        return;
    
    if (buttonIndex == 1) {
        [self uploadAttachmentsWithCaseId:attachmentParentId];
    }
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
