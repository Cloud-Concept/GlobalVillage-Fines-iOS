//
//  FineTableViewCell.h
//  GVFines
//
//  Created by Mina Zaklama on 10/14/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Fine;

@interface FineTableViewCell : UITableViewCell
{
    Fine *fineObject;
}

@property (strong, nonatomic) IBOutlet UILabel *violationClauseLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel *shortDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *importantIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *fineNumberLabel;

- (void)setFine:(Fine*)fine;

@end
