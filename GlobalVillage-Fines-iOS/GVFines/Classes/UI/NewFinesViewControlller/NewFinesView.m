//
//  NewFInesViewController.m
//  GVFines
//
//  Created by Mina Zaklama on 9/28/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "NewFinesView.h"
#import "SFRestRequest.h"
#import "SFRestAPI+Blocks.h"
#import "HelperClass.h"
#import "BusinessCategory.h"
#import "SubCategory.h"
#import "PavilionFineType.h"
#import "Fine.h"
#import "NewFinesTabViewController.h"
#import "SFDateUtil.h"
#import "SFUserAccountManager.h"

@interface NewFinesView ()
@property CGPoint scrollViewContentOffset;
@end

@implementation NewFinesView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        
        [[NSBundle mainBundle] loadNibNamed:@"NewFinesView" owner:self options:nil];
        [self addSubview:self.view];
        
    }
    
    return self;
}

-(id) initWithFine:(Fine *)fine {
    if (self = [super init]) {
        [[NSBundle mainBundle] loadNibNamed:@"NewFinesView" owner:self options:nil];
        [self addSubview:self.view];
    }
    self.fine = fine;
    return self;
}

- (void)awakeFromNib {
    //[super awakeFromNib];
    
    //[[NSBundle mainBundle] loadNibNamed:@"NewFinesView" owner:self options:nil];
    //[self addSubview: self.view];
    
    isLoadingSubCategories = NO;
    isLoadingBusinessCategories = NO;
    isLoadingRecordTypes = NO;
    isLoadingCaseNumber = NO;
    isSubmitPavilionFine = NO;
    isLoadingPavilionFines = NO;
    isLoadingQueueId = NO;
    isCheckingFineExists = NO;
    
    selectedPavilionFineDepartment = @"";
    selectedBusinessCategoryId = @"";
    selectedSubCategoryId = @"";
    pavilionFineRecordTypeId = @"";
    caseNumber = @"";
    
    if (self.fine) {
        BusinessCategory *category;
        for (BusinessCategory *any in self.businessCategoriesArray) {
            if ([any.Name isEqualToString:self.fine.BusinessCategory]) {
                category = any;
            }
        }
        SubCategory *subCategory;
        for (SubCategory *any in self.subCategoriesArray) {
            if ([any.Name isEqualToString:self.fine.SubCategory]) {
                subCategory = any;
            }
        }
        PavilionFineType *fineType;
        for (PavilionFineType *any in self.pavilionFineTypeArray) {
            if ([any.Name isEqualToString:self.fine]) {
                fineType = any;
            }
        }
    }
    
    fineQueueId = @"";
    GR1QueueId = @"";
    
    selectedBusinessCategoryIndex = -1;
    selectedSubCategoryIndex = -1;
    selectedPavilionFineDepartmentIndex = -1;
    selectedPavilionFineDescriptionIndex = -1;
    
    imagesArray = [[NSArray alloc] init];
    
    [self setupPrintButton];
    
    [self loadBusinessCategories];
    [self loadRecordTypeId];
    [self loadPavilionFines];
    [self loadPavilionQueueId];
    
    self.scrollView.scrollEnabled = NO;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapInView)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (IBAction)businessCategoryButtonClicked:(id)sender {
    [self dismissKeyboard];
    
    NSMutableArray* stringArray = [[NSMutableArray alloc] init];
    
    for (BusinessCategory *businessCategory in self.businessCategoriesArray) {
        [stringArray addObject:businessCategory.Name];
    }
    
    PopoverPickerViewController *pickerController = [[PopoverPickerViewController alloc] initWithPickerSourceArray:stringArray defaultSelectIndex:selectedBusinessCategoryIndex];
    
    pickerController.delegate = self;
    pickerController.noValueMessage = @"No Business Categories";
    
    self.businessCategoryPickerPopover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.businessCategoryPickerPopover.popoverContentSize = pickerController.view.frame.size;
    
    self.businessCategoryPickerPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.businessCategoryPickerPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)subCategoryButtonClicked:(id)sender {
    [self dismissKeyboard];
    
    NSMutableArray* stringArray = [[NSMutableArray alloc] init];
    
    for (SubCategory *subCategory in self.subCategoriesArray) {
        [stringArray addObject:subCategory.Name];
    }
    
    PopoverPickerViewController *pickerController = [[PopoverPickerViewController alloc] initWithPickerSourceArray:stringArray defaultSelectIndex:selectedSubCategoryIndex];
    
    pickerController.delegate = self;
    pickerController.noValueMessage = @"No Sub-Categories";
    
    self.subCategoryPickerPopover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.subCategoryPickerPopover.popoverContentSize = pickerController.view.frame.size;
    
    self.subCategoryPickerPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.subCategoryPickerPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
    [self resetAllFields];
}

