//
//  LNoDataLodingView.m
//  越野e族
//
//  Created by 罗树新 on 15/8/27.
//  Copyright (c) 2015年 罗树新. All rights reserved.
//

#import "NoDataLodingView.h"
#import <objc/runtime.h>
enum ImageCompressType{
    ImageCompressTypeWidth,
    ImageCompressTypeHeight
};


//指定宽度按比例缩放
UIImage * CompressImage(enum ImageCompressType type, UIImage * sourceImage ,CGFloat definefloat){
    UIImage *newImage = nil;
    CGSize imageSize;
    CGSize size;
    CGFloat targetWidth;
    CGFloat width;
    CGFloat height;
    CGFloat targetHeight;
    switch (type) {
        case ImageCompressTypeHeight:
        {
            imageSize = sourceImage.size;
            width = imageSize.width;
            height = imageSize.height;
            targetHeight = definefloat;
            targetWidth = width / (height / targetHeight);
            size = CGSizeMake(targetWidth, targetHeight);
            break;
        }
        case ImageCompressTypeWidth:
        {
            imageSize = sourceImage.size;
            width = imageSize.width;
            height = imageSize.height;
            targetWidth = definefloat;
            targetHeight = height / (width / targetWidth);
            size = CGSizeMake(targetWidth, targetHeight);
            break;
        }
        default:
            break;
    }
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}


typedef void(^RefreshBlock)();


@implementation UIView (NodataLoadingViewCategory)

static char kNodataLoadingViewKey;      //view

static char kLogoImageView;             //logoImageView

static char kNodataTitle;               //nodataLabel

static char kRefreshButton;             //刷新button

static char kRefreshActivity;           //刷新菊花

static char kNodataState;               //当前状态

static char kRefreshBlock;              //refreshBlock
#pragma - mark - ***********************************************创建*****************************************


