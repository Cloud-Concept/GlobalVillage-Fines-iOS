//
//  NewFinesTabViewController.m
//  GVFines
//
//  Created by Mina Zaklama on 9/30/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "NewFinesTabViewController.h"
#import "NewFinesView.h"
#import "HelperClass.h"
#import "MainViewController.h"

@interface NewFinesTabViewController ()

@end

@implementation NewFinesTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(tapInView)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [HelperClass createViewWithShadows:self.finesNewView.view];
    self.finesNewView.parentViewController = self;
    
    // Register for the events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super viewWillDisappear:animated];
}

- (void)tapInView {
    [self.finesNewView tapInView];
}

- (void)keyboardDidShow:(NSNotification *)notif {
    [self.finesNewView keyboardDidShow:notif];
}

- (void)keyboardDidHide:(NSNotification *)notif {
    [self.finesNewView keyboardDidHide:notif];
}

@end