- (IBAction)printButtonClicked:(id)sender {
    if([self validateInput]) {
        //[self submitFine];
        [self checkIfFineExists];
    }
    else {
        [self showInputErrorAlert];
    }
}

- (IBAction)departmentButtonClicked:(id)sender {
    [self dismissKeyboard];
    
    pavilionFineDepartmentStringArray = [[NSMutableArray alloc] init];
    
    for (PavilionFineType *pavilionFine in self.pavilionFineTypeArray) {
        if(![pavilionFineDepartmentStringArray containsObject:pavilionFine.Department])
            [pavilionFineDepartmentStringArray addObject:pavilionFine.Department];
        
    }
    
    PopoverPickerViewController *pickerController = [[PopoverPickerViewController alloc] initWithPickerSourceArray:pavilionFineDepartmentStringArray defaultSelectIndex:selectedPavilionFineDepartmentIndex];
    
    pickerController.delegate = self;
    pickerController.noValueMessage = @"No Departments";
    
    self.pavilionFineDepartmentPickerPopover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.pavilionFineDepartmentPickerPopover.popoverContentSize = pickerController.view.frame.size;
    
    self.pavilionFineDepartmentPickerPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.pavilionFineDepartmentPickerPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)fineButtonClicked:(id)sender {
    [self dismissKeyboard];
    
    pavilionFineTypeFilteredArray = [[NSMutableArray alloc] init];
    
    if(selectedPavilionFineDepartmentIndex > -1)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Department = %@", selectedPavilionFineDepartment];
        pavilionFineTypeFilteredArray = [NSMutableArray arrayWithArray:[self.pavilionFineTypeArray filteredArrayUsingPredicate:predicate]];
    }
    
    NSMutableArray* stringArray = [[NSMutableArray alloc] init];
    
    for (PavilionFineType *pavilionFineType in pavilionFineTypeFilteredArray) {
        [stringArray addObject:pavilionFineType.ShortDescription];
    }
    
    PopoverPickerViewController *pickerController = [[PopoverPickerViewController alloc] initWithPickerSourceArray:stringArray defaultSelectIndex:selectedPavilionFineDescriptionIndex];
    
    pickerController.delegate = self;
    pickerController.noValueMessage = @"No Fines";
    
    self.pavilionFineDescriptionPickerPopover = [[UIPopoverController alloc] initWithContentViewController:pickerController];
    self.pavilionFineDescriptionPickerPopover.popoverContentSize = pickerController.view.frame.size;
    
    self.pavilionFineDescriptionPickerPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.pavilionFineDescriptionPickerPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)cameraButtonClicked:(id)sender {
    [self dismissKeyboard];
    
    CaptureImagesViewController *captureImagesController = [[CaptureImagesViewController alloc] init];
    
    captureImagesController.mainViewController = self.parentViewController.mainViewController;
    captureImagesController.imagesArray = [[NSMutableArray alloc] initWithArray:imagesArray];
    captureImagesController.delegate = self;
    
    self.imagesSelectionPopover = [[UIPopoverController alloc] initWithContentViewController:captureImagesController];
    self.imagesSelectionPopover.popoverContentSize = captureImagesController.view.frame.size;
    
    self.imagesSelectionPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.imagesSelectionPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)tapInView {
    [self dismissKeyboard];
}

- (void)printReceiptForFine:(Fine*)fine {
    
    [HelperClass printReceiptForFine:fine];
    
    //[self resetAllFields];
}

- (void)showInputErrorAlert {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter all required fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
}

- (BOOL)validateInput {
    BOOL returnValue = YES;
    
    // || self.commentsTextView.tag == 0
    //[selectedSubCategoryId isEqualToString:@""] ||
    
    if(selectedPavilionFineObject == nil || [selectedBusinessCategoryId isEqualToString:@""])
        returnValue = NO;
    
    return returnValue;
}

