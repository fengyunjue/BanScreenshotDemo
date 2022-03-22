//
//  MAAutolayout.m
//  MAAutolayout
//
//  Created by admin on 2017/11/28.
//

#import "MAAutoLayout.h"
#import <objc/runtime.h>

@interface MAAutoLayoutMaker()

@property (nullable, nonatomic,weak) UIView *firstItem;
@property (nonatomic, assign) NSLayoutAttribute firstAttribute;
@property (nullable, nonatomic,weak) id secondItem;
@property (nonatomic, assign) NSLayoutAttribute secondAttribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) CGFloat multiplierValue;
@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign) UILayoutPriority priorityValue;

@property (nonatomic,strong) NSLayoutConstraint *layoutConstraint;

- (void)deactivate;

- (instancetype)createNewLayoutMaker;

@end

@interface MAAutoLayout()

@property (nonatomic,strong) NSMutableArray<MAAutoLayoutMaker *> *layoutMakers;
@property (nonatomic,weak) id view;

@property (nonatomic, strong) NSArray *zeroLayoutMakers;

@end

@implementation MAAutoLayout

- (id)initWithView:(UIView *)view{
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    self.layoutMakers = [NSMutableArray array];
    return self;
}

#pragma mark - standard Attributes
- (MAAutoLayoutMaker *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (MAAutoLayoutMaker *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (MAAutoLayoutMaker *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (MAAutoLayoutMaker *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (MAAutoLayoutMaker *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (MAAutoLayoutMaker *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (MAAutoLayoutMaker *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (MAAutoLayoutMaker *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (MAAutoLayoutMaker *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (MAAutoLayoutMaker *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (MAAutoLayoutMaker *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

// 便利方法
-(MAAutoLayoutMakers *)leftRight {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight)]];
}
-(MAAutoLayoutMakers *)topBottom {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
}
-(MAAutoLayoutMakers *)size {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeWidth),@(NSLayoutAttributeHeight)]];
}
-(MAAutoLayoutMakers *)center {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeCenterX),@(NSLayoutAttributeCenterY)]];
}
- (MAAutoLayoutMakers *)topLeft{
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeLeft)]];
}
-(MAAutoLayoutMakers *)topRight {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeRight)]];
}
-(MAAutoLayoutMakers *)bottomLeft {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeLeft)]];
    
}
-(MAAutoLayoutMakers *)bottomRight {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeBottom),@(NSLayoutAttributeRight)]];
    
}
-(MAAutoLayoutMakers *)edge {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight),@(NSLayoutAttributeBottom)]];
}
-(MAAutoLayoutMakers *)topLeftRight {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeTop),@(NSLayoutAttributeLeft),@(NSLayoutAttributeRight)]];
}
-(MAAutoLayoutMakers *)bottomLeftRight {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeBottom),@(NSLayoutAttributeRight)]];
}
-(MAAutoLayoutMakers *)leftTopBottom {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeLeft),@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
}
-(MAAutoLayoutMakers *)rightTopBottom {
    return [self addConstraintWithLayoutAttributes:@[@(NSLayoutAttributeRight),@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom)]];
}

- (MAAutoLayoutMaker *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    MAAutoLayoutMaker *maker = [[MAAutoLayoutMaker alloc] initWithFirstItem:self.view firstAttribute:layoutAttribute];
    [self.layoutMakers addObject:maker];
    return maker;
}

- (MAAutoLayoutMakers *)addConstraintWithLayoutAttributes:(NSArray *)attributes {
    MAAutoLayoutMakers *maker = [[MAAutoLayoutMakers alloc] initWithFirstItem:self.view attributes:attributes];
    [self.layoutMakers addObjectsFromArray:maker.layoutMarkers];
    return maker;
}

- (void)activeAll {
    for (MAAutoLayoutMaker *maker in self.layoutMakers) {
        if (!maker.layoutConstraint.isActive) {
            [maker active];
        }
    }
}

