//
//  CaseTableViewCell.h
//  GVFines
//
//  Created by omer gawish on 9/9/15.
//  Copyright (c) 2015 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Case;
@interface CaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *caseNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *exhibitorName;
//@property (weak, nonatomic) IBOutlet UILabel *caseIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceType;
@property (weak, nonatomic) IBOutlet UILabel *applicationDate;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;

- (void)setCase:(Case *)someCase;
@end
