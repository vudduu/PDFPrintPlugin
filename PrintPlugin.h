#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>

@interface PrintPlugin : CDVPlugin {
    NSString* successCallback;
    NSString* failCallback;
    NSString* pdfURL;
    
    //Options
    NSInteger dialogLeftPos;
    NSInteger dialogTopPos;
}

@property (nonatomic, copy) NSString* successCallback;
@property (nonatomic, copy) NSString* failCallback;
@property (nonatomic, copy) NSString* pdfURL;
@property (nonatomic, copy) NSString* callbackId;

//Print Settings
@property NSInteger dialogLeftPos;
@property NSInteger dialogTopPos;

//Print HTML
- (void) print:(CDVInvokedUrlCommand*) command;

//Find out whether printing is supported on this platform.
- (void) isPrintingAvailable:(CDVInvokedUrlCommand*) command;

@end