- (void)activeNew {
    for (MAAutoLayoutMaker *maker in self.layoutMakers) {
        if (maker.layoutConstraint == nil) {
            [maker active];
        }
    }
}

- (void)deactivate{
    [self.layoutMakers makeObjectsPerformSelector:@selector(deactivate)];
    [self.layoutMakers removeAllObjects];
}

- (void)setLayoutZeroWithZeroType:(MAAutoLayoutZeroType)zeroType {
    [self.zeroLayoutMakers makeObjectsPerformSelector:@selector(deactivate)];
    self.zeroLayoutMakers = nil;
    
    BOOL hasHeight = NO;
    BOOL hasWidth = NO;
    NSMutableArray *zeroLayoutMakers = [NSMutableArray array];
    for (MAAutoLayoutMaker *maker in self.layoutMakers) {
        maker.layoutConstraint.active = NO;
        BOOL shouldZero = NO;
        if ((zeroType&MAAutoLayoutZeroTypeTop) && maker.firstAttribute == NSLayoutAttributeTop) {
            shouldZero = YES;
        }else if ((zeroType&MAAutoLayoutZeroTypeLeft) && maker.firstAttribute == NSLayoutAttributeLeft) {
            shouldZero = YES;
        }else if ((zeroType&MAAutoLayoutZeroTypeRight) && maker.firstAttribute == NSLayoutAttributeRight) {
            shouldZero = YES;
        }else if ((zeroType&MAAutoLayoutZeroTypeBottom) && maker.firstAttribute == NSLayoutAttributeBottom) {
            shouldZero = YES;
        }else if ((zeroType&MAAutoLayoutZeroTypeHeight) && maker.firstAttribute == NSLayoutAttributeHeight) {
            shouldZero = YES;
            hasHeight = YES;
        }else if ((zeroType&MAAutoLayoutZeroTypeWidth) && maker.firstAttribute == NSLayoutAttributeWidth) {
            shouldZero = YES;
            hasWidth = YES;
        }
        MAAutoLayoutMaker *newMaker = [maker createNewLayoutMaker];
        if (shouldZero) {
            newMaker.constant = 0;
        }
        [newMaker active];
        [zeroLayoutMakers addObject:newMaker];
    }
    if ((zeroType&MAAutoLayoutZeroTypeHeight) && hasHeight == NO) {
        MAAutoLayoutMaker *newMaker = [[MAAutoLayoutMaker alloc] initWithFirstItem:self.view firstAttribute:NSLayoutAttributeHeight].ma_equal(0);
        [newMaker active];

        [zeroLayoutMakers addObject:newMaker];
    }
    if ((zeroType&MAAutoLayoutZeroTypeWidth) && hasWidth == NO) {
        MAAutoLayoutMaker *newMaker = [[MAAutoLayoutMaker alloc] initWithFirstItem:self.view firstAttribute:NSLayoutAttributeWidth].ma_equal(0);
        [newMaker active];
        [zeroLayoutMakers addObject:newMaker];
    }
    self.zeroLayoutMakers = zeroLayoutMakers;
}

- (void)restoreLayout {
    [self.zeroLayoutMakers makeObjectsPerformSelector:@selector(deactivate)];
    self.zeroLayoutMakers = nil;
    for (MAAutoLayoutMaker *maker in self.layoutMakers) {
        maker.layoutConstraint.active = YES;
    }
}

@end

@implementation UIView (MAAutoLayout)

+ (void)load {
    [UIView swizzleMethod:@selector(setHidden:) withMethod:@selector(ma_setHidden:)];
}

- (void)ma_setHidden:(BOOL)hidden {
    BOOL isChanged = self.hidden != hidden;
    [self ma_setHidden:hidden];
    MAAutoLayout *autolayout = objc_getAssociatedObject(self, &kInstalledMAAutoLayoutKey);
    if (isChanged && autolayout.zeroTypeWhenHidden) {
        [self reloadLayoutZeroWithZeroType:autolayout.zeroTypeWhenHidden];
    }
}

static char kInstalledMAAutoLayoutKey;

