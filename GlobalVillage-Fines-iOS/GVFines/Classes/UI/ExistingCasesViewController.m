//
//  ExistingCasesViewController.m
//  GVFines
//
//  Created by omer gawish on 9/8/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "ExistingCasesViewController.h"
#import "SFRestRequest.h"
#import "Fine.h"
#import "BusinessCategory.h"
#import "SubCategory.h"
#import "PavilionFineType.h"
#import "HelperClass.h"
#import "CaseTableViewCell.h"
#import "Case.h"

@interface ExistingCasesViewController ()

@end

@implementation ExistingCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isLoadingBusinessCategories = NO;
    isLoadingSubCategories = NO;
    isLoadingQueueId = NO;
    
    showAllFines = NO;
    
    sortByClause = @"Date";
    
    selectedBusinessCategoryObject = nil;
    selectedSubCategoryObject = nil;
    
    fineQueueId = @"";
    GR1QueueId = @"";
    
    selectedBusinessCategoryIndex = -1;
    selectedSubCategoryIndex = -1;
    
    [self loadBusinessCategories];
    //[self loadPavilionFines];
    //[self loadFines];
    [self loadPavilionQueueId];
    
    [HelperClass createViewWithShadows:self.filterView];
    [HelperClass createViewWithShadows:self.infringementsView];
    
}

