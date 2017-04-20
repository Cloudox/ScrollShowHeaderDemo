# ScrollShowHeaderDemo
上下滑动列表时展现和隐藏顶部视图的demo

有帮助的话请右上角不吝star鼓励~

# 引
项目中需要一个效果：下滚列表时顶部的自定义视图不移动，上移时隐藏顶部视图，提高列表的展现范围。在此基础上海加了一个隐藏列表时的动态渐入渐出效果，如下：

![](https://github.com/Cloudox/ScrollShowHeaderDemo/blob/master/demo.gif)

# 实现
实现的要点是，顶部的视图要随着列表的滚动而滚动，且列表最上是可以滚动到屏幕顶部的，最下就是滚动到一个固定的位置就不再往下滚动了，至于渐变效果只要能控制滚动自然也能控制随着滚动去改变alpha值了。

关键就在于顶部视图不是简单的放在列表之上，也不是简单的作为列表的headerview。

顶部视图确实是直接作为self.view的子视图来添加的，但是列表的范围同样是覆盖整个屏幕，那么为了避免列表内容被顶部视图盖住，就要设置列表的contentoffset值。

要注意的是，设置contentoffset值必须在添加列表到self.view之后，否则无效，设置之后可能你会发现刚开始是好的，一点击列表内容就回到顶部了，别慌，那是之后会解决的问题：

```objective-c
	self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];// 去除多余的列表线条
    [self.view addSubview:self.tableView];
    [self.tableView setContentOffset:CGPointMake(0, -200)];
```

我们的顶部视图要跟随列表滚动，就必须获知列表的滚动效果，这里我们在自定义的顶部视图类中加一个UIScrollView属性，在初始化的时候就将我们的列表赋给这个属性（UITableView是UIScrollView的子类）：

```objective-c
    OXScrollHeaderView *scrollHeader = [[OXScrollHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
    scrollHeader.headerScrollView = self.tableView;
    [self.view addSubview:scrollHeader];
```

可以看到顶部视图是直接添加到self.view上的。

视图的内容可以自己定义，我就只放了一张图片。

对于滚动的跟随，我们采用KVO键值观察（可以查看[这篇博客](http://blog.csdn.net/Cloudox_/article/details/53172493)来了解）来做。这里我们利用UIView的一个Delegate：willMoveToSuperview:，它会在我们的视图被添加到父视图上时被调用，在这个代理方法中我们就添加对列表的contentoffset值的观察，每次这个值变化时就调用处理方法：

```objective-c
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
```

这里我们设置了一下contentInset，它是是scrollview的contentview的顶点相对于scrollview的位置，四个参数分别代表距离上，左，下，右边的像素长度。这样就不会一点列表就移动到被遮挡了。

在处理方法中我们要做两件事，第一件事是让顶部视图的高度随着列表移动而移动，但是要控制列表最高移动到的位置TOP和最低移动到的位置BOTTOM，这其实就是顶部视图的低端对应的Y值。

第二件事是让顶部视图随着移动而渐变，当移动到最高时彻底透明，移动到最低时不透明，这个alpha值也是根据移动的值来计算的：

```objective-c
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
```

这里我的工程中顶部视图高度为200，所以TOP设为0，BOTTOM设为200。

更多内容可以查看[我的博客](http://blog.csdn.net/Cloudox_)