- (MAAutoLayout *)ma_layout {
    MAAutoLayout *autolayout = objc_getAssociatedObject(self, &kInstalledMAAutoLayoutKey);
    if (!autolayout) {
        autolayout = [[MAAutoLayout alloc] initWithView:self];
        objc_setAssociatedObject(self, &kInstalledMAAutoLayoutKey, autolayout, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return autolayout;
}

- (void)ma_makeConstraints:(void (^)(MAAutoLayout *))make{
    make(self.ma_layout);
    [self.ma_layout activeNew];
}

- (void)ma_remakeConstraints:(void (^)(MAAutoLayout * _Nonnull))make{
    [self.ma_layout deactivate];
    [self ma_makeConstraints:make];
}

- (void)ma_updateConstraints:(void (^)(MAAutoLayout * _Nonnull))make{
    MAAutoLayout *layout = [[MAAutoLayout alloc] initWithView:self];
    make(layout);
    NSMutableArray *removeArray = [NSMutableArray array];
    for (MAAutoLayoutMaker *newMaker in layout.layoutMakers) {
        for (MAAutoLayoutMaker *oldMaker in self.ma_layout.layoutMakers) {
            if (newMaker.firstAttribute == oldMaker.firstAttribute) {
                [oldMaker deactivate];
                [removeArray addObject:oldMaker];
            }
        }
    }
    [layout activeNew];
    [self.ma_layout.layoutMakers removeObjectsInArray:removeArray];
    [self.ma_layout.layoutMakers addObjectsFromArray:layout.layoutMakers];
}

- (void)ma_removeConstraints{
    [self.ma_layout deactivate];
}

- (MAAutoLayoutMaker *)ma_layoutMakerWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NSArray <MAAutoLayoutMaker *>*makers = self.ma_layout.layoutMakers;
    for (MAAutoLayoutMaker *maker in makers) {
        if (maker.layoutConstraint.firstAttribute == layoutAttribute) {
            return maker;
        }
    }
    return nil;
}

- (void)reloadLayoutZeroWithZeroType:(MAAutoLayoutZeroType)zeroType {
    if (self.hidden) {
        [self.ma_layout setLayoutZeroWithZeroType:zeroType];
    }else{
        [self.ma_layout restoreLayout];
    }
}

- (MAViewAttribute *)ma_left{
    return [self ma_viewAttribute:NSLayoutAttributeLeft];
}

- (MAViewAttribute *)ma_top{
    return [self ma_viewAttribute:NSLayoutAttributeTop];
}

- (MAViewAttribute *)ma_right{
    return [self ma_viewAttribute:NSLayoutAttributeRight];
}

- (MAViewAttribute *)ma_bottom{
    return [self ma_viewAttribute:NSLayoutAttributeBottom];
}

- (MAViewAttribute *)ma_leading{
    return [self ma_viewAttribute:NSLayoutAttributeLeading];
}

- (MAViewAttribute *)ma_trailing{
    return [self ma_viewAttribute:NSLayoutAttributeTrailing];
}

- (MAViewAttribute *)ma_width{
    return [self ma_viewAttribute:NSLayoutAttributeWidth];
}

- (MAViewAttribute *)ma_height{
    return [self ma_viewAttribute:NSLayoutAttributeHeight];
}

- (MAViewAttribute *)ma_centerX{
    return [self ma_viewAttribute:NSLayoutAttributeCenterX];
}

- (MAViewAttribute *)ma_centerY{
    return [self ma_viewAttribute:NSLayoutAttributeCenterY];
}

- (MAViewAttribute *)ma_baseline{
    return [self ma_viewAttribute:NSLayoutAttributeBaseline];
}

#pragma mark - iOS11 safeArea
- (MAViewAttribute *)ma_safeAreaLayoutGuideTop{
    return [self ma_safeAreaViewAttribute:NSLayoutAttributeTop];
}

- (MAViewAttribute *)ma_safeAreaLayoutGuideBottom{
    return [self ma_safeAreaViewAttribute:NSLayoutAttributeBottom];
}

- (MAViewAttribute *)ma_safeAreaLayoutGuideLeft{
    return [self ma_safeAreaViewAttribute:NSLayoutAttributeLeft];
}

- (MAViewAttribute *)ma_safeAreaLayoutGuideRight{
    return [self ma_safeAreaViewAttribute:NSLayoutAttributeRight];
}

#pragma mark - private
- (MAViewAttribute *)ma_viewAttribute:(NSLayoutAttribute)layoutAttribute {
    return [[MAViewAttribute alloc] initWithItem:self layoutAttribute:layoutAttribute];
}

- (MAViewAttribute *)ma_safeAreaViewAttribute:(NSLayoutAttribute)layoutAttribute {
    id item = self;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        item = self.safeAreaLayoutGuide;
    }
#endif
    return [[MAViewAttribute alloc] initWithItem:item layoutAttribute:layoutAttribute];
}

