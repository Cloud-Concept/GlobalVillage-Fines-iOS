//
//  Case.m
//  GVFines
//
//  Created by omer gawish on 9/9/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import "Case.h"

@implementation Case

-(instancetype) initWithId:(NSString *)caseId caseNumber:(NSString *)number createdDate:(NSDate *)createdDate exhibitorName:(NSString *)exhibitorName serviceType:(NSString *)serviceType applicationDate:(NSDate *)applicationDate status:(NSString *)status BusinessCategory:(NSString *)BusinessCategory SubCategory:(NSString *) SubCategory nationality:(NSString *)nationality passportNumber:(NSString *)passportNumber visaNumber:(NSString *)visaNumber passportIssueDate:(NSString *)passportIssueDate fullName:(NSString *)fullName
{
    if(!(self = [super init]))
        return nil;
    
    self.Id = caseId;
    self.caseNumber = number;
    self.CreatedDate = createdDate;
    self.exhibitorName = exhibitorName;
    self.serviceType = serviceType;
    self.applicationDate = applicationDate;
    self.Status = status;
    self.BusinessCategory = BusinessCategory;
    self.SubCategory = SubCategory;
    self.fullName = fullName;
    return self;
}

@end
