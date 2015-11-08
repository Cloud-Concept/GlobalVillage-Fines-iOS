//
//  MainViewController.m
//  GVFines
//
//  Created by Mina Zaklama on 9/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "MainViewController.h"
#import "NewFinesTabViewController.h"
#import "ExistingFinesViewController.h"
#import "ExistingCasesViewController.h"
#import "HelperClass.h"
#import <SalesforceSDKCore/SFAuthenticationManager.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self centerImageAndTitle:self.finesNewButton];
    [self centerImageAndTitle:self.finesOldButton];
    [self centerImageAndTitle:self.logoutButton];
    [self centerImageAndTitle:self.casesOldButton];
    
    [self activateNewFineTab];
    
    [HelperClass initPrinter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusCheckReceived:) name:EADSessionDataReceivedNotification object:nil];
    [[EAAccessoryManager sharedAccessoryManager] registerForLocalNotifications];
}

- (void)didReceiveMemoryWarning {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)statusCheckReceived:(NSNotification *) notification {
    [HelperClass statusCheckReceived:notification];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)removeContainerViewSubViews {
    for (UIView* subview in self.containerView.subviews)
    {
        [subview removeFromSuperview];
    }
}

- (void)activateNewFineTab {
    [self removeContainerViewSubViews];
    newFinesTabViewController = nil;
    existingFinesViewController = nil;
    newFinesTabViewController = [[NewFinesTabViewController alloc] initWithNibName:nil bundle:nil];
    newFinesTabViewController.mainViewController = self;
    [self.containerView addSubview:newFinesTabViewController.view];
    [self.finesNewButton setSelected:YES];
    [self.finesOldButton setSelected:NO];
    [self.casesOldButton setSelected:NO];
}

- (void)activateOldCaseTab{
    [self removeContainerViewSubViews];
    newFinesTabViewController = nil;
    existingFinesViewController = nil;
    existingCasesViewController = [[ExistingCasesViewController alloc] initWithNibName:nil bundle:nil];
    [self.containerView addSubview:existingCasesViewController.view];
    [self.casesOldButton setSelected:YES];
    [self.finesNewButton setSelected:NO];
    [self.finesOldButton setSelected:NO];
}

- (void)activateOldFineTab{
    [self removeContainerViewSubViews];
    
    newFinesTabViewController = nil;
    existingFinesViewController = [[ExistingFinesViewController alloc] initWithNibName:nil bundle:nil];
    [self.containerView addSubview:existingFinesViewController.view];
    [self.finesNewButton setSelected:NO];
    [self.finesOldButton setSelected:YES];
    [self.casesOldButton setSelected:NO];
}

- (void)centerImageAndTitle:(UIButton*) button {
    //[button setImage:[UIImage imageNamed:@"PrinterIcon"] forState:UIControlStateNormal];
    
    // get the size of the elements here for readability
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    
    // get the height they will take up as a unit
    CGFloat totalHeight = (imageSize.height + titleSize.height + 5);
    
    // raise the image and push it right to center it
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height), 0.0, 0.0, - titleSize.width);
    
    // lower the text and push it left to center it
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, - imageSize.width, - (totalHeight - titleSize.height),0.0);
}

- (IBAction)LogoutButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles: @"Yes", nil];
    alert.tag = 0;
    [alert show];
}

- (IBAction)OldFinesButtonClicked:(id)sender {
    if(self.finesOldButton.isSelected)
        return;
    
    [self activateOldFineTab];
}

- (IBAction)NewFineButtonClicked:(id)sender {
    if(self.finesNewButton.isSelected)
        return;
    
    [self activateNewFineTab];
}

- (IBAction)OldCasesButtonClicked:(id)sender {
    if (self.casesOldButton.isSelected) 
        return;
    
    
    [self activateOldCaseTab];
}

#pragma mark - UIAlertViewDelegate delegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 0)
    {
        if (buttonIndex == 0)
        {
            return; //If cancel or 0 length string the string doesn't matter
        }
        else
        {
            [[SFAuthenticationManager sharedManager] logout];
        }
    }
}

@end