+(BOOL)swizzleMethod:(SEL)originalSEL withMethod:(SEL)alternateSEL{
    //获取原始方法
    Method originalMethod = class_getInstanceMethod(self, originalSEL);
    //当原始方法不存在时，直接返回NO，表示swizzling失败
    if (!originalMethod) {
        return NO;
    }
    //获取要交换的方法
    Method alternateMethod = class_getInstanceMethod(self, alternateSEL);
    //当需要交换方法不存在时，直接返回NO，表示swizzling失败
    if (!alternateMethod) {
        return NO;
    }
    //交换两个方法的实现
    method_exchangeImplementations(originalMethod, alternateMethod);
    //返回YES，表示swizzling成功
    return YES;
}

@end

@implementation UIViewController (MAAutoLayout)

- (MAViewAttribute *)ma_topLayoutGuide{
    return [self ma_topLayoutGuideBottom];
}

- (MAViewAttribute *)ma_bottomLayoutGuide{
    return [self ma_bottomLayoutGuideTop];
}

- (MAViewAttribute *)ma_topLayoutGuideTop{
    return [[MAViewAttribute alloc] initWithItem:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}

- (MAViewAttribute *)ma_topLayoutGuideBottom{
    return [[MAViewAttribute alloc] initWithItem:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (MAViewAttribute *)ma_bottomLayoutGuideTop{
    return [[MAViewAttribute alloc] initWithItem:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}

- (MAViewAttribute *)ma_bottomLayoutGuideBottom{
    return [[MAViewAttribute alloc] initWithItem:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (MAViewAttribute *)ma_safeAreaTopLayoutGuide{
    id item = self.topLayoutGuide;
    NSLayoutAttribute attribute = NSLayoutAttributeBottom;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        item = self.view.safeAreaLayoutGuide;
        attribute = NSLayoutAttributeTop;
    }
#endif
    return [[MAViewAttribute alloc] initWithItem:item layoutAttribute:attribute];
}

- (MAViewAttribute *)ma_safeAreaBottomLayoutGuide{
    id item = self.bottomLayoutGuide;
    NSLayoutAttribute attribute = NSLayoutAttributeTop;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        item = self.view.safeAreaLayoutGuide;
        attribute = NSLayoutAttributeBottom;
    }
#endif
    return [[MAViewAttribute alloc] initWithItem:item layoutAttribute:attribute];
}

@end


@implementation MAAutoLayoutMaker

- (instancetype)initWithFirstItem:(UIView *)firstItem firstAttribute:(NSLayoutAttribute)firstAttribute{
    self = [super init];
    if (!self) return nil;
    
    self.firstItem = firstItem;
    self.firstAttribute = firstAttribute;
    self.secondItem = nil;
    self.secondAttribute = NSLayoutAttributeNotAnAttribute;
    self.multiplierValue = 1.0;
    self.constant = 0;
    self.priorityValue = UILayoutPriorityRequired;
    
    return self;
}

- (instancetype)createNewLayoutMaker {
    MAAutoLayoutMaker *newMaker = [[MAAutoLayoutMaker alloc] initWithFirstItem:self.firstItem firstAttribute:self.firstAttribute];
    newMaker.secondItem = self.secondItem;
    newMaker.secondAttribute = self.secondAttribute;
    newMaker.relation = self.relation;
    newMaker.multiplierValue = self.multiplierValue;
    newMaker.constant = self.constant;
    newMaker.priorityValue = self.priorityValue;
    return newMaker;
}

- (MAAutoLayoutMaker *(^)(CGFloat))offset{
    return ^id(CGFloat offset){
        self.constant = offset;
        return self;
    };
}
- (MAAutoLayoutMaker *)offset:(CGFloat)offset{
    return self.offset(offset);
}

- (MAAutoLayoutMaker * _Nonnull (^)(id _Nonnull))equalTo{
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}
- (MAAutoLayoutMaker *)equalTo:(NSObject *)attr{
    return self.equalTo(attr);
}

- (MAAutoLayoutMaker * _Nonnull (^)(id _Nonnull))greaterThanOrEqualTo{
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}
-(MAAutoLayoutMaker *)greaterThanOrEqualTo:(NSObject *)attr{
    return self.greaterThanOrEqualTo(attr);
}

- (MAAutoLayoutMaker * _Nonnull (^)(id _Nonnull))lessThanOrEqualTo{
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}
-(MAAutoLayoutMaker *)lessThanOrEqualTo:(NSObject *)attr{
    return self.lessThanOrEqualTo(attr);
}

- (MAAutoLayoutMaker * _Nonnull (^)(void))equalToSuperView{
    return ^id() {
        return self.equalToWithRelation(self.firstItem.superview, NSLayoutRelationEqual);
    };
}
- (MAAutoLayoutMaker * _Nonnull (^)(void))greaterThanOrEqualToSuperView{
    return ^id() {
        return self.equalToWithRelation(self.firstItem.superview, NSLayoutRelationGreaterThanOrEqual);
    };
}
- (MAAutoLayoutMaker * _Nonnull (^)(void))lessThanOrEqualToSuperView{
    return ^id() {
        return self.equalToWithRelation(self.firstItem.superview, NSLayoutRelationLessThanOrEqual);
    };
}


- (MAAutoLayoutMaker * _Nonnull (^)(CGFloat))ma_equal{
    return ^id(CGFloat constant) {
        return self.equalToWithRelation(@(constant), NSLayoutRelationEqual);
    };
}
-(MAAutoLayoutMaker *)ma_equal:(CGFloat)constant{
    return self.ma_equal(constant);
}

- (MAAutoLayoutMaker * _Nonnull (^)(CGFloat))ma_greaterThanOrEqual{
    return ^id(CGFloat constant) {
        return self.equalToWithRelation(@(constant), NSLayoutRelationGreaterThanOrEqual);
    };
}
-(MAAutoLayoutMaker *)ma_greaterThanOrEqual:(CGFloat)constant{
    return self.ma_greaterThanOrEqual(constant);
}

- (MAAutoLayoutMaker * _Nonnull (^)(CGFloat))ma_lessThanOrEqual{
    return ^id(CGFloat constant) {
        return self.equalToWithRelation(@(constant), NSLayoutRelationLessThanOrEqual);
    };
}
-(MAAutoLayoutMaker *)ma_lessThanOrEqual:(CGFloat)constant{
    return self.ma_lessThanOrEqual(constant);
}

- (MAAutoLayoutMaker * _Nonnull (^)(UILayoutPriority))priority{
    return ^(UILayoutPriority priority) {
        self.priorityValue = priority;
        return self;
    };
}
-(MAAutoLayoutMaker *)priority:(UILayoutPriority)priority{
    return self.priority(priority);
}

- (MAAutoLayoutMaker * _Nonnull (^)(CGFloat))multiplier{
    return ^(CGFloat multiplier) {
        self.multiplierValue = multiplier;
        return self;
    };
}
-(MAAutoLayoutMaker *)multiplier:(CGFloat)multiplier{
    return self.multiplier(multiplier);
}

- (NSLayoutConstraint *)active {
    if (self.layoutConstraint) {
        self.layoutConstraint.active = NO;
    }
    if (self.firstItem) {
        self.layoutConstraint = [NSLayoutConstraint constraintWithItem:self.firstItem attribute:self.firstAttribute relatedBy:self.relation toItem:self.secondItem attribute:self.secondAttribute multiplier:self.multiplierValue constant:self.constant];
        self.layoutConstraint.priority = self.priorityValue;
        self.layoutConstraint.active = YES;
    }
    return self.layoutConstraint;
}

- (void)deactivate{
    [self.layoutConstraint setActive:NO];
    self.layoutConstraint = nil;
}

#pragma mark private
- (MAAutoLayoutMaker * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        self.relation = relation;
        if ([attribute isKindOfClass:[UIView class]]) {
            self.secondItem = attribute;
            self.secondAttribute = self.firstAttribute;
        }else if ([attribute isKindOfClass:[MAViewAttribute class]]){
            self.secondItem = ((MAViewAttribute *)attribute).item;
            self.secondAttribute = ((MAViewAttribute *)attribute).layoutAttribute;
        }else if ([attribute isKindOfClass:[NSNumber class]]){
            self.secondItem = nil;
            self.secondAttribute = NSLayoutAttributeNotAnAttribute;
            self.constant = ((NSNumber *)attribute).floatValue;
        }else{
            NSAssert(attribute, @"格式不正确,必须是UIView或MAAutoLayoutMaker或NSNumber");
        }
        self.relation = relation;
        return self;
    };
}

@end


@interface MAAutoLayoutMakers()

@property (nullable, nonatomic,weak) UIView *firstItem;
@property (nullable, nonatomic,weak) id secondItem;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) UIEdgeInsets  insetsValue;
@property (nonatomic, assign) UILayoutPriority priorityValue;

@property (nonatomic,strong) NSArray <MAAutoLayoutMaker *>*layoutMarkers;

@end

@implementation MAAutoLayoutMakers

- (instancetype)initWithFirstItem:(UIView *)firstItem attributes:(NSArray *)attributes {
    self = [super init];
    if (!self) return nil;
    
    self.firstItem = firstItem;
    self.secondItem = nil;
    self.insetsValue = UIEdgeInsetsZero;
    self.priorityValue = UILayoutPriorityRequired;
    NSMutableArray *makers = [NSMutableArray array];
    for (NSNumber *attribute in attributes) {
        MAAutoLayoutMaker *maker = [[MAAutoLayoutMaker alloc]initWithFirstItem:self.firstItem firstAttribute:attribute.integerValue];
        maker.secondAttribute = attribute.integerValue;
        maker.multiplierValue = 1.0f;
        [makers addObject:maker];
    }
    self.layoutMarkers = makers;
    
    return self;
}

- (MAAutoLayoutMakers *(^)(CGFloat))offsets{
    return ^id(CGFloat offsets){
        self.insetsValue = UIEdgeInsetsMake(offsets, offsets, -offsets, -offsets);
        return self;
    };
}
- (MAAutoLayoutMakers *)offsets:(CGFloat)offsets{
    return self.offsets(offsets);
}

- (MAAutoLayoutMakers * _Nonnull (^)(UIEdgeInsets))insets{
    return ^id(UIEdgeInsets insets){
        self.insetsValue = insets;
        return self;
    };
}
- (MAAutoLayoutMakers *)insets:(UIEdgeInsets)insets{
    return self.insets(insets);
}

- (MAAutoLayoutMakers * _Nonnull (^)(id _Nonnull))equalTo{
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationEqual);
    };
}

