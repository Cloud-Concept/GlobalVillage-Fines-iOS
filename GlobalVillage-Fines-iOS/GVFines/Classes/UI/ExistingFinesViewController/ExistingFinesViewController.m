//
//  ExistingFinesViewController.m
//  GVFines
//
//  Created by Mina Zaklama on 10/14/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "ExistingFinesViewController.h"
#import "SFRestRequest.h"
#import "FineTableViewCell.h"
#import "Fine.h"
#import "BusinessCategory.h"
#import "SubCategory.h"
#import "PavilionFineType.h"
#import "HelperClass.h"

@interface ExistingFinesViewController ()

@end

@implementation ExistingFinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    isLoadingBusinessCategories = NO;
    isLoadingSubCategories = NO;
    isLoadingPavilionFines = NO;
    isLoadingFines = NO;
    isLoadingQueueId = NO;
    
    showAllFines = NO;
    
    sortByClause = @"Date";
    
    selectedBusinessCategoryObject = nil;
    selectedSubCategoryObject = nil;
    selectedPavilionFineDepartment = @"";
    selectedPavilionFineObject = nil;
    
    fineQueueId = @"";
    GR1QueueId = @"";
    
    selectedBusinessCategoryIndex = -1;
    selectedSubCategoryIndex = -1;
    selectedPavilionFineDepartmentIndex = -1;
    selectedPavilionFineDescriptionIndex = -1;
    
    [self loadBusinessCategories];
    [self loadPavilionFines];
    [self loadFines];
    [self loadPavilionQueueId];
    
    [HelperClass createViewWithShadows:self.filterView];
    [HelperClass createViewWithShadows:self.infringementsView];
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