- (void) viewDidAppear:(BOOL)animated {
    self.finesTableView.delegate = self;
    [self.finesTableView setAllowsSelection:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)businessCategoryButtonClicked:(id)sender {
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


- (IBAction)resetButtonClicked:(id)sender {
    [self resetAllFields];
}

- (IBAction)filterButtonClicked:(id)sender {
    //[self filterFinesTable];
    [self loadFilteredFinesArray];
}

- (NSString *)getCaseNumberFromTextField {
    if (![self.caseNumberTextField.text isEqual:@""])
        return self.caseNumberTextField.text;
    return nil;
}

- (IBAction)showCriteriaButtonClicked:(id)sender {
    
    NSArray *stringArray = [NSArray arrayWithObjects:@"Show All", @"Show Open", nil];
    
    SFPickListViewController *pickListViewController = [SFPickListViewController createPickListViewController:stringArray selectedValue:self.showCriteriaButton.titleLabel.text];
    
    pickListViewController.delegate = self;
    pickListViewController.preferredContentSize = CGSizeMake(320, stringArray.count * 44);
    
    self.showCriteriaPopover = [[UIPopoverController alloc] initWithContentViewController:pickListViewController];
    
    self.showCriteriaPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.showCriteriaPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)sortByButtonClicked:(id)sender {
    NSArray *stringArray = [NSArray arrayWithObjects:@"Business Category", @"Sub Category", @"Status", @"Date", nil];
    
    SFPickListViewController *pickListViewController = [SFPickListViewController createPickListViewController:stringArray selectedValue:sortByClause];
    
    pickListViewController.delegate = self;
    
    pickListViewController.preferredContentSize = CGSizeMake(320, stringArray.count * 44);
    
    self.sortByPopover = [[UIPopoverController alloc] initWithContentViewController:pickListViewController];
    self.sortByPopover.delegate = self;
    
    UIButton *senderButton = (UIButton*)sender;
    
    [self.sortByPopover presentPopoverFromRect:senderButton.frame inView:senderButton.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}



- (void)loadFines {
    [self initializeAndStartActivityIndicatorSpinner];
    
    //isLoadingFines = YES;
    //TODO isLoadingCases
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, CaseNumber, Account.Name,RecordType.Name, Shop__r.Name,Shop__r.Id,Fine_Stage__c,Full_Name__c, Gender__c,Mobile_Number__c,Date_of_Birth__c,Nationality__c,Passport_Number__c, Visa_Number__c,Passport_Issue_Date__c,  Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE (NOT RecordType.DeveloperName LIKE '%Fine') AND (NOT  RecordType.DeveloperName LIKE 'Support') AND Season__r.Name='2015-16'"];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadBusinessCategories {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingBusinessCategories = YES;
    self.subCategoriesArray = nil;
    selectedBusinessCategoryObject = nil;
    selectedBusinessCategoryIndex = -1;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name ,Season__r.Name FROM Account WHERE Season__r.Name='2015-16' ORDER BY Name ASC"];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadSubCategories {
    [self initializeAndStartActivityIndicatorSpinner];
    [self resetSubCategoryButton];
    
    isLoadingSubCategories = YES;
    self.subCategoriesArray = nil;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery: [NSString stringWithFormat:@"SELECT Id, Name FROM Shop__c WHERE Pavilion__c = '%@' ORDER BY Name ASC", selectedBusinessCategoryObject.Id]];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)loadPavilionQueueId {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingQueueId = YES;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN ('Fine', 'GR1') AND Type = 'Queue'"];
    
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)initializeAndStartActivityIndicatorSpinner {
    if(![self.loadingView isHidden])
        return;
    
    [self.loadingView setHidden:NO];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
   // NSLog(@"%hhd",[[UIApplication sharedApplication] isIgnoringInteractionEvents]);
}

- (void)stopActivityIndicatorSpinner {
    if(isLoadingBusinessCategories || isLoadingSubCategories || isLoadingQueueId)
        return;
    
    [self.loadingView setHidden:YES];
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)resetBusinessCategoryButton {
    selectedBusinessCategoryObject = nil;
    selectedBusinessCategoryIndex = -1;
    [self.businessCategoryButton setTitle:@"Business Category" forState:UIControlStateNormal];
}

- (void)resetSubCategoryButton {
    selectedSubCategoryObject = nil;
    selectedSubCategoryIndex = -1;
    self.subCategoriesArray = nil;
    [self.subCategoryButton setTitle:@"Sub-Category" forState:UIControlStateNormal];
}

- (void)resetCaseNumberTextField {
    [self.caseNumberTextField setText:@""];
}



- (void)resetAllFields {
    [self resetBusinessCategoryButton];
    [self resetSubCategoryButton];
    [self resetCaseNumberTextField];
    [self filterFinesTable];
}

- (void)filterFinesTable {
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    
    [predicateString appendFormat:@"BusinessCategory LIKE '%@' ", selectedBusinessCategoryObject ? selectedBusinessCategoryObject.Name : @"*"];
    
    [predicateString appendFormat:@"AND SubCategory LIKE '%@' ", selectedSubCategoryObject ? selectedSubCategoryObject.Name : @"*"];
    
    //TODO write here the text filter logic
    if (![self.caseNumberTextField.text isEqual:@""])
        [predicateString appendFormat:@"AND  caseNumber='%@' ",self.caseNumberTextField.text];
    
    
    
    if(!showAllFines)
        [predicateString appendString:@"AND NOT(Status IN {\"Rectified\", \"Fine Rejected\", \"3rd Fine Approved\"})"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
    finesFilteredArray = [NSMutableArray arrayWithArray:[self.finesArray filteredArrayUsingPredicate:predicate]];
    
    [self sortFilteredFinesArray];
    
    [self.finesTableView reloadData];
}

//SELECT Id, CaseNumber, Account.Name,RecordType.Name, Shop__r.Name,Shop__r.Id,Fine_Stage__c,Full_Name__c, Gender__c,Mobile_Number__c,Date_of_Birth__c,Nationality__c,Passport_Number__c, Visa_Number__c,Passport_Issue_Date__c,  Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE (NOT RecordType.DeveloperName LIKE '%Fine') AND (NOT  RecordType.DeveloperName LIKE 'Support') AND Season__r.Name='2015-16'
-(void) loadFilteredFinesArray{
    BOOL sendQuery = NO;
    
    NSMutableString *query = [[NSMutableString alloc] initWithString:@"SELECT Id, CaseNumber, Account.Name,Account.Id,RecordType.Name, Shop__r.Name,Shop__r.Id,Fine_Stage__c,Full_Name__c, Gender__c,Mobile_Number__c,Date_of_Birth__c,Nationality__c,Passport_Number__c, Visa_Number__c,Passport_Issue_Date__c,  Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE (NOT RecordType.DeveloperName LIKE '%Fine') AND (NOT  RecordType.DeveloperName LIKE 'Support') AND Season__r.Name='2015-16'"];
    if (![self.caseNumberTextField.text isEqualToString:@""]) {
        [query appendString:[NSString stringWithFormat:@" AND CaseNumber='%@'",self.caseNumberTextField.text]];
        sendQuery = YES;
    }
    if (selectedBusinessCategoryObject) {
        [query appendString:[NSString stringWithFormat:@" AND Account.Id='%@'",selectedBusinessCategoryObject.Id]];
        sendQuery = YES;
        if (selectedSubCategoryObject) {
            [query appendString:[NSString stringWithFormat:@" AND Shop__r.Id='%@'",selectedSubCategoryObject.Id]];
        }
    }
    if (sendQuery) {
        [self initializeAndStartActivityIndicatorSpinner];
        SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:query];
        [[SFRestAPI sharedInstance] send:request delegate:self];
    }
}

- (void)sortFilteredFinesArray {
    NSArray *sortedArray = [[NSArray alloc] init];
    
    if ([sortByClause isEqualToString:@"Business Category"]) {
        sortedArray = [finesFilteredArray sortedArrayUsingComparator:[Fine sortFineByBusinessCategoryComparator]];
    } else if ([sortByClause isEqualToString:@"Sub Category"]) {
        sortedArray = [finesFilteredArray sortedArrayUsingComparator:[Fine sortFineBySubCategoryComparator]];
    } else if ([sortByClause isEqualToString:@"Violation Clause"]) {
        sortedArray = [finesFilteredArray sortedArrayUsingComparator:[Fine sortFineByViolationClauseComparator]];
    } else if ([sortByClause isEqualToString:@"Department"]) {
        sortedArray = [finesFilteredArray sortedArrayUsingComparator:[Fine sortFineByDepartmentComparator]];
    } else if ([sortByClause isEqualToString:@"Status"]) {
        sortedArray = [finesFilteredArray sortedArrayUsingComparator:[Fine sortFineByStatusComparator]];
    } else if ([sortByClause isEqualToString:@"Date"]) {
        sortedArray = [finesFilteredArray sortedArrayUsingComparator:[Fine sortFineByCreatedDateComparator]];
    }
    
    finesFilteredArray = [NSMutableArray arrayWithArray:sortedArray];
}

#pragma UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    if([self.businessCategoryPickerPopover isPopoverVisible] ||
       [self.subCategoryPickerPopover isPopoverVisible] ||
       [self.pavilionFineDepartmentPickerPopover isPopoverVisible] ||
       [self.pavilionFineDescriptionPickerPopover isPopoverVisible])
        return NO;
    else
        return YES;
}

