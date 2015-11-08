//
//  SubCategory.m
//  GVFines
//
//  Created by Mina Zaklama on 10/13/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "SubCategory.h"

@implementation SubCategory

-(id)initSubCategoryWithId:(NSString*)subCategoryId AndName:(NSString*)subCategoryName {
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = subCategoryId;
    self.Name = subCategoryName;
    
    return self;
}


@end
