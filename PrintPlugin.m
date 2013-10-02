#import "PrintPlugin.h"

@interface PrintPlugin (Private)
- (void) doPrint;
- (BOOL) isPrintServiceAvailable;

@property (nonatomic, copy) NSString* callbackId;
@end

@implementation PrintPlugin

- (void)dealloc {
    self.callbackId = nil;
    [super dealloc];
}

@synthesize successCallback, failCallback, pdfURL, dialogTopPos, dialogLeftPos;

/*
 Is printing available. Callback returns true/false if printing is available/unavailable.
 */
- (void)isPrintingAvailable:(CDVInvokedUrlCommand*) command{
	self.callbackId = command.callbackId;
	NSArray *arguments = command.arguments;
    NSUInteger argc = [arguments count];
	
	if (argc < 1) {
		return;	
	}
	
	NSString* res = [NSString stringWithFormat: @"{available: %@}", ([self isPrintServiceAvailable]?@"true":@"false")];
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsString: res];
	[self.commandDelegate sendPluginResult:pluginResult callbackId: self.callbackId];
    
}

- (void)print:(CDVInvokedUrlCommand*) command{
	self.callbackId = command.callbackId;
	
	NSArray *arguments = command.arguments;
    NSUInteger argc = [arguments count];
	if (argc < 1) {
		return;	
	}
    self.pdfURL = [arguments objectAtIndex: 0];
    if (argc >= 2) self.dialogLeftPos = [[arguments objectAtIndex:1] intValue];
    if (argc >= 3) self.dialogTopPos = [[arguments objectAtIndex:2] intValue];

    [self doPrint];
}

- (void) doPrint{
    if (![self isPrintServiceAvailable]){
		CDVPluginResult* pluginResult = [CDVPluginResult  resultWithStatus: CDVCommandStatus_ERROR
														   messageAsString: @"{success: false, available: false}"];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
        return;
    }
    
    UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
    
    if (!controller){return;}
    
	if ([UIPrintInteractionController isPrintingAvailable]){        
		//Set the priner settings
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"Estimate Print";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        controller.printInfo = printInfo;
        controller.showsPageRange = YES;
        controller.printingItem = [NSData dataWithContentsOfURL:[NSURL URLWithString: self.pdfURL]];
		void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
		^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed || error) {
                NSString *res = [NSString stringWithFormat:@"{success: false, available: true, error: \"%@\"}", error.localizedDescription];
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR
																  messageAsString: res];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
			}
            else{
				NSString *res = @"{success: true, available: true}";
                CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK
																  messageAsString: res];
				[self.commandDelegate sendPluginResult:pluginResult callbackId:self.callbackId];
            }
        };
        
        /*
         If iPad, and if button offsets passed, then show dilalog originating from offset
         */
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad &&
            dialogTopPos != 0 && dialogLeftPos != 0) {
            [controller presentFromRect:CGRectMake(self.dialogLeftPos, self.dialogTopPos, 0, 0)
								 inView:self.webView
							   animated:YES completionHandler:completionHandler];
        } else {
            [controller presentAnimated:YES completionHandler:completionHandler];
        }
    }
}


-(BOOL) isPrintServiceAvailable{
    Class myClass = NSClassFromString(@"UIPrintInteractionController");
    if (myClass) {
        UIPrintInteractionController *controller = [UIPrintInteractionController sharedPrintController];
        return (controller != nil) && [UIPrintInteractionController isPrintingAvailable];
    }
    return NO;
}

@end