#pragma CompanyDetailsPopoverDelegate
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
            selectedBusinessCategoryObject = [self.businessCategoriesArray objectAtIndex:index];
            [self.businessCategoryButton setTitle:selectedBusinessCategoryObject.Name forState:UIControlStateNormal];
            selectedBusinessCategoryIndex = index;
            [self loadSubCategories];
            
        }
    }
    else if([self.subCategoryPickerPopover isPopoverVisible])
    {
        [self.subCategoryPickerPopover dismissPopoverAnimated:YES];
        if(index > -1) {
            selectedSubCategoryObject = [self.subCategoriesArray objectAtIndex:index];
            [self.subCategoryButton setTitle:selectedSubCategoryObject.Name forState:UIControlStateNormal];
            selectedSubCategoryIndex = index;
            
        }
    }
    /* TODO no need to do anthing here :D
     else if([self.pavilionFineDescriptionPickerPopover isPopoverVisible])
    {
        
    }
     */
}

#pragma SFPickListViewDelegate
- (void)valuePickCanceled:(SFPickListViewController *)picklist {
    
}

- (void)valuePicked:(NSString *)value pickList:(SFPickListViewController *)picklist {
    
    if([self.showCriteriaPopover isPopoverVisible])
    {
        if([value isEqualToString:@"Show All"])
            showAllFines = YES;
        else if ([value isEqualToString:@"Show Open"])
            showAllFines = NO;
        
        [self.showCriteriaButton setTitle:value forState:UIControlStateNormal];
        
        [self.showCriteriaPopover dismissPopoverAnimated:YES];
        
        [self filterFinesTable];
    }
    else if ([self.sortByPopover isPopoverVisible])
    {
        sortByClause = value;
        
        [self.sortByPopover dismissPopoverAnimated:YES];
        
        [self sortFilteredFinesArray];
        
        [self.finesTableView reloadData];
    }
    
}

