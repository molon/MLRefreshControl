//
//  UIScrollView+MLRefreshControl.m
//
//  Created by molon on 15/8/18.
//  Copyright (c) 2015年 molon. All rights reserved.
//

#import "UIScrollView+MLRefreshControl.h"
#import <objc/runtime.h>
#import "MLRefreshControlView.h"
#import "CircleMLRefreshControlAnimateView.h"

@interface UIScrollView()

@property (nonatomic, strong) MLRefreshControlView *refreshView;
@property (nonatomic, strong) NSDate *lastRefreshTime;

@end

@implementation UIScrollView (MLRefreshControl)

#pragma mark - event
- (void)enableRefreshControlWithAction:(MLRefreshControlActionBlock)actionBlock style:(MLRefreshControlViewStyle)style originalTopInset:(CGFloat)originalTopInset scrollToTopAfterEndRefreshing:(BOOL)scrollToTopAfterEndRefreshing
{
    [self enableRefreshControlWithAction:actionBlock style:style originalTopInset:originalTopInset scrollToTopAfterEndRefreshing:scrollToTopAfterEndRefreshing animteView:[CircleMLRefreshControlAnimateView new]];
}

- (void)enableRefreshControlWithAction:(MLRefreshControlActionBlock)actionBlock style:(MLRefreshControlViewStyle)style originalTopInset:(CGFloat)originalTopInset scrollToTopAfterEndRefreshing:(BOOL)scrollToTopAfterEndRefreshing animteView:(MLRefreshControlAnimateView*)animateView
{
    if (!animateView) {
        animateView = [CircleMLRefreshControlAnimateView new];
        
    }
    self.refreshView = [[MLRefreshControlView alloc]initWithAction:actionBlock animateView:animateView style:style originalTopInset:originalTopInset scrollToTopAfterEndRefreshing:scrollToTopAfterEndRefreshing];
}

- (void)invalidateRefreshControl {
    self.refreshView = nil;
}

- (void)endRefreshing
{
    [self.refreshView endRefreshing];
}

- (void)beginRefreshing
{
    if (!self.refreshView) {
        return;
    }
    
    [self.refreshView endRefreshing];
    [self.refreshView beginRefreshing];
}

#pragma mark - getter and setter
- (BOOL)isRefreshing
{
    return self.refreshView.state == MLRefreshControlStateRefreshing;
}

- (BOOL)scrollToTopAfterEndRefreshing
{
    return self.refreshView.scrollToTopAfterEndRefreshing;
}

static char refreshViewKey;
static char lastRefreshTimeKey;

- (MLRefreshControlView *)refreshView
{
    return objc_getAssociatedObject(self,&refreshViewKey);
}

- (void)setRefreshView:(MLRefreshControlView *)refreshView
{
    //Remove old
    if (self.refreshView) {
        [self endRefreshing];
        [self.refreshView removeFromSuperview];
    }
    
    static NSString * key = @"refreshView";
    
    [self willChangeValueForKey:key];
    objc_setAssociatedObject(self, &refreshViewKey, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:key];
    
    if (refreshView) {
        [self addSubview:refreshView];
        [self sendSubviewToBack:refreshView];
    }
}

-(NSDate *)lastRefreshTime
{
    return objc_getAssociatedObject(self,&lastRefreshTimeKey);
}

- (void)setLastRefreshTime:(NSDate *)lastRefreshTime
{
    static NSString * key = @"lastRefreshTime";
    
    [self willChangeValueForKey:key];
    objc_setAssociatedObject(self, &lastRefreshTimeKey, lastRefreshTime, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:key];
}


@end
