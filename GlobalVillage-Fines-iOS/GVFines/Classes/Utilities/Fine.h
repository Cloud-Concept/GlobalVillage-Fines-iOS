//
//  Fine.h
//  GVFines
//
//  Created by Mina Zaklama on 10/15/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fine : NSObject

//SELECT Id, CaseNumber, Account.Name, Shop__r.Name, Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Comments__c, Status, CreatedBy.Name, CreatedDate FROM Case WHERE RecordType.DeveloperName = 'Pavilion_Fine'

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *CaseNumber;
@property (strong, nonatomic) NSString *BusinessCategory;
@property (strong, nonatomic) NSString *SubCategory;
@property (strong, nonatomic) NSString *ViolationClause;
@property (strong, nonatomic) NSString *ViolationDescription;
@property (strong, nonatomic) NSString *ViolationShortDescription;
@property (strong, nonatomic) NSString *FineDepartment;
@property (strong, nonatomic) NSNumber *X1stFineAmount;
@property (strong, nonatomic) NSNumber *X2ndFineAmount;
@property (strong, nonatomic) NSString *Comments;
@property (strong, nonatomic) NSString *Status;
@property (strong, nonatomic) NSString *CreatedBy;
@property (strong, nonatomic) NSDate *CreatedDate;
@property (strong, nonatomic) NSDate *FineLastStatusUpdateDate;
@property (nonatomic) BOOL issued;
@property (strong,nonatomic) NSString *shopId;
@property (strong,nonatomic) NSString *pavilionFineType;
@property (strong,nonatomic) NSString *fineStage;

- (id)initFineWithId:(NSString*)fineId CaseNumber:(NSString*)fineCaseNumber BusinessCategory:(NSString*)fineBusinessCategory SubCategory:(NSString*)fineSubCategory ViolationClause:(NSString*)fineViolationClause ViolationDescription:(NSString*)fineViolationDescription ViolationShortDescription:(NSString*)fineViolationShortDescription FineDepartment:(NSString*)fineDepartment X1stFineAmount:(NSNumber*)fine1stAmount X2ndFineAmount:(NSNumber*)fine2ndAmount Comments:(NSString*)fineComments Status:(NSString*)fineStatus CreatedBy:(NSString*)fineCreatedBy CreatedDate:(NSString*)fineCreatedDate FineLastStatusUpdateDate:(NSString*)fineLastStatusUpdateDate Issued:(BOOL)issued shopId:(NSString *)shopId PavilionFineType:(NSString *)pavilionFineType Stage:(NSString *)fineStage;

- (BOOL)isUrgent;

+ (id)sortFineByBusinessCategoryComparator;
+ (id)sortFineBySubCategoryComparator;
+ (id)sortFineByViolationClauseComparator;
+ (id)sortFineByDepartmentComparator;
+ (id)sortFineByStatusComparator;
+ (id)sortFineByCreatedDateComparator;

@end
