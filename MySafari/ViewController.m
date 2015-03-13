//
//  ViewController.m
//  MySafari
//
//  Created by Rockstar. on 3/11/15.
//  Copyright (c) 2015 Fantastik. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *networkActivityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.scrollView.delegate = self;
    [_backButton setEnabled:NO];
    [_forwardButton setEnabled:NO];
    // Do any additional setup after loading the view, typically from a nib.

}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *string = textField.text;

    if ([string hasPrefix:@"http://"] == NO && [string hasPrefix:@"https://"] == NO) {
        string = [NSString stringWithFormat:@"http://%@", _urlTextField.text];
        NSURL *url = [NSURL URLWithString:string];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}

#pragma mark - UIWebView
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [_networkActivityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_networkActivityIndicator stopAnimating];
    NSString *string = _webView.request.URL.absoluteString;
    _urlTextField.text = string;

    NSString *title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;

    self.backButton.enabled  = self.webView.canGoBack;
    self.forwardButton.enabled = self.webView.canGoForward;

}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGRect textFieldFrame = _urlTextField.frame;

    if (scrollView.contentOffset.y <= 100) {
        textFieldFrame.origin.y += 100;
        [UIView animateWithDuration:0.2
                         animations:^{
                             _urlTextField.frame = textFieldFrame;
                             [_urlTextField setAlpha:1.0];
//                             [_urlTextField layoutIfNeeded];
                         }];

    } else if (scrollView.contentOffset.y >= 100) {
        textFieldFrame.origin.y -= 100;
        [UIView animateWithDuration:0.5
                         animations:^{
                             _urlTextField.frame = textFieldFrame;
                             [_urlTextField setAlpha:0.0];
                         }];
    }
}

#pragma mark - Actions
- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [_webView goBack];
}


- (IBAction)onForwardPressed:(id)sender {
    [_webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [_webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [_webView reload];
}

- (IBAction)onNewFeatureButtonPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New Feature"
                                                    message:@"Coming Soon!"
                                                   delegate:self
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
