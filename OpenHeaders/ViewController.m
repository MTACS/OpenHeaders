//
//  ViewController.m
//  OpenHeaders
//
//  Created by MTAC on 31/05/2019.
//  Copyright © 2019 MTAC. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface WKWebView(SynchronousEvaluateJavaScript)
- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script;
@end

@implementation WKWebView(SynchronousEvaluateJavaScript)



- (NSString *)stringByEvaluatingJavaScriptFromString:(NSString *)script
{
    __block NSString *resultString = nil;
    __block BOOL finished = NO;
    
    [self evaluateJavaScript:script completionHandler:^(id result, NSError *error) {
        if (error == nil) {
            if (result != nil) {
                resultString = [NSString stringWithFormat:@"%@", result];
            }
        } else {
            NSLog(@"evaluateJavaScript error : %@", error.localizedDescription);
        }
        finished = YES;
    }];
    
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    return resultString;
}
@end

@implementation ViewController

- (IBAction)reloadButton:(NSButton *)sender {
    
    [self viewDidLoad];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView.navigationDelegate = self;
    
    _webView.UIDelegate = self;
    
    int x = 0;
    
    if (_headerSelector.indexOfSelectedItem == 0) {
        
        [_headerSelector setIntValue:0];
        
    } else if (_headerSelector.indexOfSelectedItem == 1) {
        
        x = 1;
        
        [_headerSelector setIntValue:1];
        
    }
    
    NSURL *nsurl = [NSURL URLWithString:@"https://developer.limneos.net"];
    
    NSURL *nsurl2 = [NSURL URLWithString:@"https://headers.evendev.org"];
    
    NSURLRequest *nsrequest = [NSURLRequest requestWithURL:nsurl];
    
    NSURLRequest *nsrequest2 = [NSURLRequest requestWithURL:nsurl2];
    
    if (x == 0) {
        
        [_webView loadRequest:nsrequest];
        
    } else {
        
        [_webView loadRequest:nsrequest2];
        
    }
    
   // [_webView loadRequest:nsrequest2];
    
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:NSKeyValueObservingOptionNew context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        self.progressBar.doubleValue = self.webView.estimatedProgress * 100;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressBar.hidden = YES;
    NSLog(@"Color: %@", [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('BODY')[0].style.color"]);
}

-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressBar.hidden = NO;
}

-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    /* if(!([[navigationAction.request.URL host] isEqual:@"developer.limneos.net"])) {
        [[NSWorkspace sharedWorkspace] openURL:navigationAction.request.URL];
    } */
    
    decisionHandler(YES);
}

- (void)dealloc {
    
    if ([self isViewLoaded]) {
        [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    
    // if you have set either WKWebView delegate also set these to nil here
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
