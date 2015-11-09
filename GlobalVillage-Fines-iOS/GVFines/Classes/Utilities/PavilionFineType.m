//
//  PavilionFineType.m
//  GVFines
//
//  Created by Mina Zaklama on 10/13/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "PavilionFineType.h"

@implementation PavilionFineType

-(id)initPavilionFineTypeWithId:(NSString*)fineId Name:(NSString*)fineName FineAmount:(NSNumber*)fineAmount Department:(NSString*)fineDepartment ViolationClause:(NSString*)fineViolationClause Description:(NSString*)fineDescription ShortDescription:(NSString*)fineShortDescription{
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = fineId;
    self.Name = fineName;
    self.X1stFineAmount = fineAmount;
    self.Department = fineDepartment;
    self.ViolationClause = fineViolationClause;
    self.Description = fineDescription;
    if(![fineShortDescription isKindOfClass:[NSNull class]])
        self.ShortDescription = fineShortDescription;
    else
        self.ShortDescription = @"";
    
    return self;
}

-(id)initPavilionFineTypeWithId:(NSString*)fineId Name:(NSString*)fineName FineAmount:(NSNumber*)fineAmount Department:(NSString*)fineDepartment ViolationClause:(NSString*)fineViolationClause Description:(NSString*)fineDescription ShortDescription:(NSString*)fineShortDescription WarningIncluded:(BOOL)warning{
    
    self = [self initPavilionFineTypeWithId:fineId Name:fineName FineAmount:fineAmount Department:fineDepartment ViolationClause:fineViolationClause Description:fineDescription ShortDescription:fineShortDescription];
    self.WarningIncluded = warning;
    return self;
}

@end