#pragma SFRestDelegate
- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSString *selectQuery = [request.queryParams objectForKey:@"q"];
    if([selectQuery rangeOfString:@"FROM Case"].location != NSNotFound)
    {
        //isLoadingFines = NO;
        //TODO i think i should create isLoadingCases instead
        //TODO create fill the casesArray , not finesArray remember to change this
        self.finesArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            NSString *shopName = @"";
            if(![[obj objectForKey:@"Shop__r"] isKindOfClass:[NSNull class]])
                shopName = [[obj objectForKey:@"Shop__r"] objectForKey:@"Name"];
            
            NSString *businessCategoryName = @"";
            if(![[obj objectForKey:@"Account"] isKindOfClass:[NSNull class]])
                businessCategoryName = [[obj objectForKey:@"Account"] objectForKey:@"Name"];
            
            NSString *serviceType =@"";
            if (![[obj objectForKey:@"RecordType"] isKindOfClass:[NSNull class]]) {
                serviceType =[[obj objectForKey:@"RecordType"] objectForKey:@"Name"];
            }
            
            NSDate *createDate = nil;
            if (![[obj objectForKey:@"CreatedDate"] isKindOfClass:[NSNull class]]) {
                NSDateFormatter *format = [[NSDateFormatter alloc] init];
                [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
                [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
                [format setTimeZone:[NSTimeZone defaultTimeZone]];
                createDate = [format dateFromString:[obj objectForKey:@"CreatedDate"]];
            }
            //SELECT Id, CaseNumber, Account.Name,RecordType.DeveloperName, Shop__r.Name,Full_Name__c, Gender__c,Mobile_Number__c,Date_of_Birth__c,Nationality__c,Passport_Number__c, Visa_Number__c,Passport_Issue_Date__c,  Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c FROM Case WHERE (NOT RecordType.DeveloperName LIKE '%Fine')"
            [self.finesArray addObject:[[Case alloc] initWithId:[obj objectForKey:@"Id"] caseNumber:[obj objectForKey:@"CaseNumber"] createdDate:createDate exhibitorName:shopName serviceType:serviceType applicationDate:createDate status:[obj objectForKey:@"Status"] BusinessCategory:businessCategoryName SubCategory:shopName nationality:[obj objectForKey:@"Nationality__c"] passportNumber:[obj objectForKey:@"Passport_Number__c"] visaNumber:[obj objectForKey:@"Visa_Number__c"] passportIssueDate:[obj objectForKey:@"Passport_Issue_Date__c"] fullName:[obj objectForKey:@"Full_Name__c"]]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self filterFinesTable];
        });
        
        NSLog(@"request:didLoadResponse:  Object: Case, #records: %lu", (unsigned long)self.finesArray.count);
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
    /*
    else if([selectQuery rangeOfString:@"FROM Pavilion_Fine_Type__c"].location != NSNotFound)
    {
        //isLoadingPavilionFines = NO;
        //TODO i guess this part is useless
        self.pavilionFineTypeArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            [self.pavilionFineTypeArray addObject:[[PavilionFineType alloc]
                                                   initPavilionFineTypeWithId:[obj objectForKey:@"Id"]
                                                   Name:[obj objectForKey:@"Name"]
                                                   FineAmount:(NSNumber*)[obj objectForKey:@"X1st_Fine_Amount__c"]
                                                   Department:[obj objectForKey:@"Department__c"]
                                                   ViolationClause:[obj objectForKey:@"Violation_Clause__c"]
                                                   Description:[obj objectForKey:@"Fine_Description__c"]
                                                   ShortDescription:[obj objectForKey:@"Violation_Short_Description__c"]]];
        }
        NSLog(@"request:didLoadResponse:  Object: Pavilion_Fine_Type__c, #records: %lu", (unsigned long)self.pavilionFineTypeArray.count);
    }
     */
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
    if([selectQuery rangeOfString:@"FROM Case"].location != NSNotFound)
    {
        //isLoadingFines = NO;
        //TODO isLoadingCases
    }
    else if ([selectQuery rangeOfString:@"FROM Account"].location != NSNotFound)
    {
        isLoadingBusinessCategories = NO;
    }
    else if ([selectQuery rangeOfString:@"FROM Shop__c"].location != NSNotFound)
    {
        isLoadingSubCategories = NO;
    }
    /*
    else if([selectQuery rangeOfString:@"FROM Pavilion_Fine_Type__c"].location != NSNotFound)
    {
        isLoadingPavilionFines = NO;
    }
     */
    else if([selectQuery rangeOfString:@"FROM Group"].location != NSNotFound)
    {
        isLoadingQueueId = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicatorSpinner];
        [HelperClass messageBox:@"An error occured while contacting the server." withTitle:@"Error"];
    });
}

