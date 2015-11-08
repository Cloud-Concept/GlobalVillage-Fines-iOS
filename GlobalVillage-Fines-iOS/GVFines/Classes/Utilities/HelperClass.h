//
//  HelperClass.h
//  GVFines
//
//  Created by Mina Zaklama on 10/1/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESCPOSPrinter.h"
#import "EABluetoothPort.h"

@class Fine;

@interface HelperClass : NSObject

+ (void)initPrinter;
+ (void)printReceiptForFine:(Fine*)fine;
+ (NSString*) formatTimeToString:(NSDate*)date;
+ (NSString*) formatDateToString:(NSDate*)date;
+ (NSString*)formatDateTimeToString:(NSDate*)date;
+ (void)statusCheckReceived:(NSNotification *) notification;
+ (void)createRoundBorderedViewWithShadows:(UIView*)view;
+ (void)createViewWithShadows:(UIView*)view;
+ (void)setStatusBackground:(Fine*)fineObject ImageView:(UIImageView*)statusImageView;
+ (void)messageBox:(NSString *)message withTitle:(NSString *)title;
+ (UIImage*)imageWithImage:(UIImage*)image ScaledToSize:(CGSize)newSize;
@end
