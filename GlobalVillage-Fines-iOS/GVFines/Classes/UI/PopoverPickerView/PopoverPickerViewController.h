//
//  PopoverPickerViewController.h
//  DWC Survey
//
//  Created by Mina Zaklama on 4/28/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverPickerViewControllerDelegate <NSObject>
- (void)dismissPopover;
- (void)donePopoverSelectedIndex:(NSInteger)index;
@end

@interface PopoverPickerViewController : UIViewController <UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, weak) id <PopoverPickerViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *pickerSourceStringsArray;
@property (nonatomic, strong) NSString *noValueMessage;
@property (nonatomic) NSInteger defaultSelectedIndex;

- (id)initWithPickerSourceArray:(NSArray*)source defaultSelectIndex:(NSInteger)index;
- (IBAction)cancelClicked:(id)sender;
- (IBAction)doneClicked:(id)sender;

@end