- (MAAutoLayoutMakers *)equalTo:(NSObject *)attr{
    return self.equalTo(attr);
}

- (MAAutoLayoutMakers * _Nonnull (^)(id _Nonnull))greaterThanOrEqualTo{
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationGreaterThanOrEqual);
    };
}
- (MAAutoLayoutMakers *)greaterThanOrEqualTo:(NSObject *)attr{
    return self.greaterThanOrEqualTo(attr);
}

- (MAAutoLayoutMakers * _Nonnull (^)(id _Nonnull))lessThanOrEqualTo{
    return ^id(id attribute) {
        return self.equalToWithRelation(attribute, NSLayoutRelationLessThanOrEqual);
    };
}
- (MAAutoLayoutMakers *)lessThanOrEqualTo:(NSObject *)attr{
    return self.lessThanOrEqualTo(attr);
}

- (MAAutoLayoutMakers * _Nonnull (^)(void))equalToSuperView {
    return ^id() {
        return self.equalToWithRelation(self.firstItem.superview, NSLayoutRelationEqual);
    };
}
- (MAAutoLayoutMakers * _Nonnull (^)(void))greaterThanOrEqualToSuperView{
    return ^id() {
        return self.equalToWithRelation(self.firstItem.superview, NSLayoutRelationGreaterThanOrEqual);
    };
}
- (MAAutoLayoutMakers * _Nonnull (^)(void))lessThanOrEqualToSuperView{
    return ^id() {
        return self.equalToWithRelation(self.firstItem.superview, NSLayoutRelationLessThanOrEqual);
    };
}

