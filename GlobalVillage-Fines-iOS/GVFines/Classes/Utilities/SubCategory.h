//
//  SubCategory.h
//  GVFines
//
//  Created by Mina Zaklama on 10/13/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubCategory : NSObject

@property (strong, nonatomic) NSString *Id;
@property (strong, nonatomic) NSString *Name;

-(id)initSubCategoryWithId:(NSString*)subCategoryId AndName:(NSString*)subCategoryName;

@end
