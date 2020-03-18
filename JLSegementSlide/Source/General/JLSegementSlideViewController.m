//
//  JLSegementSlideViewController.m
//  JLSegementSlide
//
//  Created by Jacklin on 2020/3/16.
//  Copyright © 2020 Jacklin. All rights reserved.
//

#import "JLSegementSlideViewController.h"
#import "JLSegementSlideScrollView.h"
#import "JLSegementSlideHeaderView.h"
#import "JLSegementSlideContentView.h"
#import "JLSegementSlideSwitcherView.h"
#import "JLSegementSlideViewController+Extention.h"
#import "UIView+JLConstraint.h"

@interface JLSegementSlideViewController ()<UIScrollViewDelegate, JLSegementSlideSwitcherViewDelegate, JLSegementSlideContentDelegate> {
    UIScrollView *_childScrollView;
}

@property (nonatomic, strong) JLSegementSlideScrollView *segementSlideScrollView;
@property (nonatomic, strong) JLSegementSlideHeaderView *segementSlideHeaderView;
@property (nonatomic, strong) JLSegementSlideContentView *segementSlideContentView;
@property (nonatomic, strong) JLSegementSlideSwitcherView *segementSlideSwitcherView;

@property (nonatomic, strong) UIView *innerHeaderView;

@property (nonatomic, strong) NSLayoutConstraint *safeAreaTopConstraint;
@property (nonatomic, assign) JLBouncesType innerBouncesType;

@property (nonatomic, assign) BOOL canParentViewScroll;
@property (nonatomic, assign) BOOL canChildViewScroll;

@property (nonatomic, assign) CGFloat lastChildBouncesTranslationY;

@property (nonatomic, strong) NSMutableSet <NSString *> *waitTobeResetContentOffsetY;


@end

@implementation JLSegementSlideViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self layoutSegementSlideScrollView];
}

- (void)dealloc {
    // Need to do
    
    [self.segementSlideScrollView removeObserver:self forKeyPath:@"contentOffset"];
    if (_childScrollView) {
        [_childScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:willClearAllReusableViewControllersNotification
                                                  object:nil];
}

#pragma mark - Public
- (void)reloadData {
    [self setupBounces];
    [self setupHeader];
    [self setupSwitcher];
    [self.waitTobeResetContentOffsetY removeAllObjects];
    [self.segementSlideContentView reloadData];
    [self.segementSlideSwitcherView reloadData];
    [self layoutSegementSlideScrollView];
}

- (void)reloadHeader {
    [self setupHeader];
    [self layoutSegementSlideScrollView];
}

- (void)reloadSwitcher {
    [self setupSwitcher];
    [self.segementSlideSwitcherView reloadData];
    [self layoutSegementSlideScrollView];
}

- (void)reloadBadgeInSwitcher {
    [self.segementSlideSwitcherView reloadBadges];
}

- (void)reloadContent {
    [self.waitTobeResetContentOffsetY removeAllObjects];
    [self.segementSlideContentView reloadData];
}

- (void)scrollToSlideAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.segementSlideSwitcherView selectSwitcherAtIndex:index animated:animated];
}

- (id<JLSegementSlideContentScrollViewDelegate>)dequeueReusableViewControllerAtIndex:(NSInteger)index {
    return [self.segementSlideContentView dequeueReusableViewControllerAtIndex:index];
}

- (JLSegmentSlideSwitcherSharedConfig *)switcherConfig {
    return [JLSegmentSlideSwitcherSharedConfig sharedConfig];
}

- (JLBadgeType)showBadgeInSwitcherAtIndex:(NSInteger)index {
    return JLBadgeTypeNone;
}

- (id<JLSegementSlideContentScrollViewDelegate>)segementSlideContentViewControllerAtIndex:(NSInteger)index {
#if DEBUG
    NSAssert(NO, @"must override this function");
#endif
    return nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView isParent:(BOOL)isParent {
    
}

- (void)didSelectContentViewControllerAtIndex:(NSInteger)index {
    
}

#pragma mark - Private
- (void)p_initializeValues {
    self.innerBouncesType = JLBouncesTypeParent;
    self.canParentViewScroll = YES;
    self.canChildViewScroll = NO;
    self.lastChildBouncesTranslationY = 0;
    self.waitTobeResetContentOffsetY = [[NSMutableSet alloc] init];
}

- (void)setup {
    [self p_initializeValues];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupSegementSlideViews];
    [self setupSegementSlideScrollView];
    [self setupSegementSlideHeaderView];
    [self setupSegementSlideContentView];
    [self setupSegementSlideSwitcherView];
    [self observeScrollViewContentOffset];
    [self observeWillClearAllReusableViewControllersNotification];
}