- (MAAutoLayoutMakers * _Nonnull (^)(CGFloat))ma_equal{
    return ^id(CGFloat constant) {
        return self.equalToWithRelation(@(constant), NSLayoutRelationEqual);
    };
}
- (MAAutoLayoutMakers *)ma_equal:(CGFloat)constant{
    return self.ma_equal(constant);
}

- (MAAutoLayoutMakers * _Nonnull (^)(CGFloat, CGFloat))ma_equalSize{
    return ^id(CGFloat width, CGFloat height) {
        return self.equalToWithRelation([NSValue valueWithCGSize:CGSizeMake(width, height)], NSLayoutRelationEqual);
    };
}
- (MAAutoLayoutMakers *)ma_equalSize:(CGFloat)width height:(CGFloat)height{
    return self.ma_equalSize(width, height);
}

- (MAAutoLayoutMakers * _Nonnull (^)(CGFloat))ma_greaterThanOrEqual{
    return ^id(CGFloat constant) {
        return self.equalToWithRelation(@(constant), NSLayoutRelationGreaterThanOrEqual);
    };
}
- (MAAutoLayoutMakers *)ma_greaterThanOrEqual:(CGFloat)constant{
    return self.ma_greaterThanOrEqual(constant);
}

- (MAAutoLayoutMakers * _Nonnull (^)(CGFloat))ma_lessThanOrEqual{
    return ^id(CGFloat constant) {
        return self.equalToWithRelation(@(constant), NSLayoutRelationLessThanOrEqual);
    };
}
- (MAAutoLayoutMakers *)ma_lessThanOrEqual:(CGFloat)constant{
    return self.ma_lessThanOrEqual(constant);
}