- (IBAction)departmentButtonClicked:(id)sender {
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

- (IBAction)resetButtonClicked:(id)sender {
    [self resetAllFields];
    [self loadFines];
}

- (IBAction)filterButtonClicked:(id)sender {
    [self filterFinesTable];
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
    NSArray *stringArray = [NSArray arrayWithObjects:@"Business Category", @"Sub Category", @"Violation Clause", @"Department", @"Status", @"Date", nil];
    
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
    
    isLoadingFines = YES;
    //SELECT Id, CaseNumber, Account.Name, Shop__r.Id,Shop__r.Name,Fine_Stage__c,issued__c, Violation_Clause__c,Pavilion_Fine_Type__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c,Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE (RecordType.DeveloperName = 'Pavilion_Fine' OR RecordType.DeveloperName = 'Re_Issue_Fine') AND Issued__c != true AND Season__r.Name='2015-16'
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, CaseNumber, Account.Name, Shop__r.Id,Shop__r.Name,Fine_Stage__c,issued__c, Violation_Clause__c,Pavilion_Fine_Type__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c, X2nd_Fine_Amount__c,Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c,Season__r.Name FROM Case WHERE (RecordType.DeveloperName = 'Pavilion_Fine' OR RecordType.DeveloperName = 'Re_Issue_Fine') AND Issued__c != true AND Season__r.Name='2015-16'"];
    //(RecordType.DeveloperName = 'Pavilion_Fine' OR
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

- (void)loadPavilionFines {
    [self initializeAndStartActivityIndicatorSpinner];
    
    isLoadingPavilionFines = YES;
    selectedPavilionFineDepartment = @"";
    selectedPavilionFineObject = nil;
    selectedPavilionFineDepartmentIndex = -1;
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name, X1st_Fine_Amount__c, Department__c, Violation_Clause__c, Fine_Description__c, Violation_Short_Description__c FROM Pavilion_Fine_Type__c"];
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
}

- (void)stopActivityIndicatorSpinner {
    if(isLoadingBusinessCategories || isLoadingSubCategories || isLoadingPavilionFines || isLoadingFines || isLoadingQueueId)
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

- (void)resetAllFields {
    [self resetBusinessCategoryButton];
    [self resetSubCategoryButton];
    [self resetPavilionFineDepartmentButton];
    [self resetPavilionFineDescriptionButton];
    
    [self filterFinesTable];
}

- (void)filterFinesTable {
    NSMutableString *predicateString = [[NSMutableString alloc] init];
    
    [predicateString appendFormat:@"BusinessCategory LIKE '%@' ", selectedBusinessCategoryObject ? selectedBusinessCategoryObject.Name : @"*"];
    
    [predicateString appendFormat:@"AND SubCategory LIKE '%@' ", selectedSubCategoryObject ? selectedSubCategoryObject.Name : @"*"];
    
    [predicateString appendFormat:@"AND FineDepartment LIKE '%@'", [selectedPavilionFineDepartment isEqualToString:@""] ? @"*" : selectedPavilionFineDepartment];
    
    [predicateString appendFormat:@"AND ViolationClause LIKE '%@' ", selectedPavilionFineObject ? selectedPavilionFineObject.ViolationClause : @"*"];
    
    if(!showAllFines)
        [predicateString appendString:@"AND NOT(Status IN {\"Rectified\", \"Fine Rejected\", \"3rd Fine Approved\"})"];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString];
   finesFilteredArray = [NSMutableArray arrayWithArray:[self.finesArray filteredArrayUsingPredicate:predicate]];
    
    [self sortFilteredFinesArray];
    
    [self.finesTableView reloadData];
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
    else if([self.pavilionFineDepartmentPickerPopover isPopoverVisible])
    {
        [self.pavilionFineDepartmentPickerPopover dismissPopoverAnimated:YES];
        if(index > -1) {
            selectedPavilionFineDepartment = [pavilionFineDepartmentStringArray objectAtIndex:index];
            selectedPavilionFineDepartmentIndex = index;
            [self.departmentButton setTitle:selectedPavilionFineDepartment forState:UIControlStateNormal];
            
            [self resetPavilionFineDescriptionButton];
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
        }
    }
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
        isLoadingFines = NO;
        self.finesArray = [[NSMutableArray alloc] init];
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
            
            [self.finesArray addObject:[[Fine alloc] initFineWithId:[obj objectForKey:@"Id"]
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
                                                   PavilionFineType:[obj objectForKey:@"Pavilion_Fine_Type__c"] Stage:[obj objectForKey:@"Fine_Stage__c"]]];
            NSLog(@"Id: %@ --- shope:%@ ---- pavilion:%@ ---- status:%@",[obj objectForKey:@"Id"],shopName,[obj objectForKey:@"Pavilion_Fine_Type__c"],[obj objectForKey:@"Status"]);
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
    else if([selectQuery rangeOfString:@"FROM Pavilion_Fine_Type__c"].location != NSNotFound)
    {
        isLoadingPavilionFines = NO;
        self.pavilionFineTypeArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in [jsonResponse objectForKey:@"records"]) {
            [self.pavilionFineTypeArray addObject:[[PavilionFineType alloc]
                                                   initPavilionFineTypeWithId:[obj objectForKey:@"Id"]
                                                   Name:[obj objectForKey:@"Name"]
                                                   FineAmount:(NSNumber*)[obj objectForKey:@"Fine_Amount__c"]
                                                   Department:[obj objectForKey:@"Department__c"]
                                                   ViolationClause:[obj objectForKey:@"Violation_Clause__c"]
                                                   Description:[obj objectForKey:@"Fine_Description__c"]
                                                   ShortDescription:[obj objectForKey:@"Violation_Short_Description__c"]]];
            
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
    if([selectQuery rangeOfString:@"FROM Case"].location != NSNotFound)
    {
        isLoadingFines = NO;
    }
    else if ([selectQuery rangeOfString:@"FROM Account"].location != NSNotFound)
    {
        isLoadingBusinessCategories = NO;
    }
    else if ([selectQuery rangeOfString:@"FROM Shop__c"].location != NSNotFound)
    {
        isLoadingSubCategories = NO;
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
    static NSString *CellIdentifier = @"FineTableViewCell";
    
    FineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"FineTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    Fine *currentFine = [finesFilteredArray objectAtIndex:indexPath.row];
    
    [cell setFine:currentFine];
    
    return cell;
}

#pragma UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.finesTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Fine *selectedFine = [finesFilteredArray objectAtIndex:indexPath.row];
    BusinessCategory *category;
    for (BusinessCategory *any in self.businessCategoriesArray) {
        if ([any.Name isEqualToString:selectedFine.BusinessCategory]) {
            category = any;
        }
    }
    SubCategory *subCategory;
    for (SubCategory *any in self.subCategoriesArray) {
        if ([any.Name isEqualToString:selectedFine.SubCategory]) {
            subCategory = any;
        }
    }
    
    FineDetailsViewController *fineDetailsViewController = [[FineDetailsViewController alloc] initFineDetailsViewControllerWithFine:selectedFine FineQueueId:fineQueueId GR1QueueId:GR1QueueId BusinessCategory:category SubCategory:subCategory];
    
    fineDetailsViewController.delegate = self;
    
    self.fineDetailspopover = [[UIPopoverController alloc] initWithContentViewController:fineDetailsViewController];
    self.fineDetailspopover.delegate = self;
    self.fineDetailspopover.popoverContentSize = fineDetailsViewController.view.frame.size;
    
    CGRect rect = CGRectMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 1, 1);
    
    [self.fineDetailspopover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
}

#pragma FineDetailsViewDelegate
- (void)didFinishUpdatingFine {
    [self.fineDetailspopover dismissPopoverAnimated:YES];
    [self loadFines];
}

- (void)closeFineDetailsPopup {
    [self.fineDetailspopover dismissPopoverAnimated:YES];
}

@end