- (void)setupPrintButton {
    self.printButton.titleEdgeInsets = UIEdgeInsetsMake(0, -self.printButton.imageView.frame.size.width, 0, self.printButton.imageView.frame.size.width);
    self.printButton.imageEdgeInsets = UIEdgeInsetsMake(0, self.printButton.titleLabel.frame.size.width, 0, -self.printButton.titleLabel.frame.size.width - 10);
}

- (void)loadBusinessCategories {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingBusinessCategories = YES;
    self.subCategoriesArray = nil;
    selectedBusinessCategoryId = @"";
    selectedBusinessCategoryIndex = -1;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name ,Season__r.Name FROM Account WHERE Season__r.Name='2015-16' ORDER BY Name ASC"];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadSubCategories {
    [self initializeAndStartActivityIndicatorSpinner];
    [self resetSubCategoryButton];
    
    isLoadingSubCategories = YES;
    self.subCategoriesArray = nil;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery: [NSString stringWithFormat:@"SELECT Id, Name FROM Shop__c WHERE Pavilion__c = '%@' ORDER BY Name ASC", selectedBusinessCategoryId]];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadRecordTypeId {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingRecordTypes = YES;
    pavilionFineRecordTypeId = @"";
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name, DeveloperName FROM RecordType WHERE SobjectType = 'Case' AND DeveloperName = 'Pavilion_Fine'"];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadPavilionFines {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingPavilionFines = YES;
    selectedPavilionFineDepartment = @"";
    selectedPavilionFineObject = nil;
    selectedPavilionFineDepartmentIndex = -1;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name, X1st_Fine_Amount__c, Department__c, Violation_Clause__c, Fine_Description__c, Violation_Short_Description__c,Warning_Included__c FROM Pavilion_Fine_Type__c"];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadPavilionQueueId {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingQueueId = YES;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN ('Fine', 'GR1') AND Type = 'Queue'"];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)checkIfFineExists {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isCheckingFineExists = YES;
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT Id, CaseNumber,Fine_Amount__c, Account.Name,Account.Id,issued__c, Shop__r.Name,Shop__r.Id, Violation_Clause__c,Fine_Stage__c,Pavilion_Fine_Type__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE RecordType.DeveloperName = 'Pavilion_Fine' AND AccountId = '%@' AND Shop__c = '%@' AND Pavilion_Fine_Type__c = '%@' AND Status NOT IN ('Rectified', 'Fine Rejected') AND Season__r.Name='2015-16'", selectedBusinessCategoryId, selectedSubCategoryId, selectedPavilionFineObject.Id];
    
    void (^errorBlock) (NSError*) = ^(NSError *e) {
        isCheckingFineExists = NO;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopActivityIndicatorSpinner];
            [HelperClass messageBox:@"An error occured while contacting the server." withTitle:@"Error"];
        });
    };
    
    void (^successBlock)(NSDictionary *dict) = ^(NSDictionary *dict) {
        isCheckingFineExists = NO;
        
        Fine *existingFine = nil;
        
        for (NSDictionary *obj in [dict objectForKey:@"records"]) {
            NSString *shopId = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopId = [[obj objectForKey:@"Shop__r"] objectForKey:@"Id"];
            NSString *shopName = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopName = [[obj objectForKey:@"Shop__r"] objectForKey:@"Name"];
            NSString *businessCategoryName = @"";
            if(![[obj objectForKey:@"Account"] isKindOfClass:[NSNull class]])
                businessCategoryName = [[obj objectForKey:@"Account"] objectForKey:@"Name"];
            NSString *businessCategoryId =@"";
            if(![[obj objectForKey:@"Account"] isKindOfClass:[NSNull class]])
                businessCategoryId = [[obj objectForKey:@"Account"] objectForKey:@"Id"];
            
            existingFine = [[Fine alloc] initFineWithId:[obj objectForKey:@"Id"]
                                             CaseNumber:[obj objectForKey:@"CaseNumber"]
                                       BusinessCategory:businessCategoryName
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
                                                  Stage:[obj objectForKey:@"Fine_Stage__c"]
                                     BusinessCategoryId:businessCategoryId];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (existingFine == nil) {
                [self submitFine];
            }
            else {
                [self resetAllFields];
                
                FineDetailsViewController *fineDetailsViewController = [[FineDetailsViewController alloc] initFineDetailsViewControllerWithFine:existingFine FineQueueId:fineQueueId GR1QueueId:GR1QueueId];
                
                fineDetailsViewController.delegate = self;
                
                self.fineDetailspopover = [[UIPopoverController alloc] initWithContentViewController:fineDetailsViewController];
                self.fineDetailspopover.delegate = self;
                self.fineDetailspopover.popoverContentSize = fineDetailsViewController.view.frame.size;
                
                CGRect rect = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 1, 1);
                
                [self.fineDetailspopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            }
            
            [self stopActivityIndicatorSpinner];
        });
    };
    
    [[SFRestAPI sharedInstance] performSOQLQuery:selectQuery
                                       failBlock:errorBlock
                                   completeBlock:successBlock];
    
}

