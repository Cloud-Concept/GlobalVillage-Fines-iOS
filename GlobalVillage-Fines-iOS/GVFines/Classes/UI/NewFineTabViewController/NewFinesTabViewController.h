//
//  NewFinesTabViewController.h
//  GVFines
//
//  Created by Mina Zaklama on 9/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewFinesView;

@interface NewFinesTabViewController : UIViewController

@property (strong, nonatomic) IBOutlet NewFinesView *finesNewView;

@property (strong, nonatomic) UIViewController *mainViewController;

@end
