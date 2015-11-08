//
//  PopoverPickerViewController.m
//  DWC Survey
//
//  Created by Mina Zaklama on 4/28/14.
//  Copyright (c) 2014 ZAPP Island. All rights reserved.
//

#import "PopoverPickerViewController.h"

@interface PopoverPickerViewController ()

@end

@implementation PopoverPickerViewController

- (id)initWithPickerSourceArray:(NSArray*)source defaultSelectIndex:(NSInteger)index
{
	self = [super initWithNibName:@"PopoverPickerViewController" bundle:nil];
    if (self) {
        self.pickerSourceStringsArray = source;
		self.defaultSelectedIndex = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	self.pickerView.delegate = self;
	
	[self.pickerView selectRow:self.defaultSelectedIndex inComponent:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelClicked:(id)sender {
	[self.delegate dismissPopover];
}

- (IBAction)doneClicked:(id)sender {
	if([self.pickerSourceStringsArray count] > 0)
	{
		[self.delegate donePopoverSelectedIndex:[self.pickerView selectedRowInComponent:0]];
	}
	else
		[self.delegate donePopoverSelectedIndex:-1];
}

#pragma UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;// or the number of vertical "columns" the picker will show...
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	//this will tell the picker how many rows it has - in this case, the size of your loaded array...
    
	if([self.pickerSourceStringsArray count] > 0)
		return [self.pickerSourceStringsArray count];
	else
		return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if([self.pickerSourceStringsArray count] > 0)
	{
		return [self.pickerSourceStringsArray objectAtIndex:row];
	}
    else
        return self.noValueMessage;
}

@end