- (void)submitFine {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isSubmitPavilionFine = YES;
    
    NSString *dateInString = [SFDateUtil toSOQLDateTimeString:[NSDate date] isDateTime:true];
    SFUserAccountManager *accountManager = [SFUserAccountManager sharedInstance];
    NSString * fineStatus;
    if (selectedPavilionFineObject.WarningIncluded) {
        fineStatus = @"Warning";
    }
    else{
        fineStatus = @"1st Fine Printed";
    }
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            selectedPavilionFineObject.Id, @"Pavilion_Fine_Type__c",
                            fineQueueId, @"OwnerId",
                            accountManager.currentUser.credentials.userId, @"Latest_Fine_Issuer__c",
                            pavilionFineRecordTypeId, @"RecordTypeId",
                            selectedBusinessCategoryId, @"AccountId",
                            fineStatus,@"Status",
                            selectedSubCategoryId, @"Shop__c",
                            self.commentsTextView.text, @"Comments__c",
                            dateInString, @"Fine_Last_Status_Update_Date__c",
                            nil];
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForCreateWithObjectType:@"Case" fields:fields];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)uploadAttachments:(NSString*)caseId Images:(NSArray*)imagesToUpload{
    [self initializeAndStartActivityIndicatorSpinner];
    
    totalAttachmentsToUpload = imagesToUpload.count;
    attachmentsReturned = 0;
    failedImagedArray = [NSMutableArray new];
    attachmentParentId = caseId;
    
    for (UIImage *image in imagesToUpload) {
        
        void (^errorBlock) (NSError*) = ^(NSError *e) {
            [failedImagedArray addObject:image];
            
            dispatch_async(dispatch_get_main_queue(), ^{
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
        [self stopActivityIndicatorSpinner];
        
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

- (void)getFineNumberAndPrint:(NSString*) caseId {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingCaseNumber = YES;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT Id, CaseNumber,Fine_Amount__c, Account.Name,Account.Id,issued__c, Shop__r.Name,Shop__r.Id, Violation_Clause__c,Fine_Stage__c,Pavilion_Fine_Type__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE Id = '%@'", caseId]];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)initializeAndStartActivityIndicatorSpinner {
    if(![self.loadingView isHidden])
        return;
    
    [self.loadingView setHidden:NO];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)stopActivityIndicatorSpinner {
    if(isLoadingBusinessCategories || isLoadingSubCategories || isLoadingRecordTypes ||isLoadingCaseNumber || isSubmitPavilionFine || isLoadingPavilionFines || isLoadingQueueId || isCheckingFineExists || isUploadingAttachments)
        return;
    
    [self.loadingView setHidden:YES];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)resetSubCategoryButton {
    selectedSubCategoryId = @"";
    selectedSubCategoryIndex = -1;
    self.subCategoriesArray = nil;
    [self.subCategoryButton setTitle:@"Sub-Category" forState:UIControlStateNormal];
}

- (void)resetBusinessCategoryButton {
    selectedBusinessCategoryId = @"";
    selectedBusinessCategoryIndex = -1;
    [self.businessCategoryButton setTitle:@"Business Category" forState:UIControlStateNormal];
}

- (void)resetPavilionFineDepartmentButton {
    selectedPavilionFineDepartment = @"";
    selectedPavilionFineDepartmentIndex = -1;
    [self.departmentButton setTitle:@"Department" forState:UIControlStateNormal];
}

- (void)resetPavilionFineDescriptionButton {
    selectedPavilionFineObject = nil;
    selectedPavilionFineDescriptionIndex = -1;
    [self.fineButton setTitle:@"Fine" forState:UIControlStateNormal];
}

- (void)resetFineValues {
    selectedPavilionFineObject = nil;
    
    [self.fineAmountTextField setText:@""];
    
    [self.fineDescriptionTextView setText:@"Fine Description"];
    [self.fineDescriptionTextView setTextColor:[UIColor lightGrayColor]];
    [self.fineDescriptionTextView setFont:[UIFont systemFontOfSize:15]];
    [self.fineDescriptionTextView setTextAlignment:NSTextAlignmentCenter];
    
    [self resetPavilionFineDescriptionButton];
}

- (void)resetCommentsField {
    self.commentsTextView.text = @"";
}

- (void)resetAllFields {
    caseNumber = @"";
    [self resetBusinessCategoryButton];
    [self resetSubCategoryButton];
    [self resetPavilionFineDepartmentButton];
    [self resetFineValues];
    [self resetCommentsField];
}

- (void)setFineDescriptionTextViewValue:(NSString*) description {
    [self.fineDescriptionTextView setText:description];
    [self.fineDescriptionTextView setTextColor:[UIColor blackColor]];
    [self.fineDescriptionTextView setFont:[UIFont systemFontOfSize:15]];
}

- (void)setFineAmountTextFieldValue:(NSNumber*) amount {
    [self.fineAmountTextField setText:[NSString stringWithFormat:@"%ld AED", (long)amount.integerValue]];
}

#pragma UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if(textView.tag == 0) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        textView.font =[UIFont systemFontOfSize:15];
        textView.textAlignment = NSTextAlignmentLeft;
        textView.tag = 1;
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if([textView.text length] == 0)
    {
        textView.text = @"Comments";
        textView.textColor = [UIColor lightGrayColor];
        textView.font =[UIFont systemFontOfSize:15];
        textView.textAlignment = NSTextAlignmentCenter;
        textView.tag = 0;
    }
    return YES;
}

#pragma CaptureImagesViewControllerDelegate
- (void)refreshImagesArray:(NSMutableArray*)imagesMutableArray {
    imagesArray = [NSArray arrayWithArray:imagesMutableArray];
}

#pragma KeyBoard Notifications
-(void) keyboardDidShow: (NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's
    // coordinate system. The bottom of the text view's frame should align with the top
    // of the keyboard's final position.
    //
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    CGFloat keyboardTop = keyboardRect.origin.y;
    CGRect newBiddingViewFrame = self.view.bounds;
    newBiddingViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.scrollViewContentOffset = self.scrollView.contentOffset;
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.scrollView.frame = newBiddingViewFrame;
    
    CGRect textFieldRect = [self.commentsTextView frame];
    //textFieldRect.origin.y += 10;
    [self.scrollView scrollRectToVisible:textFieldRect animated:YES];
    
    self.scrollView.scrollEnabled = YES;
    
    [UIView commitAnimations];
}

-(void) keyboardDidHide: (NSNotification *)notif {
    NSDictionary *userInfo = [notif userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.scrollView.frame = self.view.bounds;
    
    // Reset the scrollview to previous location
    self.scrollView.contentOffset = self.scrollViewContentOffset;
    
    self.scrollView.scrollEnabled = NO;
    
    [UIView commitAnimations];
}

- (void)dismissKeyboard {
    [self endEditing:YES];
}

#pragma UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    if ([self.imagesSelectionPopover isPopoverVisible] || [self.fineDetailspopover isPopoverVisible])
        return YES;
    else
        return NO;
}

#pragma PopoverPickerViewControllerDelegate
- (void)dismissPopover {
    if([self.businessCategoryPickerPopover isPopoverVisible])
        [self.businessCategoryPickerPopover dismissPopoverAnimated:YES];
    else if([self.subCategoryPickerPopover isPopoverVisible])
        [self.subCategoryPickerPopover dismissPopoverAnimated:YES];
    else if([self.pavilionFineDepartmentPickerPopover isPopoverVisible])
        [self.pavilionFineDepartmentPickerPopover dismissPopoverAnimated:YES];
    else if([self.pavilionFineDescriptionPickerPopover isPopoverVisible])
        [self.pavilionFineDescriptionPickerPopover dismissPopoverAnimated:YES];
}

- (void)donePopoverSelectedIndex:(NSInteger)index {
    
    if([self.businessCategoryPickerPopover isPopoverVisible])
    {
        [self.businessCategoryPickerPopover dismissPopoverAnimated:YES];
        if(index > -1) {
            BusinessCategory *obj = [self.businessCategoriesArray objectAtIndex:index];
            selectedBusinessCategoryId = obj.Id;
            [self.businessCategoryButton setTitle:obj.Name forState:UIControlStateNormal];
            selectedBusinessCategoryIndex = index;
            [self loadSubCategories];
            
        }
    }
    else if([self.subCategoryPickerPopover isPopoverVisible])
    {
        [self.subCategoryPickerPopover dismissPopoverAnimated:YES];
        if(index > -1) {
            SubCategory *obj = [self.subCategoriesArray objectAtIndex:index];
            selectedSubCategoryId = obj.Id;
            [self.subCategoryButton setTitle:obj.Name forState:UIControlStateNormal];
            selectedSubCategoryIndex = index;
            
        }
    }
    else if([self.pavilionFineDepartmentPickerPopover isPopoverVisible])
    {
        [self.pavilionFineDepartmentPickerPopover dismissPopoverAnimated:YES];
        if(index > -1) {
            selectedPavilionFineDepartment = [pavilionFineDepartmentStringArray objectAtIndex:index];
            selectedPavilionFineDepartmentIndex = index;
            [self.departmentButton setTitle:selectedPavilionFineDepartment forState:UIControlStateNormal];
            
            [self resetFineValues];
        }
    }
    else if([self.pavilionFineDescriptionPickerPopover isPopoverVisible])
    {
        [self.pavilionFineDescriptionPickerPopover dismissPopoverAnimated:YES];
        if(index > -1)
        {
            selectedPavilionFineObject = [pavilionFineTypeFilteredArray objectAtIndex:index];
            selectedPavilionFineDescriptionIndex = index;
            [self.fineButton setTitle:selectedPavilionFineObject.ShortDescription forState:UIControlStateNormal];
            
            [self setFineAmountTextFieldValue:selectedPavilionFineObject.X1stFineAmount];
            [self setFineDescriptionTextViewValue:selectedPavilionFineObject.Description];
        }
    }
}

#pragma SFRestDelegate
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSString *selectQuery = [request.queryParams objectForKey:@"q"];
    if(!selectQuery && [request.path rangeOfString:@"sobjects/Case"].location != NSNotFound)
    {
        isSubmitPavilionFine = NO;
        [self getFineNumberAndPrint:[jsonResponse objectForKey:@"id"]];
    }
    else if ([selectQuery rangeOfString:@"FROM Account"].location != NSNotFound)
    {
        isLoadingBusinessCategories = NO;
        self.businessCategoriesArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            [self.businessCategoriesArray addObject:[[BusinessCategory alloc]
                                                     initBusinessCategoryWithId:[obj objectForKey:@"Id"]
                                                     AndName:[obj objectForKey:@"Name"]]];
        }
        NSLog(@"request:didLoadResponse: Object: Account, #records: %lu", (unsigned long)self.businessCategoriesArray.count);
    }
    else if ([selectQuery rangeOfString:@"FROM Shop__c"].location != NSNotFound)
    {
        isLoadingSubCategories = NO;
        self.subCategoriesArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            [self.subCategoriesArray addObject:[[SubCategory alloc]
                                                initSubCategoryWithId:[obj objectForKey:@"Id"]
                                                AndName:[obj objectForKey:@"Name"]]];
        }
        NSLog(@"request:didLoadResponse:  Object: Shop__c, #records: %lu", (unsigned long)self.subCategoriesArray.count);
    }
    else if ([selectQuery rangeOfString:@"FROM RecordType"].location != NSNotFound)
    {
        NSArray *recordTypesArray = [jsonResponse objectForKey:@"records"];
        isLoadingRecordTypes = NO;
        NSDictionary *pavilionFineObject = [recordTypesArray objectAtIndex:0];
        pavilionFineRecordTypeId = [pavilionFineObject objectForKey:@"Id"];
    }
    else if([selectQuery rangeOfString:@"FROM Case"].location != NSNotFound)
    {
        isLoadingCaseNumber = NO;
        Fine *newFinesObject;
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            
            NSString *shopId = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopId = [[obj objectForKey:@"Shop__r"] objectForKey:@"Id"];
            NSString *shopName = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopName = [[obj objectForKey:@"Shop__r"] objectForKey:@"Name"];
            NSString *businessCategoryName = @"";
            if(![[obj objectForKey:@"Account"] isKindOfClass:[NSNull class]])
                businessCategoryName = [[obj objectForKey:@"Account"] objectForKey:@"Name"];
            NSString *businessCategoryId =@"";
            if(![[obj objectForKey:@"Account"] isKindOfClass:[NSNull class]])
                businessCategoryId = [[obj objectForKey:@"Account"] objectForKey:@"Id"];
            
            newFinesObject = [[Fine alloc] initFineWithId:[obj objectForKey:@"Id"]
                                               CaseNumber:[obj objectForKey:@"CaseNumber"]
                                         BusinessCategory:businessCategoryName
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
                                                    Stage:[obj objectForKey:@"Fine_Stage__c"]
                                       BusinessCategoryId:businessCategoryId];

        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self printReceiptForFine:newFinesObject];
            [self resetAllFields];
            // TODO: Call Upload attachments method
            [self uploadAttachments:newFinesObject.Id Images:imagesArray];
        });
    }
    else if([selectQuery rangeOfString:@"FROM Pavilion_Fine_Type__c"].location != NSNotFound)
    {
        isLoadingPavilionFines = NO;
        self.pavilionFineTypeArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            [self.pavilionFineTypeArray addObject:[[PavilionFineType alloc]
                                                   initPavilionFineTypeWithId:[obj objectForKey:@"Id"]
                                                   Name:[obj objectForKey:@"Name"]
                                                   FineAmount:(NSNumber*)[obj objectForKey:@"X1st_Fine_Amount__c"]
                                                   Department:[obj objectForKey:@"Department__c"]
                                                   ViolationClause:[obj objectForKey:@"Violation_Clause__c"]
                                                   Description:[obj objectForKey:@"Fine_Description__c"]
                                                   ShortDescription:[obj objectForKey:@"Violation_Short_Description__c"] WarningIncluded:[[obj objectForKey:@"Warning_Included__c"] boolValue]]];
        }
        NSLog(@"request:didLoadResponse:  Object: Pavilion_Fine_Type__c, #records: %lu", (unsigned long)self.pavilionFineTypeArray.count);
    }
    else if([selectQuery rangeOfString:@"FROM Group"].location != NSNotFound)
    {
        isLoadingQueueId = NO;
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            if([[obj objectForKey:@"DeveloperName"] isEqualToString:@"Fine"])
                fineQueueId = [obj objectForKey:@"Id"];
            else if([[obj objectForKey:@"DeveloperName"] isEqualToString:@"GR1"])
                GR1QueueId = [obj objectForKey:@"Id"];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicatorSpinner];
    });
}