#pragma UITableViewDatasource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return finesFilteredArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"CaseTableViewCell";
//    
//    CaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if(!cell) {
//        
//        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CaseTableViewCell" owner:self options:nil];
//        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
//        cell = [topLevelObjects objectAtIndex:0];
////        [tableView registerNib:[UINib nibWithNibName:@"CaseTableViewCell"  bundle:nil]forCellReuseIdentifier:CellIdentifier];
////        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
////        cell = [[CaseTableViewCell alloc] init];
//    }
    static NSString *CellIdentifier = @"CaseTableViewCell";
    
    CaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        //NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"CaseTableViewCell" owner:self options:nil];
        cell = [[CaseTableViewCell alloc] init];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        //cell = [topLevelObjects objectAtIndex:0];
    }

    
    //Fine *currentFine = [finesFilteredArray objectAtIndex:indexPath.row];
    //Case *currentCase = [[Case alloc] initWithId:<#(NSString *)#> caseNumber:<#(NSString *)#> createdDate:<#(NSDate *)#> exhibitorName:<#(NSString *)#> serviceType:(NSString *) applicationDate:<#(NSDate *)#> status:<#(NSString *)#>];
    //[cell setSelected:YES];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    Case *currentCase = [finesFilteredArray objectAtIndex:indexPath.row];
    [cell setCase:currentCase];
    
    return cell;
}

#pragma UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"xcode is fucked up.");
//        [[[UIAlertView alloc] initWithTitle:@"ay7aga§§" message:@"s5al aho" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
//    });
     [self.finesTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
     
     Case *selectedFine = [finesFilteredArray objectAtIndex:indexPath.row];
    
    CaseDetailsViewController *caseDetailsViewController = [[CaseDetailsViewController alloc] initWithCase:selectedFine];
    
    caseDetailsViewController.delegate = self;
    self.caseDetailspopover = [[UIPopoverController alloc] initWithContentViewController:caseDetailsViewController];
    self.caseDetailspopover.delegate = self;
    self.caseDetailspopover.popoverContentSize = caseDetailsViewController.view.frame.size;
    
    CGRect rect = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 1, 1);
    
    [self.caseDetailspopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
     
     
    /*
    [self.finesTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Fine *selectedFine = [finesFilteredArray objectAtIndex:indexPath.row];
    
    FineDetailsViewController *fineDetailsViewController = [[FineDetailsViewController alloc] initFineDetailsViewControllerWithFine:selectedFine FineQueueId:fineQueueId GR1QueueId:GR1QueueId];
    
    fineDetailsViewController.delegate = self;
    
    self.caseDetailspopover = [[UIPopoverController alloc] initWithContentViewController:fineDetailsViewController];
    self.caseDetailspopover.delegate = self;
    self.caseDetailspopover.popoverContentSize = fineDetailsViewController.view.frame.size;
    
    CGRect rect = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 1, 1);
    
    [self.caseDetailspopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
     */
}



#pragma CaseDetailsViewDelegate
- (void)didFinishUpdatingCase {
    [self.caseDetailspopover dismissPopoverAnimated:YES];
    //[self loadFines];
}

- (void)closeCaseDetailsPopup {
    [self.caseDetailspopover dismissPopoverAnimated:YES];
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