- (void)setupSegementSlideViews {
    self.segementSlideHeaderView = [[JLSegementSlideHeaderView alloc] init];
    self.segementSlideSwitcherView = [[JLSegementSlideSwitcherView alloc] init];
    self.segementSlideContentView = [[JLSegementSlideContentView alloc] init];
    NSMutableArray *gestureRecognizers = [[NSMutableArray alloc] init];
    if (self.segementSlideSwitcherView.gestureRecognizers) {
        [gestureRecognizers addObjectsFromArray:self.segementSlideSwitcherView.gestureRecognizers];
    }
    if (self.segementSlideContentView.gestureRecognizers) {
        [gestureRecognizers addObjectsFromArray:self.segementSlideContentView.gestureRecognizers];
    }
    
    self.segementSlideScrollView = [[JLSegementSlideScrollView alloc] initWithOtherGestureRecognizers:gestureRecognizers];
}

- (void)setupSegementSlideHeaderView {
    [self.segementSlideScrollView addSubview:self.segementSlideHeaderView];
}

- (void)setupSegementSlideContentView {
    self.segementSlideContentView.delegate = self;
    self.segementSlideContentView.viewController = self;
    [self.segementSlideScrollView addSubview: self.segementSlideContentView];
}

- (void)setupSegementSlideSwitcherView {
    self.segementSlideSwitcherView.delegate = self;
    [self.segementSlideScrollView addSubview: self.segementSlideSwitcherView];
}

- (void)setupSegementSlideScrollView {
    [self.view addSubview:self.segementSlideScrollView];
    [self.segementSlideScrollView constraintToSuperview];
    if (@available(iOS 11.0, *)) {
        self.segementSlideScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.segementSlideScrollView.backgroundColor = [UIColor whiteColor];
    self.segementSlideScrollView.showsHorizontalScrollIndicator = NO;
    self.segementSlideScrollView.showsVerticalScrollIndicator = NO;
    self.segementSlideScrollView.pagingEnabled = NO;
    self.segementSlideScrollView.scrollEnabled = YES;
    self.segementSlideScrollView.delegate = self;
}

- (void)observeScrollViewContentOffset {
    [self.segementSlideScrollView addObserver: self
                                   forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                      context:nil];
}

- (void)observeWillClearAllReusableViewControllersNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willClearAllReusableViewControllers:) name:willClearAllReusableViewControllersNotification object:nil];
}

- (void)setupBounces {
    self.innerBouncesType = self.bouncesType;
    switch (self.innerBouncesType) {
        case JLBouncesTypeParent:
            self.canParentViewScroll = YES;
            self.canChildViewScroll = NO;
            break;
        case  JLBouncesTypeChild:
            self.canParentViewScroll = YES;
            self.canChildViewScroll = YES;
            break;
            
        default:
            break;
    }
}

- (void)setupHeader {
    self.innerHeaderView = self.headerView;
}

- (void)setupSwitcher {
    self.segementSlideSwitcherView.config = self.switcherConfig;
}

