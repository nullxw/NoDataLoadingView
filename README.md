# NodataLoadingView
NodataLoadingView
在webView\scrollView\TableView刷新数据没有完全显示的时候，显示的一个占位view。
## 演示
* RefreshButton
  -- 点击可以执行初始化时设置的block
![simulator screen shot 2015 9 22 7 12 39](https://cloud.githubusercontent.com/assets/11473468/10017158/b0a19274-615e-11e5-86ff-49d23300bdfd.png)
* Refreshing
  -- 正在刷新过程中
![simulator screen shot 2015 9 22 7 21 51](https://cloud.githubusercontent.com/assets/11473468/10017255/687fbf06-615f-11e5-9fa6-90abf210e3fa.png)
*其他
  * Label
  --不可点击，显示下状态
  * Hidden
  -- 刷新出来数据后隐藏
  * Show
  --显示

## 用法实例
### 初始化
1、你需要在添加之前，首先将要设置NoDataLoadingView的View添加到父视图上

```
    [self.view addSubview:WebView];
    [WebView addNodataLoadingViewWithLogoImage:[UIImage imageNamed:@"background"] refreshBlock:^{
        [WebView loadRequest:[NSURLRequest requestWithURL:url]];
    }];
```

2、设置状态

```
        [WebView setNodataLoadingViewState:NoDataLodingViewStateRefreshButton title:@"点击刷新"];
```
可以设置的状态有：
```
typedef NS_ENUM(NSInteger, NoDataLodingViewState){
    NoDataLodingViewStateNodataLabel,               //Label形式，不能点击
    NoDataLodingViewStateRefreshButton,             //Button 点击执行相应的block
    NoDataLodingViewStateHidden,                    //隐藏
    NoDataLodingViewStateShow,                      //显示
    NoDataLodingViewStateRefreshing                 //刷新
};
```
统一使用的的设置方法为：
```
- (void)setNodataLoadingViewState:(NoDataLodingViewState)state title:(NSString *)title;
```
3、可以重新设置要执行的block，设置方法为：
```
- (void)setNewRefreshBlock:(void (^)())newsRefreshBlock;
```
4、可以设置刷新时的UIActivityIndicatorViewStyle
```
- (void)setNodataLoadingViewActivityStyle:(UIActivityIndicatorViewStyle)style;
```
5、在不需要的时候可以移除掉
```
- (void)removeNodataLoadingView;
```
# 最后 
如果使用中遇到问题或bug，请留言。期望共同学习，共同进步！
