//
//  EABTPort.h
//  iOS
//
//  Created by leesk on 2/12/13.
//  Copyright (c) 2013. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>

extern NSString * EADSessionDataReceivedNotification;

@interface EABluetoothPort : NSObject <EAAccessoryDelegate, NSStreamDelegate>
{
    EAAccessory *_accessory;
    EASession *_session;
    NSString *_protocolString;
    
    NSMutableData *_wData;
    NSMutableData *_rData;
}

// GetInstance
+ (EABluetoothPort *)sharedController;

// Setup method.
- (void)setupControllerForAccessory:(EAAccessory *)accessory withProtocolString:(NSString *)protocolString;

- (BOOL)openSession;
- (void)closeSession;
// Add function
- (void)closeSessionWait;

- (int) readBytesAvailable;
- (NSData *) readData:(NSUInteger)bytesToRead;

- (void) writeData:(unsigned char *)data charsToSend:(int)length;

@end
