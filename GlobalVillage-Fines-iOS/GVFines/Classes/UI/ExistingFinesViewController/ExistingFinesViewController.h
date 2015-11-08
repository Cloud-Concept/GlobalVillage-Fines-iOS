//
//  ExistingFinesViewController.h
//  GVFines
//
//  Created by Mina Zaklama on 10/14/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "PopoverPickerViewController.h"
#import "SFPickListViewController.h"
#import "FineDetailsViewController.h"

@class BusinessCategory;
@class SubCategory;
@class PavilionFineType;

/*
 SELECT Id, Account.Name, Shop__r.Name, Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Comments__c, Status, CreatedBy.Name, CreatedDate FROM Case WHERE RecordType.DeveloperName = 'Pavilion_Fine'
*/
@interface ExistingFinesViewController : UIViewController <PopoverPickerViewControllerDelegate, UIPopoverControllerDelegate,UITableViewDataSource, UITableViewDelegate, SFRestDelegate, SFPickListViewDelegate, FineDetailsViewDelegate>
{
    BusinessCategory *selectedBusinessCategoryObject;
    SubCategory *selectedSubCategoryObject;
    NSString *selectedPavilionFineDepartment;
    PavilionFineType *selectedPavilionFineObject;
    
    NSInteger selectedBusinessCategoryIndex;
    NSInteger selectedSubCategoryIndex;
    NSInteger selectedPavilionFineDepartmentIndex;
    NSInteger selectedPavilionFineDescriptionIndex;
    
    NSString *fineQueueId;
    NSString *GR1QueueId;
    
    BOOL isLoadingBusinessCategories;
    BOOL isLoadingSubCategories;
    BOOL isLoadingPavilionFines;
    BOOL isLoadingFines;
    BOOL isLoadingQueueId;
    
    BOOL showAllFines;
    
    NSString *sortByClause;
    
    NSMutableArray *pavilionFineDepartmentStringArray;
    NSMutableArray *pavilionFineTypeFilteredArray;
    
    NSMutableArray *finesFilteredArray;
}

@property (strong, nonatomic) IBOutlet UITableView *finesTableView;
@property (strong, nonatomic) IBOutlet UIButton *businessCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *subCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *departmentButton;
@property (strong, nonatomic) IBOutlet UIButton *fineButton;
@property (strong, nonatomic) IBOutlet UIButton *showCriteriaButton;
@property (strong, nonatomic) IBOutlet UIView *loadingView;
@property (strong, nonatomic) IBOutlet UIView *filterView;
@property (strong, nonatomic) IBOutlet UIView *infringementsView;

@property (strong, nonatomic) UIPopoverController *businessCategoryPickerPopover;
@property (strong, nonatomic) UIPopoverController *subCategoryPickerPopover;
@property (strong, nonatomic) UIPopoverController *pavilionFineDepartmentPickerPopover;
@property (strong, nonatomic) UIPopoverController *pavilionFineDescriptionPickerPopover;
@property (strong, nonatomic) UIPopoverController *showCriteriaPopover;
@property (strong, nonatomic) UIPopoverController *sortByPopover;
@property (strong, nonatomic) UIPopoverController *fineDetailspopover;

@property (strong, nonatomic) NSMutableArray *businessCategoriesArray;
@property (strong, nonatomic) NSMutableArray *subCategoriesArray;
@property (strong, nonatomic) NSMutableArray *pavilionFineTypeArray;
@property (strong, nonatomic) NSMutableArray *finesArray;


- (IBAction)businessCategoryButtonClicked:(id)sender;
- (IBAction)subCategoryButtonClicked:(id)sender;
- (IBAction)departmentButtonClicked:(id)sender;
- (IBAction)fineButtonClicked:(id)sender;
- (IBAction)resetButtonClicked:(id)sender;
- (IBAction)filterButtonClicked:(id)sender;
- (IBAction)showCriteriaButtonClicked:(id)sender;
- (IBAction)sortByButtonClicked:(id)sender;

@end
