//
//  OXScrollHeaderView.m
//  ScrollShowHeaderDemo
//
//  Created by csdc-iMac on 2017/4/20.
//  Copyright © 2017年 Cloudox. All rights reserved.
//

#import "OXScrollHeaderView.h"

#define TOP 0
#define BOTTOM 200

@implementation OXScrollHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bgImg.image = [UIImage imageNamed:@"chonglang.jpg"];
        [self addSubview:bgImg];
    }
    return self;
}

#pragma mark - UIView Delegate
// 在被添加到界面上时就添加对contentoffset的观察
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [self.headerScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:Nil];
    self.headerScrollView.contentInset = UIEdgeInsetsMake(BOTTOM, 0, 0, 0);
}

#pragma mark - KVO
// 对contentoffset的键值观察
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGPoint newOffset = [change[@"new"] CGPointValue];
    
//    NSLog(@"%f, %f", newOffset.x, newOffset.y);
    
    [self updateSubViewsWithScrollOffset:newOffset];
}

- (void)updateSubViewsWithScrollOffset:(CGPoint)newOffset {
    
//    NSLog(@"scrollview inset top:%f", self.headerScrollView.contentInset.top);
//    NSLog(@"new offset before:%f", newOffset.y);
//    NSLog(@"newOffset : %f", newOffset.y);
    
    float startChangeOffset = - self.headerScrollView.contentInset.top;// -BOTTOM
    
    // 往下拉的时候是否超过BOTTOM，超过的话保持BOTTOM不变，往上滑的话是否低于TOP，是的话保持TOP，也就是最多滑到BOTTOM，最少有TOP
    newOffset = CGPointMake(newOffset.x, newOffset.y < startChangeOffset ? startChangeOffset : (newOffset.y > -TOP ? -TOP : newOffset.y));
//    NSLog(@"new offset after:%f", newOffset.y);
    
    // 头部视图的y坐标
    float newY = - newOffset.y - BOTTOM;//self.headerScrollView.contentInset.top;
    // 随着滑动将头部视图往上同步移动
    self.frame = CGRectMake(0, newY, self.frame.size.width, self.frame.size.height);
    
    // 算alpha，保证在滑到BOTTOM时为1，TOP时为0
    float d = -TOP - startChangeOffset;
    float alpha = 1 - (newOffset.y - startChangeOffset) / d;
    
    self.alpha = alpha;
    
    
//    NSLog(@"current offset: %f", newOffset.y);
    
}

@end
