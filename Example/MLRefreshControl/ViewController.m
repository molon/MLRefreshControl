//
//  ViewController.m
//  MLRefreshControl
//
//  Created by molon on 16/7/15.
//  Copyright © 2016年 molon. All rights reserved.
//

#import "ViewController.h"
#import <MLRefreshControl.h>


@interface UIViewController (Temp)
@end
@implementation UIViewController (Temp)

#define kSystemVersion ([UIDevice currentDevice].systemVersion.doubleValue)

+ (CGFloat)statusBarHeight {
    //    CGSize statusBarSize = [[UIApplication sharedApplication] statusBarFrame].size;
    //    return [UIApplication sharedApplication].statusBarHidden?0.0f:fmin(statusBarSize.width, statusBarSize.height);
    
    // When a tel call comes in, the statusBarHeight should be 40.0f
    // But but !! if use 40, the view's height will be reduced by 20 simultaneously.
    // So always using 20 is well.
    return 20.0f;
}

- (CGFloat)navigationBarBottomY {
    if (kSystemVersion<7.0f) {
        return 0.0f;
    }
    
    if (!self.navigationController) {
        return [UIViewController statusBarHeight];
    }else{
        if (!self.navigationController.navigationBar.translucent) {
            return 0.0f;
        }
    }
    return [UIViewController statusBarHeight] + (self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.intrinsicContentSize.height);
}

- (CGFloat)tabBarOccupiedHeight {
    if (kSystemVersion<7.0f) {
        return 0.0f;
    }
    if (!self.tabBarController) {
        return 0.0f;
    }
    if (!self.tabBarController.tabBar.translucent) {
        return 0.0f;
    }
    if (self.hidesBottomBarWhenPushed) {
        return 0.0f;
    }
    return self.tabBarController.tabBar.intrinsicContentSize.height;
}

@end

@interface UIScrollView(Temp)
@end

@implementation UIScrollView(Temp)


- (void)setContentInsetTop:(CGFloat)top {
    UIEdgeInsets inset = self.contentInset;
    if (inset.top==top) {
        return;
    }
    
    inset.top = top;
    
    CGFloat adjustOffsetY = self.contentInset.top - inset.top;
    CGPoint offset = self.contentOffset;
    self.contentInset = inset;
    
    offset.y += adjustOffsetY;
    self.contentOffset = offset;
}

- (void)setContentInsetBottom:(CGFloat)bottom {
    UIEdgeInsets inset = self.contentInset;
    if (inset.bottom==bottom) {
        return;
    }
    inset.bottom = bottom;
    self.contentInset = inset;
}

@end

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"MLRefreshControl";
    
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.tableView];
    
    //Dont advise to use `automaticallyAdjustsScrollViewInsets`
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.contentInsetTop = [self navigationBarBottomY];
    self.tableView.contentInsetBottom = [self tabBarOccupiedHeight];
    
    if (!self.tableView.refreshView) {
        __weak __typeof(self)wSelf = self;
        [self.tableView enableRefreshingWithAction:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong __typeof(wSelf)sSelf = wSelf;
                [sSelf.tableView endRefreshing];
            });
        } style:MLRefreshControlViewStyleFixed scrollToTopAfterEndRefreshing:YES];
    }
}

#pragma mark - layout
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.bounds;
}

#pragma mark - getter
- (UITableView *)tableView
{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
        _tableView = tableView;
    }
    return _tableView;
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %ld",section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}



@end
