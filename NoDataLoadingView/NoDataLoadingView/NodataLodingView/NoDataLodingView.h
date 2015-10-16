//
//  LNoDataLodingView.h
//  越野e族
//
//  Created by 罗树新 on 15/8/27.
//  Copyright (c) 2015年 罗树新. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const customRefreshTitle = @"点击刷新数据";
typedef NS_ENUM(NSInteger, NoDataLodingViewState){
    NoDataLodingViewStateNodataLabel,               //Label形式，不能点击
    NoDataLodingViewStateRefreshButton,             //Button 点击执行相应的block
    NoDataLodingViewStateHidden,                    //隐藏
    NoDataLodingViewStateShow,                      //显示
    NoDataLodingViewStateRefreshing                 //刷新
};
@interface UIView (NodataLoadingViewCategory)
@property(nonatomic,copy) UIView * nodataLoadingView;

-(void)addNodataLoadingViewWithLogoImage:(UIImage *)image refreshBlock:(void (^)())cRefreshBlock;
- (void)setNewRefreshBlock:(void (^)())newsRefreshBlock;
- (void)setNodataLoadingViewState:(NoDataLodingViewState)state title:(NSString *)title;
- (void)setNodataLoadingViewActivityStyle:(UIActivityIndicatorViewStyle)style;
- (void)removeNodataLoadingView;
@end