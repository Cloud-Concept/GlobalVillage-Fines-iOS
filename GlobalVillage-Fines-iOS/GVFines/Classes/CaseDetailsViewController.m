//
//  CaseDetailsViewController.m
//  GVFines
//
//  Created by omer gawish on 9/15/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "CaseDetailsViewController.h"
#import "FineDetailsViewController.h"
#import "Fine.h"
#import "HelperClass.h"
#import "SFRestAPI+Blocks.h"
#import "SFUserAccountManager.h"
#import "SFOAuthCoordinator.h"
#import "UIViewController+MJPopupViewController.h"
#import "Case.h"

@interface CaseDetailsViewController ()

@end

@implementation CaseDetailsViewController

- (instancetype)initWithCase:(Case *)anyCase
{
    if(self=[super initWithNibName:nil bundle:nil]){
        self.currentCase = anyCase;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.currentCase.caseNumber && ![self.currentCase.caseNumber isKindOfClass:[NSNull class]]) {
        self.caseNumber.text = self.currentCase.caseNumber;
    }
    if (self.currentCase.BusinessCategory && ![self.currentCase.BusinessCategory isKindOfClass:[NSNull class]]) {
        self.categoryLabel.text = self.currentCase.BusinessCategory;
    }
    if (self.currentCase.nationality && ![self.currentCase.nationality isKindOfClass:[NSNull class]]) {
        self.nationalityLabel.text = self.currentCase.nationality;
    } else {
        self.baseNationality.hidden = YES;
    }
    if (self.currentCase.passportNumber && ![self.currentCase.passportNumber isKindOfClass:[NSNull class]]) {
        self.passportIssueDateLabel.text = self.currentCase.passportNumber;
    } else{
        self.basePassportLabel.hidden = YES;
    }
    //self.passportIssueDateLabel.text = self.currentCase.passportNumber;
    if (self.currentCase.visaNumber && ![self.currentCase.visaNumber isKindOfClass:[NSNull class]]) {
        self.visaNumberLabel.text = self.currentCase.visaNumber;
    } else {
        self.baseVisaLabel.hidden = YES;
    }
    if (self.currentCase.rejectionReason && ![self.currentCase.rejectionReason isKindOfClass:[NSNull class]]) {
        self.rejectionReasonLabel.text = self.currentCase.rejectionReason;
    } else {
        self.rejectionReason.hidden = YES;
    }
    if (self.currentCase.lastModified && ![self.currentCase.lastModified isKindOfClass:[NSNull class]]) {
        NSString *rejectionDateString = [[self.currentCase.lastModified componentsSeparatedByString:@"T"] objectAtIndex:0];
        self.rejectionDateLabel.text = rejectionDateString;
    } else {
        self.dateOfRejection.hidden = YES;
    }
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [format setDateFormat:@"yyyy-MM-dd"];
    [format setTimeZone:[NSTimeZone defaultTimeZone]];
    self.passportIssueDateLabel.text = [format stringFromDate:self.currentCase.passportIssueDate];
    //self.issuedByLabel.text = self.currentCase.CreatedBy;
    self.createdDateLabel.text = [format stringFromDate:self.currentCase.CreatedDate];
    if (![self.currentCase.fullName isKindOfClass:[NSNull class]]) {
        self.fullNameLabel.text = self.currentCase.fullName;
    } else {
        self.fullNameLabel.text = @"Unknown";
    }
    
    
    
    self.imagesScrollView.delegate = self;
       SFRestRequest *requestForImages = [[SFRestAPI sharedInstance] requestForQuery:[NSString stringWithFormat:@"SELECT Id,Body,ParentId FROM Attachment WHERE ParentId='%@'",self.currentCase.Id]];
    [[SFRestAPI sharedInstance] sendRESTRequest:requestForImages failBlock:^(NSError *e) {
        [[[UIAlertView alloc] initWithTitle:@"Sorry." message:@"Something went wrong" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    } completeBlock:^(NSDictionary *dic){
        NSArray *records = [dic objectForKey:@"records"];
        self.arrayOfImages = [[NSMutableArray alloc] init];
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
        int recordsArraySize = records.count;
        for (NSDictionary *record in records) {
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
            UIImage *singleImage = [UIImage imageWithData:data];
            if (singleImage) {
                dispatch_async(dispatch_get_main_queue(), ^{
                UIImageView *singleImageView = [[UIImageView alloc] initWithImage:singleImage];
                //UIImageView *singleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60*counter+10, 5, 50, 50)];
                singleImageView.frame = CGRectMake(60*counter+10, 5, 50, 50);
                [self.arrayOfImages addObject:singleImage];
                //singleImageView.image = singleImage;
                //[singleImageView setImage:singleImage];
                self.imagesScrollView.contentSize = CGSizeMake(60*counter+70, 59);
                
                //[self.imageViews addObject:image];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = counter;
                [button addTarget:self
                           action:@selector(imageTapped:)
                 forControlEvents:UIControlEventTouchUpInside];
                button.frame = singleImageView.frame;
                //dispatch_async(dispatch_get_main_queue(), ^{
                    //UIImageView *image = [[self.imageViews objectAtIndex:counter] initWithImage:[self.arrayOfImages objectAtIndex:counter]];
                    
                   
                    [self.imagesScrollView addSubview:button];
                    [self.imagesScrollView addSubview:singleImageView];
                    if (counter == (recordsArraySize-1)) {
                        [self.imageDownloadingIndicator stopAnimating];
                    }
                });
                counter++;
            }
            else {
                recordsArraySize--;
            }
            
            ////
            
        }
    }];
    

    // Do any additional setup after loading the view.
}

- (IBAction)closeButtonClicked:(id)sender {
    [self.delegate closeCaseDetailsPopup];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
