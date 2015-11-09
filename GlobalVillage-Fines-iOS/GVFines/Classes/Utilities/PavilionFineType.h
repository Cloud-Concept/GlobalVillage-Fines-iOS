//
//  PavilionFineType.h
//  GVFines
//
//  Created by Mina Zaklama on 10/13/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PavilionFineType : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Name;
@property (strong, nonatomic) NSNumber *X1stFineAmount;
@property (strong, nonatomic) NSString *Department;
@property (strong, nonatomic) NSString *ViolationClause;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) NSString *ShortDescription;
@property (nonatomic) BOOL WarningIncluded;

-(id)initPavilionFineTypeWithId:(NSString*)fineId Name:(NSString*)fineName FineAmount:(NSNumber*)fineAmount Department:(NSString*)fineDepartment ViolationClause:(NSString*)fineViolationClause Description:(NSString*)fineDescription ShortDescription:(NSString*)fineShortDescription WarningIncluded:(BOOL)warning;
-(id)initPavilionFineTypeWithId:(NSString*)fineId Name:(NSString*)fineName FineAmount:(NSNumber*)fineAmount Department:(NSString*)fineDepartment ViolationClause:(NSString*)fineViolationClause Description:(NSString*)fineDescription ShortDescription:(NSString*)fineShortDescription;

@end
