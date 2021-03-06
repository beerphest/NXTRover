//
//  CNXTHandler.m
//  NXTServer
//
//  Created by Jonathan Wight on 08/21/10.
//  Copyright 2010 toxicsoftware.com. All rights reserved.
//

#import "CNXTHandler.h"

#import "LegoNXT/LegoNXT.h"

#import "CHTTPMessage.h"
#import "NSURL_Extensions.h"
#import "CHTTPMessage_ConvenienceExtensions.h"

@interface CNXTHandler ()
@property (readwrite, nonatomic, retain) NXT *nxt;
@end

@implementation CNXTHandler

@synthesize nxt;

- (id)init
{
	if ((self = [super init]) != NULL)
    {
		al = 0;
		ar = 0;
		tick = 0;
		nxt = [[NXT alloc] init];
		[nxt connect:self];
		//timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(moveCar) userInfo:nil repeats:YES];
		//[self performSelector:@selector(moveCar) withObject:nil afterDelay:3.0];   
    }
	return(self);
}

- (void)dealloc
{
[nxt release];
nxt = NULL;
//
[super dealloc];
}

- (BOOL)handleRequest:(CHTTPMessage *)inRequest forConnection:(CHTTPConnection *)inConnection response:(CHTTPMessage **)ioResponse error:(NSError **)outError;
{
	NSDictionary *theQueryDictionary = inRequest.requestURL.queryDictionary;
	
	NSString *theValue = [theQueryDictionary objectForKey:@"left"];
	if (theValue)
    {
		SInt8 thePower = [theValue intValue];
		al = thePower;
		//[self.nxt moveServo:0 power:thePower tacholimit:0];
    }
	
	theValue = [theQueryDictionary objectForKey:@"right"];
	if (theValue)
    {
		SInt8 thePower = [theValue intValue];
		ar = thePower;
		//[self.nxt moveServo:1 power:thePower tacholimit:0];
    }
	
	theValue = [theQueryDictionary objectForKey:@"shoot"];
	if (theValue)
    {
		SInt8 thePower = [theValue intValue];
		as = thePower;
		//[self.nxt moveServo:1 power:thePower tacholimit:0];
    }
	
	tick = 10;
	
	[self moveCar];
	//[self performSelectorInBackground:@selector(moveCar) withObject:nil]; 
	
	if (ioResponse)
	{
		*ioResponse = [CHTTPMessage HTTPMessageResponseWithStatusCode:kHTTPStatusCode_OK];
	}
	return(YES);
}

- (void)moveCar {
	[self.nxt moveServo:0 power:al tacholimit:0];
	[self.nxt moveServo:2 power:ar tacholimit:0];
	if (as == 1)
	{
		[self.nxt moveServo:1 power:100 tacholimit:100];
	}
	else {
		[self.nxt moveServo:1 power:0 tacholimit:0];
	}

}

#pragma mark -

- (void)NXTDiscovered:(NXT*)nxt
{
NSLog(@"DISCOVERED");
}

- (void)NXTClosed:(NXT*)nxt
{
}

- (void)NXTCommunicationError:(NXT*)nxt code:(int)code
{
}

- (void)NXTOperationError:(NXT*)nxt operation:(UInt8)operation status:(UInt8)status
{
}

- (void)NXTGetInputValues:(NXT*)nxt port:(UInt8)port isCalibrated:(BOOL)isCalibrated type:(UInt8)type mode:(UInt8)mode
                 rawValue:(UInt16)rawValue normalizedValue:(UInt16)normalizedValue
              scaledValue:(SInt16)scaledValue calibratedValue:(SInt16)calibratedValue
{
}

- (void)NXTGetOutputState:(NXT*)nxt port:(UInt8)port power:(SInt8)power mode:(UInt8)mode regulationMode:(UInt8)regulationMode
                turnRatio:(SInt8)turnRatio runState:(UInt8)runState tachoLimit:(UInt32)tachoLimit tachoCount:(SInt32)tachoCount
          blockTachoCount:(SInt32)blockTachoCount rotationCount:(SInt32)rotationCount
{
}

- (void)NXTBatteryLevel:(NXT*)nxt batteryLevel:(UInt16)batteryLevel
{
}

- (void)NXTSleepTime:(NXT*)nxt sleepTime:(UInt32)sleepTime
{
}

- (void)NXTCurrentProgramName:(NXT*)nxt currentProgramName:(NSString*)currentProgramName
{
}

- (void)NXTLSGetStatus:(NXT*)nxt port:(UInt8)port bytesReady:(UInt8)bytesReady
{
}
- (void)NXTLSRead:(NXT*)nxt port:(UInt8)port bytesRead:(UInt8)bytesRead data:(NSData*)data
{
}

- (void)NXTMessageRead:(NXT*)nxt message:(NSData*)message localInbox:(UInt8)localInbox
{
}


@end