- (MAAutoLayoutMakers * _Nonnull (^)(UILayoutPriority))priority{
    return ^(UILayoutPriority priority) {
        self.priorityValue = priority;
        return self;
    };
}
- (MAAutoLayoutMakers *)priority:(UILayoutPriority)priority{
    return self.priority(priority);
}

- (NSArray<NSLayoutConstraint *> *)active {
    if (self.layoutMarkers.count > 0) {
        for (MAAutoLayoutMaker *maker in self.layoutMarkers) {
            maker.layoutConstraint.active = NO;
        }
    }
    NSMutableArray *layoutConstraints = [NSMutableArray array];
    for (MAAutoLayoutMaker *maker in self.layoutMarkers) {
        [layoutConstraints addObject:[maker active]];
    }
    return layoutConstraints;
}

- (void)deactivate{
    [self.layoutMarkers makeObjectsPerformSelector:@selector(deactivate)];
}

#pragma mark private
- (void)setRelation:(NSLayoutRelation)relation {
    _relation = relation;
    for (MAAutoLayoutMaker *maker in self.layoutMarkers) {
        maker.relation = relation;
    }
}
- (void)setSecondItem:(id)secondItem {
    _secondItem = secondItem;
    for (MAAutoLayoutMaker *maker in self.layoutMarkers) {
        maker.secondItem = secondItem;
    }
}
- (void)setInsetsValue:(UIEdgeInsets)insetsValue {
    _insetsValue = insetsValue;
    for (MAAutoLayoutMaker *maker in self.layoutMarkers) {
        NSLayoutAttribute attribute = maker.firstAttribute;
        CGFloat constant = 0;
        if (attribute == NSLayoutAttributeTop || attribute == NSLayoutAttributeWidth) {
            constant = self.insetsValue.top;
        }else if (attribute == NSLayoutAttributeLeft || attribute == NSLayoutAttributeHeight) {
            constant = self.insetsValue.left;
        }else if (attribute == NSLayoutAttributeRight) {
            constant = self.insetsValue.right;
        }else if (attribute == NSLayoutAttributeBottom) {
            constant = self.insetsValue.bottom;
        }else{
            constant = self.insetsValue.top;
        }
        maker.constant = constant;
    }
}
- (void)setPriorityValue:(UILayoutPriority)priorityValue {
    _priorityValue = priorityValue;
    for (MAAutoLayoutMaker *maker in self.layoutMarkers) {
        maker.priorityValue = priorityValue;
    }
}

