//
//  HelperClass.m
//  GVFines
//
//  Created by Mina Zaklama on 10/1/14.
//  Copyright (c) 2014 CloudConcept. All rights reserved.
//

#import "HelperClass.h"
#import "Fine.h"

@implementation HelperClass
static ESCPOSPrinter *escp;

+ (void)initPrinter {
    escp = [[ESCPOSPrinter alloc] init];
    [escp setPrintingArea:20 withStartY:20 withWidth:80 withHeight:740];
}

+ (void)printReceiptForFine:(Fine*)fine {
    [self initPrinter];
    if(![self connectToPrinter]) {
        return;
    }
    
    NSDate* dateNow = [NSDate date];
    
    NSString * imgfile1 = [[NSBundle mainBundle] pathForResource:@"GV Logo.png" ofType:nil];
    [escp printBitmap:imgfile1 withAlignment:ALIGNMENT_LEFT withSize:BITMAP_NORMAL withBrightness:5];
    
    [escp lineFeed:4];
    
    [escp printText:[NSString stringWithFormat:@"Date: %@ \r\r\r\r\r\n", [self formatDateToString:dateNow]] withAlignment:ALIGNMENT_RIGHT withOption:FNT_BOLD withSize:TXT_1WIDTH];
    
    [escp printText:[NSString stringWithFormat:@"Time: %@\r\n\r\n", [self formatTimeToString:dateNow]] withAlignment:ALIGNMENT_RIGHT withOption:FNT_BOLD withSize:TXT_1WIDTH];
    
    [escp printText:[NSString stringWithFormat:@"Fine Reference No. %@\r\n\r\n", fine.CaseNumber] withAlignment:ALIGNMENT_LEFT withOption:FNT_UNDERLINE|FNT_BOLD withSize:TXT_1WIDTH];
    
    [escp printString:[NSString stringWithFormat:@"Category: %@ - %@\r\n\r\n", fine.BusinessCategory, fine.SubCategory]];
    [escp printText:@"Fine Stage:\r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD|FNT_UNDERLINE withSize:TXT_1WIDTH];
    [escp printString:[NSString stringWithFormat:@"%@\r\n\r\n", fine.fineStage]];
    [escp printText:@"Fine Clause No.:\r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD|FNT_UNDERLINE withSize:TXT_1WIDTH];
    [escp printString:[NSString stringWithFormat:@"%@\r\n\r\n", fine.ViolationClause]];
    
    [escp printText:@"Fine Description:\r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD|FNT_UNDERLINE withSize:TXT_1WIDTH];
    [escp printString:[NSString stringWithFormat:@"%@\r\n\r\n", fine.ViolationDescription]];
    
    [escp printText:@"Fine Amount in AED.:\r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD|FNT_UNDERLINE withSize:TXT_1WIDTH];
    if([fine.Status isEqualToString:@"1st Fine Printed"] || [fine.Status isEqualToString:@"1st Fine Approved"])
        [escp printString:[NSString stringWithFormat:@"%ld\r\n\r\n", (long)fine.X1stFineAmount.integerValue]];
    else
        [escp printString:[NSString stringWithFormat:@"%ld\r\n\r\n", (long)fine.X2ndFineAmount.integerValue]];
    
    [escp printText:@"Issued By:\r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD|FNT_UNDERLINE withSize:TXT_1WIDTH];
    [escp printString:[NSString stringWithFormat:@"%@\r\n\r\n", fine.CreatedBy]];
    
    [escp printText:@"Issuer:\r\n" withAlignment:ALIGNMENT_LEFT withOption:FNT_BOLD|FNT_UNDERLINE withSize:TXT_1WIDTH];
    [escp printString:@"Please note that warnings should be rectified within 48 hours, \r\n except for HSE warnings, which have to be rectified immediately, \r\n  or else Global Village has the right to issue a fine.\r\n"];
    [escp printString:@"All fines should be rectified within 3 days off issuing date.\r\n"];
    [escp printString:@"Not rectifying the violation within the allocated period,\r\n  will result in another penalty.\r\n"];
    [escp printString:@"For any inquiries, kindly approach Government Relations & \r\n Administration offices.\r\n"];
    [escp printString:@"Please visit the GR office within 2 days of issue of this fine.\r\n"];
    [escp printText:@"Thank you. \r\r\r" withAlignment:ALIGNMENT_CENTER withOption:0 withSize:TXT_1WIDTH];
    [escp lineFeed:4];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(disconnectCommand) userInfo:nil repeats:NO];
    
}

+ (BOOL)connectToPrinter {
    BOOL returnValue = NO;
    NSString * ip = @"bluetooth";
    NSLog(@"Connect call\r\n");
    int errCode = 0;
    
    if((errCode = [escp openPort:ip withPortParam:9100]) >= 0)
    {
        NSLog(@"Connection Established\r\n");
        returnValue = YES;
    }
    else if(errCode == -3)
    {
        NSLog(@"ERROR: Invalid device\r\n");
        [self messageBox:@"Invalid printer device" withTitle:@"Error"];
        returnValue = NO;
    }
    else
    {
        NSLog(@"ERROR: Connection error\r\n");
        [self messageBox:@"Could not connect to the printer" withTitle:@"Error"];
        returnValue = NO;
    }
    
    return returnValue;
}

+ (void) disconnectCommand {
    [escp closePort];
    NSLog(@"Disconnect call\r\n");
}

+ (void)messageBox:(NSString *) message withTitle:(NSString *) title{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (NSString*) formatDateToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSLog(@"%@", dateStr);
    
    return dateStr;
}

+ (NSString*) formatTimeToString:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *timeStr = [formatter stringFromDate:date];
    
    NSLog(@"%@", timeStr);
    
    return timeStr;
}

+ (NSString*)formatDateTimeToString:(NSDate*)date {
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    NSString *dateTimeStr = [format stringFromDate:date];
    
    NSLog(@"%@", dateTimeStr);
    
    return dateTimeStr;
}

+ (void)statusCheckReceived:(NSNotification *) notification {
    uint32_t bytesAvailable = 0;
    uint32_t readLength = 0;
    unsigned char buf[8] = {0,};
    EABluetoothPort * sessionController = (EABluetoothPort *)[notification object];
    NSString * result = [[NSString alloc] init];
#ifdef DEBUG
    NSLog(@"===== Status Check START =====");
#endif
    NSMutableData * readData = [[NSMutableData alloc] init];
    while((bytesAvailable = [sessionController readBytesAvailable]) > 0)
    {
        NSData * data = [sessionController readData:bytesAvailable];
        if(data)
        {
            [readData appendData:data];
            readLength = readLength + bytesAvailable;
        }
    }
    if(readLength > sizeof(buf))
        readLength = sizeof(buf);
    [readData getBytes:buf length:readLength];
    
    int sts = buf[readLength - 1];
    if(sts == STS_NORMAL)
    {
        [self messageBox:@"Normal" withTitle:@"Printer Status"];
    }
    else
    {
        if((sts & STS_COVEROPEN) > 0)
        {
            result = [result stringByAppendingString:@"Cover Open\r\n"];
        }
        if((sts & STS_PAPEREMPTY) > 0)
        {
            result = [result stringByAppendingString:@"Paper Empty\r\n"];
        }
        [self messageBox:result withTitle:@"Printer Status"];
    }
#ifdef DEBUG
    NSLog(@"===== Status Check EXIT =====");
#endif
}

+ (void)createRoundBorderedViewWithShadows:(UIView*)view {
    // border radius
    [view.layer setCornerRadius:10.0f];
    
    // border
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    // drop shadow
    [view.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:0.5];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

+ (void)createViewWithShadows:(UIView*)view {
    // border radius
    //[view.layer setCornerRadius:10.0f];
    
    // border
    //[view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    
    // drop shadow
    [view.layer setShadowColor:[UIColor darkGrayColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:0.5];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

+ (void)setStatusBackground:(Fine*)fineObject ImageView:(UIImageView*)statusImageView {
    if([fineObject.Status isEqualToString: @"Rectified"]) {
        [statusImageView setImage:[UIImage imageNamed:@"fineStatusGreen"]];
    }
    else if ([fineObject.Status isEqualToString:@"Fine Rejected"]) {
        [statusImageView setImage:[UIImage imageNamed:@"fineStatusRed"]];
    }
    else {
        [statusImageView setImage:[UIImage imageNamed:@"fineStatusYellow"]];
    }
}

+ (UIImage*)imageWithImage:(UIImage*)image ScaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