//view
- (UIView *)nodataLoadingView
{
    return objc_getAssociatedObject(self, &kNodataLoadingViewKey);
}
- (void)setNodataLoadingView:(UIView *)view
{
    objc_setAssociatedObject(self, &kNodataLoadingViewKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}
//logoImageView
- (UIImageView *)logoImageView
{
    return objc_getAssociatedObject(self, &kLogoImageView);
}
- (void)setLogoImageView:(UIImageView *)view
{
    objc_setAssociatedObject(self, &kLogoImageView, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//nodataLabel
- (NSString *)nodataTitle
{
    return objc_getAssociatedObject(self, &kNodataTitle);
}
- (void)setNodataTitle:(NSString *)title
{
    objc_setAssociatedObject(self, &kNodataTitle, title, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//刷新button
- (UIButton *)refreshButton
{
    return objc_getAssociatedObject(self, &kRefreshButton);
}
- (void)setRefreshButton:(UIButton *)button
{
    objc_setAssociatedObject(self, &kRefreshButton, button, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//刷新菊花
- (UIActivityIndicatorView *)refreshActivity
{
    return objc_getAssociatedObject(self, &kRefreshActivity);
}
- (void)setRefreshActivity:(UIActivityIndicatorView *)activity
{
    objc_setAssociatedObject(self, &kRefreshActivity, activity, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NoDataLodingViewState)nodataState
{
    return [objc_getAssociatedObject(self, &kNodataState) integerValue];

}
- (void)setNodataState:(NoDataLodingViewState)state
{
    objc_setAssociatedObject(self, &kNodataState, [NSString stringWithFormat:@"%ld",(long)state], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (RefreshBlock)refreshBlock
{
    return objc_getAssociatedObject(self, &kRefreshBlock);
    
}
- (void)setRefreshBlock:(RefreshBlock)block
{
    objc_setAssociatedObject(self, &kRefreshBlock, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma -mark- ********************************************执行****************************************

-(void)addNodataLoadingViewWithLogoImage:(UIImage *)image refreshBlock:(void (^)())cRefreshBlock{
    self.nodataLoadingView = [[UIView alloc] initWithFrame:self.frame];
    self.nodataLoadingView.backgroundColor = [UIColor clearColor];
   
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshButton.backgroundColor = [UIColor clearColor];
    self.refreshButton.frame = CGRectMake(0.f, 0.f, 130, 23);
    self.refreshButton.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    self.refreshButton.titleLabel.font = [UIFont systemFontOfSize:13];
    self.refreshButton.alpha = 0;
    [self.refreshButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.nodataLoadingView addSubview:self.refreshButton];

    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, 130.f, 1)];
    topLine.backgroundColor = [UIColor colorWithRed:233.f/255 green:233.f/255 blue:233.f/255 alpha:1.0];
    [self.refreshButton addSubview:topLine];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.f, 22.f, 130, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:233.f/255 green:233.f/255 blue:233.f/255 alpha:1.0];
    [self.refreshButton addSubview:bottomLine];
    
    
    self.logoImageView = [[UIImageView alloc] initWithImage:CompressImage(ImageCompressTypeHeight, image, 60)];
    self.logoImageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 37 - 17.5);
    [self.nodataLoadingView addSubview:self.logoImageView];
    
    self.refreshActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.refreshActivity.center = self.refreshButton.center;
    self.refreshActivity.hidden = YES;
    [self.nodataLoadingView addSubview:self.refreshActivity];
    
    if (cRefreshBlock) {
        self.refreshBlock = cRefreshBlock;
        [self.refreshButton addTarget:self action:@selector(refreshButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    self.nodataLoadingView.userInteractionEnabled = YES;
    self.nodataLoadingView.backgroundColor = [UIColor whiteColor];

    [self.superview addSubview:self.nodataLoadingView];
    
    [self setNodataLoadingViewState:NoDataLodingViewStateHidden title:customRefreshTitle];
}


- (void)refreshButtonClicked{
    [self setNodataLoadingViewState:NoDataLodingViewStateRefreshing title:nil];
    if (self.refreshBlock) {
        self.refreshBlock();
    }
}
- (void)setNewRefreshBlock:(void (^)())newsRefreshBlock{
    if (self.refreshBlock == newsRefreshBlock) {
        return;
    }
    self.refreshBlock = newsRefreshBlock;
}

- (void)setNodataLoadingViewState:(NoDataLodingViewState)state title:(NSString *)title
{
    if (title == nil && ![title isEqualToString:self.nodataTitle]) {
        title = self.nodataTitle;
    }
    if (state == self.nodataState && [title isEqualToString:self.refreshButton.titleLabel.text]) {
        return;
    }
    switch (state) {
        case NoDataLodingViewStateNodataLabel:
        {
            self.refreshButton.userInteractionEnabled = NO;
            
            switch (self.nodataState) {
                case NoDataLodingViewStateHidden:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.nodataLoadingView.alpha = 1;
                    }];
                }
                case NoDataLodingViewStateShow:
                {
                    [self.refreshButton setTitle:title forState:UIControlStateNormal];
                    self.refreshButton.alpha = 0;
                    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.refreshButton.alpha = 1;
                        self.refreshActivity.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.refreshActivity stopAnimating];
                    }];
                    break;
                }
                case NoDataLodingViewStateRefreshButton:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.refreshButton.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.refreshButton setTitle:title forState:UIControlStateNormal];
                        [UIView animateWithDuration:0.5 animations:^{
                            self.refreshButton.alpha = 1;
                        } completion:nil];
                    }];
                    break;
                }
                case NoDataLodingViewStateRefreshing:{
                    [self.refreshButton setTitle:title forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.5 animations:^{
                        self.refreshButton.alpha = 1;
                        self.refreshActivity.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.refreshActivity stopAnimating];
                    }];
                    break;
                }
                case NoDataLodingViewStateNodataLabel:
                {
                    break;
                }
            }
            
            break;
        }
        case NoDataLodingViewStateRefreshButton:
        {
            self.refreshButton.userInteractionEnabled = YES;

            switch ( self.nodataState) {
                    
                case NoDataLodingViewStateHidden:
                {
                    [UIView animateWithDuration:0.5 animations:^{
                        self.nodataLoadingView.alpha = 1;
                        self.refreshActivity.alpha = 0;

                    } completion:^(BOOL finished) {
                        [self.refreshActivity stopAnimating];

                        [self.refreshButton setTitle:title forState:UIControlStateNormal];
                        [UIView animateWithDuration:0.5 animations:^{
                            
                            self.refreshButton.alpha = 1;
                        } completion:^(BOOL finished) {
                        }];
                    }];
                }
                case NoDataLodingViewStateNodataLabel:
                {
                    [UIView animateWithDuration:0.25 animations:^{
                        self.refreshButton.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.refreshButton setTitle:title forState:UIControlStateNormal];
                        [UIView animateWithDuration:0.25 animations:^{
                            self.refreshButton.alpha = 1;
                        } completion:nil];
                    }];
                    break;
                }
                case NoDataLodingViewStateShow:
                {
                    [self.refreshButton setTitle:title forState:UIControlStateNormal];
                    self.refreshButton.alpha = 0;
                    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                        self.refreshButton.alpha = 1;
                        self.refreshActivity.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.refreshActivity stopAnimating];
                    }];
                    break;
                }
                case NoDataLodingViewStateRefreshing:
                {
                    [self.refreshButton setTitle:title forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.5 animations:^{

                        self.refreshButton.alpha = 1;
                        self.refreshActivity.alpha = 0;
                    } completion:^(BOOL finished) {
                        [self.refreshActivity stopAnimating];
                    }];
                }
                case NoDataLodingViewStateRefreshButton:
                {
                    break;
                }
            }
            break;
        }
        case NoDataLodingViewStateHidden:{
            switch (self.nodataState) {
                case NoDataLodingViewStateShow:
                case  NoDataLodingViewStateRefreshing:
                {
                    [self.refreshActivity stopAnimating];
                    self.nodataLoadingView.alpha = 0;
                    break;
                }
                case NoDataLodingViewStateRefreshButton:
                case NoDataLodingViewStateNodataLabel:
                {
                    self.nodataLoadingView.alpha = 0;

                    break;
                }
                case NoDataLodingViewStateHidden:
                {
                    self.nodataLoadingView.alpha = 0;

                    break;
                }
            }
            break;
        }
        case NoDataLodingViewStateRefreshing:
        {
            switch (self.nodataState) {
                case NoDataLodingViewStateHidden:
                {
                    [self.refreshActivity startAnimating];
                    self.refreshButton.alpha = 0;
                    self.refreshActivity.center = self.refreshButton.center;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.nodataLoadingView.alpha = 1;
                    }];
                    break;
                    
                }

                case NoDataLodingViewStateNodataLabel:
                case NoDataLodingViewStateRefreshButton:
                case NoDataLodingViewStateShow:
                {
                    {
                        [self.refreshActivity startAnimating];
                        self.refreshActivity.alpha = 0;
                        self.refreshActivity.center = self.refreshButton.center;
                        [UIView animateWithDuration:0.5 animations:^{
                            self.refreshButton.alpha = 0;
                            self.refreshActivity.alpha = 1;
                        }];
                        break;
                        
                    }

                    break;
                }
                case NoDataLodingViewStateRefreshing:
                {
                    
                    break;
                }
            }
            break;
        }
        case NoDataLodingViewStateShow:
        {
            break;
        }
    }
    self.nodataState = state;
}

- (void)setNodataLoadingViewActivityStyle:(UIActivityIndicatorViewStyle)style{
    self.refreshActivity.activityIndicatorViewStyle = style;
}
- (void)removeNodataLoadingView{
    [self.nodataLoadingView removeFromSuperview];
}
@end