- (void)layoutSegementSlideScrollView {
    CGFloat topLayoutLength;
    if (self.edgesForExtendedLayout & UIRectEdgeTop) {
        topLayoutLength = 0;
    } else {
        topLayoutLength = self.topLayoutLength;
    }
    
    self.segementSlideHeaderView.translatesAutoresizingMaskIntoConstraints = NO;
    if (!self.segementSlideHeaderView.topConstraint) {
        self.segementSlideHeaderView.topConstraint = [self.segementSlideHeaderView.topAnchor constraintEqualToAnchor:self.segementSlideScrollView.topAnchor constant:topLayoutLength];
    } else {
        if (self.segementSlideHeaderView.topConstraint.constant != topLayoutLength) {
            self.segementSlideHeaderView.topConstraint.constant = topLayoutLength;
        }
    }
    
    if (!self.segementSlideHeaderView.leadingConstraint) {
        self.segementSlideHeaderView.leadingConstraint = [self.segementSlideHeaderView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    }
    
    if (!self.segementSlideHeaderView.trailingConstraint) {
        self.segementSlideHeaderView.trailingConstraint = [self.segementSlideHeaderView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    }
    [self.segementSlideHeaderView configueWithHeaderView:self.headerView segementSlideContentView:self.segementSlideContentView];
    
    self.segementSlideSwitcherView.translatesAutoresizingMaskIntoConstraints = NO;
    if (!self.segementSlideSwitcherView.topConstraint) {
        NSLayoutConstraint *topConstraint = [self.segementSlideSwitcherView.topAnchor constraintEqualToAnchor:self.segementSlideHeaderView.bottomAnchor];
        topConstraint.priority = UILayoutPriorityRequired - 1;
        self.segementSlideSwitcherView.topConstraint = topConstraint;
    }
    
    if (!self.safeAreaTopConstraint) {
        self.safeAreaTopConstraint.active = NO;
        if (@available(iOS 11, *)) {
            self.safeAreaTopConstraint = [self.segementSlideSwitcherView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor];
        } else {
            self.safeAreaTopConstraint = [self.segementSlideSwitcherView.topAnchor constraintGreaterThanOrEqualToAnchor:self.topLayoutGuide.bottomAnchor];
        }
        self.safeAreaTopConstraint.active = YES;
    }
    
    if (!self.segementSlideSwitcherView.leadingConstraint) {
        self.segementSlideSwitcherView.leadingConstraint = [self.segementSlideSwitcherView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    }
    
    if (!self.segementSlideSwitcherView.trailingConstraint) {
        self.segementSlideSwitcherView.trailingConstraint = [self.segementSlideSwitcherView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    }
    
    if (!self.segementSlideSwitcherView.heightConstraint) {
        self.segementSlideSwitcherView.heightConstraint = [self.segementSlideSwitcherView.heightAnchor constraintEqualToConstant:self.switcherHeight];
    } else {
        if (self.segementSlideSwitcherView.heightConstraint.constant != self.switcherHeight) {
            self.segementSlideSwitcherView.heightConstraint.constant = self.switcherHeight;
        }
    }
    
    self.segementSlideContentView.translatesAutoresizingMaskIntoConstraints = NO;
    if (!self.segementSlideContentView.topConstraint) {
        self.segementSlideContentView.topConstraint = [self.segementSlideContentView.topAnchor constraintEqualToAnchor:self.segementSlideSwitcherView.bottomAnchor];
    }
    if (!self.segementSlideContentView.leadingConstraint) {
        self.segementSlideContentView.leadingConstraint = [self.segementSlideContentView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
    }
    if (!self.segementSlideContentView.trailingConstraint) {
        self.segementSlideContentView.trailingConstraint = [self.segementSlideContentView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    }
    
    if (!self.segementSlideContentView.bottomConstraint) {
        self.segementSlideContentView.bottomConstraint = [self.segementSlideContentView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    }
    
    self.segementSlideHeaderView.layer.zPosition = -3;
    self.segementSlideContentView.layer.zPosition = -2;
    self.segementSlideSwitcherView.layer.zPosition = -1;
    
    [self.segementSlideHeaderView layoutIfNeeded];
    
    CGFloat innerHeaderHeight = self.segementSlideHeaderView.frame.size.height;
    CGSize contentSize = CGSizeMake(self.view.bounds.size.width, topLayoutLength + innerHeaderHeight + self.switcherHeight + self.contentViewHeight + 1);
    if (!CGSizeEqualToSize(self.segementSlideScrollView.contentSize, contentSize)) {
        self.segementSlideScrollView.contentSize = contentSize;
    }
    
}

- (void)resetChildViewControllerContentOffsetY {
    if (self.segementSlideScrollView.contentOffset.y >= self.headerStickyHeight) return;
    NSSet *collection = [self.waitTobeResetContentOffsetY copy];
    for (NSString *indexValue in collection) {
        NSInteger index = [indexValue integerValue];
        UIScrollView *scrollView = [self dequeueReusableViewControllerAtIndex:index].scrollView;
        if ((index != self.currentIndex) && scrollView) {
            [self.waitTobeResetContentOffsetY removeObject:indexValue];
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
        } else {
            continue;
        }
    }
}

#pragma mark - Action
- (void)willClearAllReusableViewControllers:(NSNotification *)notification {
    JLSegementSlideViewController *obj = (JLSegementSlideViewController *)notification.object;
    if (obj && obj == self) {
        NSLog(@"remove childKeyValueObservation");
        if (_childScrollView) {
            [_childScrollView removeObserver:self forKeyPath:@"contentOffset"];
        }
        _childScrollView = nil;
    }
}

#pragma mark - Getters
- (UIScrollView *)slideScrollView {
    return self.segementSlideScrollView;
}

- (UIView *)slideSwitcherView {
    return self.segementSlideSwitcherView;
}

- (UIView *)slideContentView {
    return self.segementSlideContentView;
}

- (CGFloat)headerStickyHeight {
    CGFloat height = roundf(self.segementSlideHeaderView.frame.size.height);
    if (self.edgesForExtendedLayout & UIRectEdgeTop) {
        return height - self.topLayoutLength;
    }
    return height;
}

- (CGFloat)contentViewHeight {
    return self.view.bounds.size.height - self.topLayoutLength - self.switcherHeight;
}

- (NSInteger)currentIndex {
    return self.segementSlideSwitcherView.selectedIndex;
}

- (id<JLSegementSlideContentScrollViewDelegate>)currentSegementSlideContentViewController {
    if (self.currentIndex == NSIntegerMin) return nil;
    return [self.segementSlideContentView dequeueReusableViewControllerAtIndex:self.currentIndex];
}

- (JLBouncesType)bouncesType {
    return JLBouncesTypeParent;
}

- (UIView *)headerView {
    if (self.edgesForExtendedLayout & UIRectEdgeTop) {
#if DEBUG
        NSAssert(NO, @"must override this variable");
#endif
        return nil;
    } else {
        return nil;
    }
}

- (CGFloat)switcherHeight {
    return 44;
}

- (NSArray<NSString *> *)titlesInSwitcher {
#if DEBUG
    NSAssert(NO, @"must override this variable");
#endif
    return @[];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        if (object == self.segementSlideScrollView) {
            CGPoint newPoint = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
            CGPoint oldPoint = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
            if (!CGPointEqualToPoint(newPoint, oldPoint)) {
                UIScrollView *scrollView = (UIScrollView *)object;
                [self parentScrollViewDidScroll:scrollView];
            }
        } else {
            CGPoint newPoint = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
            CGPoint oldPoint = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
            if (!CGPointEqualToPoint(newPoint, oldPoint)) {
                UIScrollView *scrollView = (UIScrollView *)object;
                [self childScrollViewDidScroll:scrollView];
            }
        }
        
    }
}

#pragma mark - Scroll
- (void)parentScrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat parentContentOffsetY = self.segementSlideScrollView.contentOffset.y;
    switch (self.innerBouncesType) {
        case JLBouncesTypeParent:
            if (!self.canParentViewScroll) {
                [self.segementSlideScrollView setContentOffset:CGPointMake(self.segementSlideScrollView.contentOffset.x, self.headerStickyHeight)];
                self.canChildViewScroll = YES;
                [self scrollViewDidScroll:scrollView isParent:YES];
                return;
            } else if (parentContentOffsetY >= self.headerStickyHeight) {
                [self.segementSlideScrollView setContentOffset:CGPointMake(self.segementSlideScrollView.contentOffset.x, self.headerStickyHeight)];
                self.canParentViewScroll = NO;
                self.canChildViewScroll = YES;
                [self scrollViewDidScroll:scrollView isParent:YES];
                return;
            }
            break;
            
        case JLBouncesTypeChild: {
            CGFloat childBouncesTranslationY = - roundf([scrollView.panGestureRecognizer translationInView:scrollView].y);
            if (!self.canParentViewScroll) {
                [self.segementSlideScrollView setContentOffset:CGPointMake(self.segementSlideScrollView.contentOffset.x, self.headerStickyHeight)];
                self.canChildViewScroll = YES;
                
                self.lastChildBouncesTranslationY = childBouncesTranslationY;
                [self scrollViewDidScroll:scrollView isParent:YES];
                return;
            } else if (parentContentOffsetY >= self.headerStickyHeight) {
                [self.segementSlideScrollView setContentOffset:CGPointMake(self.segementSlideScrollView.contentOffset.x, self.headerStickyHeight)];
                self.canParentViewScroll = NO;
                self.canChildViewScroll = YES;
                
                self.lastChildBouncesTranslationY = childBouncesTranslationY;
                [self scrollViewDidScroll:scrollView isParent:YES];
                return;
            } else if (parentContentOffsetY <= 0) {
                [self.segementSlideScrollView setContentOffset:CGPointMake(self.segementSlideScrollView.contentOffset.x, 0)];
                self.canChildViewScroll = YES;
            } else {
                UIScrollView *childScrollView = [self currentSegementSlideContentViewController].scrollView;
                if (!childScrollView) {
                    self.lastChildBouncesTranslationY = childBouncesTranslationY;
                    [self scrollViewDidScroll:scrollView isParent:YES];
                    return;
                }
                if (childScrollView.contentOffset.y < 0) {
                    if (childBouncesTranslationY > self.lastChildBouncesTranslationY) {
                        [self.segementSlideScrollView setContentOffset:CGPointMake(self.segementSlideScrollView.contentOffset.x, 0)];
                        self.canChildViewScroll = YES;
                    } else {
                        self.canChildViewScroll = NO;
                    }
                } else {
                    self.canChildViewScroll = NO;
                }
            }
            self.lastChildBouncesTranslationY = childBouncesTranslationY;
        }
            break;
            
        default:
            break;
    }

    [self resetChildViewControllerContentOffsetY];
    [self scrollViewDidScroll:scrollView isParent:YES];
}

- (void)childScrollViewDidScroll:(UIScrollView *)childScrollView {
    CGFloat parentContentOffsetY = self.segementSlideScrollView.contentOffset.y;
    CGFloat childContentOffsetY = childScrollView.contentOffset.y;
    switch (self.innerBouncesType) {
        case JLBouncesTypeParent:
            if (!self.canChildViewScroll) {
                [childScrollView setContentOffset:CGPointMake(childScrollView.contentOffset.x, 0)];
            } else if(childContentOffsetY <= 0) {
                self.canChildViewScroll = NO;
                self.canParentViewScroll = YES;
            }
            break;
            
        case JLBouncesTypeChild: {
            if (!self.canChildViewScroll) {
                [childScrollView setContentOffset:CGPointMake(childScrollView.contentOffset.x, 0)];
            } else if(childContentOffsetY <= 0) {
                if (parentContentOffsetY <= 0) {
                    self.canChildViewScroll = YES;
                }
                self.canParentViewScroll = YES;
            } else {
                if (parentContentOffsetY > 0
                    && parentContentOffsetY < self.headerStickyHeight) {
                    self.canChildViewScroll = NO;
                }
            }
        }
            break;
            
        default:
            break;
    }
    [self scrollViewDidScroll:childScrollView isParent:NO];
}

#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    id <JLSegementSlideContentScrollViewDelegate> contentViewController = [self currentSegementSlideContentViewController];
    if (!contentViewController) return YES;
    if (!contentViewController.scrollView) return YES;
    [contentViewController.scrollView setContentOffset:CGPointMake(contentViewController.scrollView.contentOffset.x, 0)];
    return YES;
}

#pragma mark - JLSegementSlideSwitcherViewDelegate
- (NSArray *)titlesInSegementSlideSwitcherView {
    return self.titlesInSwitcher;
}

- (void)segementSlideSwitcherView:(JLSegementSlideSwitcherView *)segementSlideSwitcherView didSelectAtIndex:(NSInteger)index animated:(BOOL)animated {
    if (self.segementSlideContentView.selectedIndex != index) {
        [self.segementSlideContentView scrollToSlideAtIndex:index animated:animated];
    }
}

- (JLBadgeType)segementSlideSwitcherView:(JLSegementSlideSwitcherView *)segementSlideSwitcherView showBadgeAtIndex:(NSInteger)index {
    return [self showBadgeInSwitcherAtIndex:index];
}

#pragma mark - JLSegementSlideContentDelegate
- (NSInteger)segementSlideContentScrollViewCount {
    return self.titlesInSwitcher.count;
}

- (id<JLSegementSlideContentScrollViewDelegate>)segementSlideContentScrollViewAtIndex:(NSInteger)index {
    return [self segementSlideContentViewControllerAtIndex:index];
}

- (void)segementSlideContentView:(JLSegementSlideContentView *)segementSlideContentView didSelectAtIndex:(NSInteger)index animated:(BOOL)animated {
    [self.waitTobeResetContentOffsetY addObject:@(index).stringValue];
    if (self.segementSlideSwitcherView.selectedIndex != index) {
        [self.segementSlideSwitcherView selectSwitcherAtIndex:index animated:animated];
    }

    if (_childScrollView) {
        [_childScrollView removeObserver:self forKeyPath:@"contentOffset"];
    }
    _childScrollView = nil;
    id <JLSegementSlideContentScrollViewDelegate> childViewController = [self.segementSlideContentView dequeueReusableViewControllerAtIndex:index];
    if (!childViewController) return;
    
    if (!childViewController.scrollView) {
        [self didSelectContentViewControllerAtIndex:index];
        return;
    }
    
    [childViewController.scrollView addObserver:self
                                     forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                        context:nil];
    _childScrollView = childViewController.scrollView;
    
    [self didSelectContentViewControllerAtIndex:index];
}

@end
