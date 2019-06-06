//
//  ViewController.h
//  OpenHeaders
//
//  Created by MTAC on 31/05/2019.
//  Copyright © 2019 MTAC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface ViewController : NSViewController <WKNavigationDelegate, WKUIDelegate>

@property (strong) IBOutlet WKWebView *webView;

@property (strong) IBOutlet NSProgressIndicator *progressBar;

@property (weak) IBOutlet NSPopUpButton *headerSelector;

@end
