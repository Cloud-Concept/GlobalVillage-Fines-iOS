//
//  MainViewController.h
//  GVFines
//
//  Created by Mina Zaklama on 9/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESCPOSPrinter.h"
#import "EABluetoothPort.h"

@class NewFinesTabViewController;
@class ExistingFinesViewController;
@class ExistingCasesViewController;

@interface MainViewController : UIViewController
{
    NewFinesTabViewController *newFinesTabViewController;
    ExistingFinesViewController *existingFinesViewController;
    ExistingCasesViewController *existingCasesViewController;
    ESCPOSPrinter *escp;
}

@property (strong, nonatomic) IBOutlet UIButton *finesNewButton;
@property (strong, nonatomic) IBOutlet UIButton *finesOldButton;
@property (weak, nonatomic) IBOutlet UIButton *casesOldButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction)LogoutButtonClicked:(id)sender;
- (IBAction)OldFinesButtonClicked:(id)sender;
- (IBAction)NewFineButtonClicked:(id)sender;
- (IBAction)OldCasesButtonClicked:(id)sender;

@end
