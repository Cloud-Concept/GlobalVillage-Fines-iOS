//
//  ExistingCasesViewController.h
//  GVFines
//
//  Created by omer gawish on 9/8/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "PopoverPickerViewController.h"
#import "SFPickListViewController.h"
#import "CaseDetailsViewController.h"
#import "FineDetailsViewController.h"

@class BusinessCategory;
@class SubCategory;
//@class Case;

@interface ExistingCasesViewController : UIViewController <PopoverPickerViewControllerDelegate, UIPopoverControllerDelegate,UITableViewDataSource, UITableViewDelegate, SFRestDelegate, SFPickListViewDelegate, CaseDetailsViewDelegate>
{
    BusinessCategory *selectedBusinessCategoryObject;
    SubCategory *selectedSubCategoryObject;
    
    NSInteger selectedBusinessCategoryIndex;
    NSInteger selectedSubCategoryIndex;
    
    NSString *fineQueueId;
    NSString *GR1QueueId;
    
    BOOL isLoadingBusinessCategories;
    BOOL isLoadingSubCategories;
    BOOL isLoadingQueueId;
    
    BOOL showAllFines;
    
    NSString *sortByClause;
    
    NSMutableArray *pavilionFineDepartmentStringArray;
    NSMutableArray *pavilionFineTypeFilteredArray;
    
    NSMutableArray *finesFilteredArray;
}
@property (weak, nonatomic) IBOutlet UITextField *caseNumberTextField;


@property (strong, nonatomic) IBOutlet UITableView *finesTableView;
@property (strong, nonatomic) IBOutlet UIButton *businessCategoryButton;
@property (strong, nonatomic) IBOutlet UIButton *subCategoryButton;

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
@property (strong, nonatomic) UIPopoverController *caseDetailspopover;

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