- (MAAutoLayoutMakers * (^)(id, NSLayoutRelation))equalToWithRelation {
    return ^id(id attribute, NSLayoutRelation relation) {
        if ([attribute isKindOfClass:[UIView class]]) {
            self.secondItem = attribute;
        }else if ([attribute isKindOfClass:[NSNumber class]]){
            self.secondItem = nil;
            self.insetsValue = UIEdgeInsetsMake(((NSNumber *)attribute).floatValue, ((NSNumber *)attribute).floatValue, 0, 0);
        }else if ([attribute isKindOfClass:[NSValue class]]) {
            self.secondItem = nil;
            CGSize size = [(NSValue *)attribute CGSizeValue];
            self.insetsValue = UIEdgeInsetsMake(size.width, size.height, 0, 0);
        }else{
            NSAssert(attribute, @"格式不正确,必须是UIView或NSNumber");
        }
        self.relation = relation;
        return self;
    };
}

@end


@implementation MAViewAttribute

- (id)initWithItem:(id)item layoutAttribute:(NSLayoutAttribute)layoutAttribute{
    self = [super init];
    if (!self) return nil;
    
    _item = item;
    _layoutAttribute = layoutAttribute;
    
    return self;
}

@end


@implementation UIView (MAConvenience)

- (MAAutoLayoutMaker *)ma_leftMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (MAAutoLayoutMaker *)ma_topMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeTop];
}

- (MAAutoLayoutMaker *)ma_rightMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeRight];
}

- (MAAutoLayoutMaker *)ma_bottomMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (MAAutoLayoutMaker *)ma_leadingMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (MAAutoLayoutMaker *)ma_trailingMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (MAAutoLayoutMaker *)ma_widthMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (MAAutoLayoutMaker *)ma_heightMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (MAAutoLayoutMaker *)ma_centerXMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (MAAutoLayoutMaker *)ma_centerYMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (MAAutoLayoutMaker *)ma_baselineMaker {
    return [self ma_layoutMakerWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (UIEdgeInsets)ma_safeAreaInsets{
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        safeInsets = self.safeAreaInsets;
    }
#endif
    return safeInsets;
}

+ (UIEdgeInsets)ma_rootSafeAreaInsets{
    UIEdgeInsets safeInsets = UIEdgeInsetsZero;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        safeInsets = [[UIApplication sharedApplication] delegate].window.safeAreaInsets;
    }
#endif
    return safeInsets;
}

- (UIView *)ma_addSpacingView:(void (^)(MAAutoLayout * _Nonnull))make {
    UIView *view = [[UIView alloc] init];
    [self addSubview:view];
    [view ma_makeConstraints:make];
    return view;
}

@end
