//
//  Fine.m
//  GVFines
//
//  Created by Mina Zaklama on 10/15/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "Fine.h"

@implementation Fine

- (id)initFineWithId:(NSString*)fineId CaseNumber:(NSString*)fineCaseNumber BusinessCategory:(NSString*)fineBusinessCategory SubCategory:(NSString*)fineSubCategory ViolationClause:(NSString*)fineViolationClause ViolationDescription:(NSString*)fineViolationDescription ViolationShortDescription:(NSString*)fineViolationShortDescription FineDepartment:(NSString*)fineDepartment X1stFineAmount:(NSNumber*)fine1stAmount X2ndFineAmount:(NSNumber*)fine2ndAmount Comments:(NSString*)fineComments Status:(NSString*)fineStatus CreatedBy:(NSString*)fineCreatedBy CreatedDate:(NSString*)fineCreatedDate FineLastStatusUpdateDate:(NSString*)fineLastStatusUpdateDate Issued:(BOOL)issued shopId:(NSString *)shopId PavilionFineType:(NSString *)pavilionFineType Stage:(NSString *)fineStage BusinessCategoryId:(NSString *)businessCategoryId {
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = fineId;
    self.CaseNumber = fineCaseNumber;
    self.BusinessCategory = fineBusinessCategory;
    self.SubCategory = fineSubCategory;
    self.ViolationClause = fineViolationClause;
    self.ViolationDescription = fineViolationDescription;
    self.FineDepartment = fineDepartment;
    self.X1stFineAmount = fine1stAmount;
    self.X2ndFineAmount = fine2ndAmount;
    self.Status = fineStatus;
    self.CreatedBy = fineCreatedBy;
    self.shopId = shopId;
    self.pavilionFineType = pavilionFineType;
    self.fineStage = fineStage;
    self.BusinessCategoryId = businessCategoryId;
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [format setTimeZone:[NSTimeZone defaultTimeZone]];

    //fineCreatedDate = [fineCreatedDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    //fineCreatedDate = [fineCreatedDate substringToIndex:[fineCreatedDate rangeOfString:@"."].location];
    self.CreatedDate = [format dateFromString:fineCreatedDate];
    
    if(![fineLastStatusUpdateDate isKindOfClass:[NSNull class]])
    {
        //fineLastStatusUpdateDate = [fineLastStatusUpdateDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        //fineLastStatusUpdateDate = [fineLastStatusUpdateDate substringToIndex:[fineLastStatusUpdateDate rangeOfString:@"."].location];
        self.FineLastStatusUpdateDate = [format dateFromString:fineLastStatusUpdateDate];
    }
    else
        self.FineLastStatusUpdateDate = [NSDate date];
    
    if(![fineComments isKindOfClass:[NSNull class]])
        self.Comments = fineComments;
    else
        self.Comments = @"";
    
    if(![fineViolationShortDescription isKindOfClass:[NSNull class]])
        self.ViolationShortDescription = fineViolationShortDescription;
    else
        self.ViolationShortDescription = @"";
    
    self.issued = issued;
    
    return self;
}

- (BOOL)isUrgent {
    NSInteger timeIntervalSinceLastUpdated = [self.FineLastStatusUpdateDate timeIntervalSinceNow] / 3600;
    timeIntervalSinceLastUpdated *= -1; //This is because the CreatedDate will always be in the past.
    
    return timeIntervalSinceLastUpdated >= 96;
}

+ (id)sortFineByBusinessCategoryComparator {
    return ^(Fine* fine1, Fine* fine2){
        NSComparisonResult compareByUrgent = [Fine compareFineByIsUrgent:fine1 SecondFine:fine2];
        if (compareByUrgent == NSOrderedSame)
            return [fine1.BusinessCategory caseInsensitiveCompare:fine2.BusinessCategory];
        else
            return compareByUrgent;
    };
}

+ (id)sortFineBySubCategoryComparator {
    return ^(Fine* fine1, Fine* fine2){
        NSComparisonResult compareByUrgent = [Fine compareFineByIsUrgent:fine1 SecondFine:fine2];
        if (compareByUrgent == NSOrderedSame)
            return [fine1.SubCategory caseInsensitiveCompare:fine2.SubCategory];
        else
            return compareByUrgent;
    };
}

+ (id)sortFineByViolationClauseComparator {
    return ^(Fine* fine1, Fine* fine2){
        NSComparisonResult compareByUrgent = [Fine compareFineByIsUrgent:fine1 SecondFine:fine2];
        if (compareByUrgent == NSOrderedSame)
            return [fine1.ViolationClause caseInsensitiveCompare:fine2.ViolationClause];
        else
            return compareByUrgent;
    };
}

+ (id)sortFineByDepartmentComparator {
    return ^(Fine* fine1, Fine* fine2){
        NSComparisonResult compareByUrgent = [Fine compareFineByIsUrgent:fine1 SecondFine:fine2];
        if (compareByUrgent == NSOrderedSame)
            return [fine1.FineDepartment caseInsensitiveCompare:fine2.FineDepartment];
        else
            return compareByUrgent;
    };
}

+ (id)sortFineByStatusComparator{
    return ^(Fine* fine1, Fine* fine2){
        NSComparisonResult compareByUrgent = [Fine compareFineByIsUrgent:fine1 SecondFine:fine2];
        if (compareByUrgent == NSOrderedSame)
            return [fine1.Status caseInsensitiveCompare:fine2.Status];
        else
            return compareByUrgent;
    };
    
}

+ (id)sortFineByCreatedDateComparator {
    return ^(Fine* fine1, Fine* fine2){
        NSComparisonResult compareByUrgent = [Fine compareFineByIsUrgent:fine1 SecondFine:fine2];
        if (compareByUrgent == NSOrderedSame)
            return [fine2.CreatedDate compare:fine1.CreatedDate];
        else
            return compareByUrgent;
    };
}

+ (NSComparisonResult)compareFineByIsUrgent:(Fine*) fine1 SecondFine:(Fine*)fine2 {
    NSComparisonResult comparisionResult;
    if (([fine1 isUrgent] && [fine2 isUrgent]) ||
        (![fine1 isUrgent] && ![fine2 isUrgent])) {
        comparisionResult = NSOrderedSame;
    }
    else if ([fine1 isUrgent] && ![fine2 isUrgent]) {
        comparisionResult = NSOrderedAscending;
    }
    else {
        comparisionResult = NSOrderedDescending;
    }
    
    return comparisionResult;
}

@end
