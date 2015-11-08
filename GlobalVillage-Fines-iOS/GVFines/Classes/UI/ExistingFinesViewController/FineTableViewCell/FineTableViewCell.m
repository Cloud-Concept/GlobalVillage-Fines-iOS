//
//  FineTableViewCell.m
//  GVFines
//
//  Created by Mina Zaklama on 10/14/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "FineTableViewCell.h"
#import "Fine.h"
#import "HelperClass.h"

@implementation FineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFine:(Fine*)fine {
    fineObject = fine;
    if (![fineObject.ViolationClause isKindOfClass:[NSNull class]]) {
        [self.violationClauseLabel setText:fineObject.ViolationClause];
    }
    if (![fineObject.ViolationClause isKindOfClass:[NSNull class]]
        && ![fineObject.SubCategory isKindOfClass:[NSNull class]]) {
        [self.categoryLabel setText:[NSString stringWithFormat:@"%@ - %@", fineObject.BusinessCategory, fineObject.SubCategory]];
    }
    if (![fineObject.ViolationShortDescription isKindOfClass:[NSNull class]]) {
        [self.shortDescriptionLabel setText:fineObject.ViolationShortDescription];

    }
    if (![fineObject.Comments isKindOfClass:[NSNull class]]) {
        [self.commentsLabel setText:fineObject.Comments];
    }
    if (![fineObject.Status isKindOfClass:[NSNull class]]) {
        [self.statusLabel setText:fineObject.Status];
    }
    if (![fineObject.CaseNumber isKindOfClass:[NSNull class]]) {
        [self.fineNumberLabel setText:fineObject.CaseNumber];
    }
    
    if ([fineObject isUrgent] &&
        ![fineObject.Status isEqualToString:@"Rectified"] &&
        ![fineObject.Status isEqualToString:@"Fine Rejected"])
    {
        [self.importantIconImageView setHidden:NO];
    }
    else {
        [self.importantIconImageView setHidden:YES];
    }
    
    [HelperClass setStatusBackground:fineObject ImageView:self.statusImageView];
}

- (void)setStatusBackground {
    if([fineObject.Status isEqualToString: @"Rectified"]) {
        [self.statusImageView setImage:[UIImage imageNamed:@"fineStatusGreen"]];
    }
    else if ([fineObject.Status isEqualToString:@"Fine Rejected"]) {
        [self.statusImageView setImage:[UIImage imageNamed:@"fineStatusRed"]];
    }
    else {
        [self.statusImageView setImage:[UIImage imageNamed:@"fineStatusYellow"]];
    }
}

@end
