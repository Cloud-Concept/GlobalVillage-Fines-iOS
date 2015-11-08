//
//  Account.m
//  GVFines
//
//  Created by Mina Zaklama on 10/13/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "BusinessCategory.h"

@implementation BusinessCategory

-(id)initBusinessCategoryWithId:(NSString*)businessCategoryid AndName:(NSString*)businessCategoryName {
    
    if(!(self = [super init]))
        return nil;
    
    self.Id = businessCategoryid;
    self.Name = businessCategoryName;
    
    return self;
}

@end