- (void)request:(SFRestRequest *)request didFailLoadWithError:(NSError *)error {
    NSString *selectQuery = [request.queryParams objectForKey:@"q"];
    if(!selectQuery && [request.path rangeOfString:@"sobjects/Case"].location != NSNotFound)
    {
        isSubmitPavilionFine = NO;
    }
    else if ([selectQuery rangeOfString:@"FROM Account"].location != NSNotFound)
    {
        isLoadingBusinessCategories = NO;
    }
    else if ([selectQuery rangeOfString:@"FROM Shop__c"].location != NSNotFound)
    {
        isLoadingSubCategories = NO;
    }
    else if ([selectQuery rangeOfString:@"FROM RecordType"].location != NSNotFound)
    {
        isLoadingRecordTypes = NO;
    }
    else if([selectQuery rangeOfString:@"FROM Case"].location != NSNotFound)
    {
        isLoadingCaseNumber = NO;
    }
    else if([selectQuery rangeOfString:@"FROM Pavilion_Fine_Type__c"].location != NSNotFound)
    {
        isLoadingPavilionFines = NO;
    }
    else if([selectQuery rangeOfString:@"FROM Group"].location != NSNotFound)
    {
        isLoadingQueueId = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicatorSpinner];
        //if (selectedPavilionFineObject.WarningIncluded) {
        [HelperClass messageBox:@"An error occured while contacting the server." withTitle:@"Error"];
        //}
        
    });
}

#pragma FineDetailsViewDelegate
- (void)didFinishUpdatingFine {
    [self.fineDetailspopover dismissPopoverAnimated:YES];
}

- (void)closeFineDetailsPopup {
    [self.fineDetailspopover dismissPopoverAnimated:YES];
}

#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
        return;
    
    if (buttonIndex == 1) {
        [self uploadAttachments:attachmentParentId Images:failedImagedArray];
    }
    
}

@end
