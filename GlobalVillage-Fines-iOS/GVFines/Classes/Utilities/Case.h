//
//  Case.h
//  GVFines
//
//  Created by omer gawish on 9/9/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

//SELECT Id, CaseNumber, Account.Name,RecordType.DeveloperName, Shop__r.Name,Full_Name__c, Gender__c,Mobile_Number__c,Date_of_Birth__c,Nationality__c,Passport_Number__c, Visa_Number__c,Passport_Issue_Date__c,  Violation_Clause__c, Violation_Description__c, Violation_Short_Description__c, Fine_Department__c, X1st_Fine_Amount__c,Rejection_Reason__c,lastModifiedBy, X2nd_Fine_Amount__c, Comments__c, Status, CreatedBy.Name, CreatedDate, Fine_Last_Status_Update_Date__c FROM Case WHERE (NOT RecordType.DeveloperName LIKE '%Fine')"

#import <Foundation/Foundation.h>
#import "Fine.h"
@interface Case : Fine
//@property (strong, nonatomic) NSString *Id;
//@property (strong, nonatomic) NSString *CaseNumber;
//@property (strong, nonatomic) NSString *CreatedBy;
//@property (strong, nonatomic) NSDate *CreatedDate;
@property (strong, nonatomic) NSString *caseNumber;
@property (strong, nonatomic) NSString *exhibitorName;
@property (strong, nonatomic) NSString *serviceType;
@property (strong, nonatomic) NSDate *applicationDate;
@property (strong, nonatomic) NSString *nationality;
@property (strong, nonatomic) NSString *passportNumber;
@property (strong, nonatomic) NSString *visaNumber;
@property (strong, nonatomic) NSDate *passportIssueDate;
@property (strong,nonatomic) NSString *fullName;
@property (strong,nonatomic) NSString* rejectionReason;
@property (strong, nonatomic) NSString *lastModified;
//@property (strong, nonatomic) NSString *Status;
//@property (strong, nonatomic) NSString *BusinessCategory;
//@property (strong, nonatomic) NSString *SubCategory;



-(instancetype) initWithId:(NSString *)caseId caseNumber:(NSString *)number createdDate:(NSDate *)createdDate exhibitorName:(NSString *)exhibitorName serviceType:(NSString *)serviceType applicationDate:(NSDate *)applicationDate status:(NSString *)status BusinessCategory:(NSString *)BusinessCategory SubCategory:(NSString *) SubCategory nationality:(NSString *)nationality passportNumber:(NSString *)passportNumber visaNumber:(NSString *)visaNumber passportIssueDate:(NSString *)passportIssueDate fullName:(NSString *)fullName rejectionReason:(NSString *)rejectionReason lastModified:(NSString *)lastModified;
@end
