//
//  ViewController.m
//  NoDataLoadingView
//
//  Created by 罗树新 on 15/9/23.
//  Copyright © 2015年 罗树新. All rights reserved.
//

#import "ViewController.h"
#import "NoDataLodingView.h"
@interface ViewController ()<UIWebViewDelegate>
{
    UIWebView * selfWebView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    selfWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    selfWebView.backgroundColor = [UIColor whiteColor];
    selfWebView.delegate = self;
    selfWebView.alpha = 0;

    [self.view addSubview:selfWebView];
    [selfWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.163.com"]]];

    
    __weak typeof(selfWebView)weakWeb = selfWebView;
    [selfWebView addNodataLoadingViewWithLogoImage:[UIImage imageNamed:@"background"] refreshBlock:^{
        [weakWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.163.com"]]];
    }];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [selfWebView setNodataLoadingViewState:NoDataLodingViewStateRefreshing title:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [selfWebView setNodataLoadingViewState:NoDataLodingViewStateHidden title:nil];

    [UIView animateWithDuration:0.23 animations:^{
        selfWebView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

    if ([error code] != NSURLErrorCancelled) {
        [selfWebView setNodataLoadingViewState:NoDataLodingViewStateRefreshButton title:@"点击刷新"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
