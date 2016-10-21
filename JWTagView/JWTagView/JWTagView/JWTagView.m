//
//  JWTagView.m
//  JWTagView
//
//  Created by wangjun on 16/9/11.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import "JWTagView.h"

#pragma mark - JWTagItem
@interface JWTagItem : UIButton

@property (nonatomic, assign) CGFloat itemHorizontalMargin;
@property (nonatomic, assign) CGFloat itemVerticalMargin;

+ (JWTagItem *)itemWithConfig:(JWTagConfig *)config;

@end

@implementation JWTagItem

+ (JWTagItem *)itemWithConfig:(JWTagConfig *)config
{
    JWTagItem *tempItem = [JWTagItem buttonWithType:UIButtonTypeCustom];
    tempItem.clipsToBounds = YES;
    tempItem.itemHorizontalMargin = config.tagInsideHorizontalMargin;
    tempItem.itemVerticalMargin = config.tagInsideVerticalMargin;
    if (config.tagBorderWidth > 0 && config.tagBorderColor != [UIColor clearColor])
    {
        tempItem.layer.borderWidth = config.tagBorderWidth;
        tempItem.layer.borderColor = config.tagBorderColor.CGColor;
    }
    if (config.tagCornerRadius > 0)
    {
        tempItem.layer.cornerRadius = config.tagCornerRadius;
    }
    if (config.tagDeleteImage)
    {
        [tempItem setImage:config.tagDeleteImage forState:UIControlStateNormal];
    }
    [tempItem setTitleColor:config.tagTitleNormalColor
                   forState:UIControlStateNormal];
    [tempItem setTitleColor:config.tagTitleHighlightColor
                   forState:UIControlStateSelected];
    [tempItem setTitleColor:config.tagTitleHighlightColor
                   forState:UIControlStateHighlighted];
    [tempItem setBackgroundImage:config.tagBackgroundNormalImage
                        forState:UIControlStateNormal];
    [tempItem setBackgroundImage:config.tagBackgroundHighlightImage
                        forState:UIControlStateSelected];
    [tempItem setBackgroundImage:config.tagBackgroundHighlightImage
                        forState:UIControlStateHighlighted];
    tempItem.titleLabel.font = config.tagTitleFont;
    
    
    return tempItem;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 计算按钮标题Size
    CGRect tempRect = [title boundingRectWithSize:CGSizeMake(999, 20)
                                          options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       attributes:@{NSFontAttributeName:self.titleLabel.font}
                                          context:nil];
    CGFloat tempTitleW = tempRect.size.width;
    CGFloat tempTitleH = tempRect.size.height;
    
    // 获取按钮的高度
    CGFloat tempButtonH = tempTitleH + _itemVerticalMargin * 2;
    
    // 获取按钮整个宽度
    CGFloat tempButtonW = tempTitleW + _itemHorizontalMargin * 2;
    if ([JWTagConfig config].tagDeleteImage)
    {
        // 图片的宽度、高度=按钮高度的一半
        tempButtonW += tempButtonH/2;
        tempButtonW += _itemHorizontalMargin;
        
        // 修正图片、Title的位置
        self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                -(tempButtonH/2 + _itemHorizontalMargin/2),
                                                0,
                                                tempButtonH/2 + _itemHorizontalMargin/2);
        self.imageEdgeInsets = UIEdgeInsetsMake(0,
                                                tempTitleW + _itemHorizontalMargin/2,
                                                0,
                                                -(tempTitleW + _itemHorizontalMargin/2));
    }
    
    // 内部计算Item的size
    self.frame = CGRectMake(0, 0, tempButtonW, tempButtonH);
}

@end

#pragma mark - JWTagView
@interface JWTagView()

/**
 *  Tag总高度
 */
@property (nonatomic, assign, readwrite) CGFloat tagAllHeight;

/**
 *  Tag，存储每一个Item的数组
 */
@property (nonatomic, strong) NSMutableArray *tagItemsArray;

/**
 *  Tag，存储每一个Item的字典，key为tag
 */
@property (nonatomic, strong) NSMutableDictionary *tagItemsDic;

@end

@implementation JWTagView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.clipsToBounds = YES;
    }
    return self;
}

- (NSMutableArray *)tagItemsArray
{
    if (!_tagItemsArray)
    {
        self.tagItemsArray = [NSMutableArray array];
    }
    return _tagItemsArray;
}

- (NSMutableDictionary *)tagItemsDic
{
    if (!_tagItemsDic)
    {
        self.tagItemsDic = [NSMutableDictionary dictionary];
    }
    return _tagItemsDic;
}

- (CGFloat)tagAllHeight
{
    if (self.tagItemsArray.count <= 0) return 0;
    CGFloat tempAllHeight = CGRectGetMaxY([[self.tagItemsArray lastObject] frame]) + [[JWTagConfig config] tagMargin];
    return tempAllHeight;
}

#pragma mark - Public Method
- (void)addTag:(NSString *)tag
{
    if (tag.length <= 0) return;
    
    JWTagItem *tempItem = [JWTagItem itemWithConfig:[JWTagConfig config]];
    tempItem.tag = self.tagItemsArray.count;
    [tempItem setTitle:tag
              forState:UIControlStateNormal];
    [tempItem addTarget:self
                 action:@selector(tagAction:)
       forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tempItem];
    
    // 添加手势
    if ([[JWTagConfig config] tagCanPanSort])
    {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [tempItem addGestureRecognizer:panGesture];
    }
    
    // 将按钮保存到数组
    [self.tagItemsArray addObject:tempItem];
    // 将按钮保存到字典，用于删除时，方便通过tag找到对象
    [self.tagItemsDic setObject:tempItem forKey:tag];
    
    // 修正按钮的位置
    [self configItemFrameWithIndex:tempItem.tag];
    
    // 更新本身View的高度
    [self updateCustomHeight];
}

- (void)addTags:(NSArray *)tags
{
    if (self.frame.size.width <= 0)
    {
        @throw [NSException exceptionWithName:@"JWError" reason:@"先设置标签列表的frame" userInfo:nil];
    }
    
    for (NSString *tempTag in tags)
    {
        [self addTag:tempTag];
    }
}

- (void)deleteTag:(NSString *)tag
{
    if (tag.length <= 0) return;
    
    // 根据Key，找到需要删除的Item
    JWTagItem *tempItem = self.tagItemsDic[tag];
    
    // 首先将按钮从界面上移除
    [tempItem removeFromSuperview];
    
    // 再从字典里移除
    [self.tagItemsDic removeObjectForKey:tag];
    
    // 再从数组移除
    [self.tagItemsArray removeObject:tempItem];
    
    // 再更新Tag
    [self updateItemsTag];
    
    // 再更新删除按钮之后的所有按钮的Frame
    [UIView animateWithDuration:0.3 animations:^{
        [self updateAfterItemFrameWithIndex:tempItem.tag];
    }];
    
    // 再更新自己的View的Frame
    [self updateCustomHeight];
}

- (void)deleteAllTag
{
    // 清空所有的Item
    for (JWTagItem *tempItem in self.tagItemsArray)
    {
        [tempItem removeFromSuperview];
    }
    
    // 清空数组
    [self.tagItemsArray removeAllObjects];
    
    // 清空字典
    [self.tagItemsDic removeAllObjects];
    
    // 再更新自己的View的Frame
    [self updateCustomHeight];
}

#pragma mark - Private Method
- (void)configItemFrameWithIndex:(NSInteger)index
{
    JWTagItem *preItem;
    if (index - 1 >= 0)
    {
        preItem = self.tagItemsArray[index-1];
    }
    
    JWTagItem *currentItem;
    if (index >= 0)
    {
        currentItem = self.tagItemsArray[index];
    }
    
    JWTagConfig *config = [JWTagConfig config];
    // 定位按钮的X－Y
    CGFloat tempButtonX = CGRectGetMaxX(preItem.frame) + config.tagMargin;
    CGFloat tempButtonY = preItem ? CGRectGetMinY(preItem.frame) : config.tagMargin;
    
    // 获取按钮的高度
    CGFloat tempButtonH = CGRectGetHeight(currentItem.frame);
    
    // 获取按钮整个宽度
    CGFloat tempButtonW = CGRectGetWidth(currentItem.frame);
    
    // 判断当前按钮是显示在当前行、还是需要换行
    if (tempButtonX + tempButtonW + config.tagMargin > self.bounds.size.width)
    {
        tempButtonX = config.tagMargin;
        tempButtonY = CGRectGetMaxY(preItem.frame) + config.tagMargin;
    }
    
    currentItem.frame = CGRectMake(tempButtonX, tempButtonY, tempButtonW, tempButtonH);
}

- (void)updateItemsTag
{
    for (NSInteger i = 0; i < self.tagItemsArray.count; i++)
    {
        JWTagItem *tempItem = self.tagItemsArray[i];
        tempItem.tag = i;
    }
}

- (void)updateAllItemFrame
{
    for (NSInteger i = 0; i < self.tagItemsArray.count; i++)
    {
        [self configItemFrameWithIndex:i];
    }
}

- (void)updateBeforeItemFrameWithIndex:(NSInteger)index
{
    for (NSInteger i = 0; i < index; i++)
    {
        [self configItemFrameWithIndex:i];
    }
}

- (void)updateAfterItemFrameWithIndex:(NSInteger)index
{
    for (NSInteger i = index; i < self.tagItemsArray.count; i++)
    {
        [self configItemFrameWithIndex:i];
    }
}

- (void)updateCustomHeight
{
    // 判断是否需要更新自己的高度
    if ([[JWTagConfig config] tagAutoUpdateHeight])
    {
        // 再更新自己的View的Frame
        CGRect tempFrame = self.frame;
        tempFrame.size.height = self.tagAllHeight;
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = tempFrame;
        }];
    }
}

- (void)tagAction:(id)sender
{
    JWTagItem *tempItem = (JWTagItem *)sender;
    if ([[JWTagConfig config] tagKeepSeleted])
    {
        tempItem.selected = !tempItem.selected;
    }
    
    if (self.tagComplete)
    {
        self.tagComplete(tempItem.currentTitle, tempItem.selected);
    }
}

- (JWTagItem *)itemPanCenterInItems:(JWTagItem *)panItem
{
    for (JWTagItem *tempItem in self.tagItemsArray)
    {
        if (panItem == tempItem) continue;
        if (CGRectContainsPoint(tempItem.frame, panItem.center))
        {
            return tempItem;
        }
    }
    return nil;
}

#pragma mark - UIPanGestureRecognizer
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture
{
    // 获取当前手指偏移量
    CGPoint transPoint = [gesture translationInView:self];
    
    // 获取当前拖动的Item
    JWTagItem *panItem = (JWTagItem *)gesture.view;
    
    // 拖动开始
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [UIView animateWithDuration:0.3 animations:^{
            panItem.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [self addSubview:panItem];
    }
    
    // 更新拖动的Item中心点
    CGPoint tempCenter = panItem.center;
    tempCenter.x += transPoint.x;
    tempCenter.y += transPoint.y;
    panItem.center = tempCenter;
    
    // 拖动中
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // 活动拖动过程中，移动到哪个Item上面去了
        JWTagItem *tempInsertItem = [self itemPanCenterInItems:panItem];
        if (tempInsertItem)
        {
            NSInteger tempInsertIndex = tempInsertItem.tag;
            NSInteger tempPanIndex = panItem.tag;
            
            // 先删除Item在数组中原来的位置
            [self.tagItemsArray removeObject:panItem];
            // 插入新的位置
            [self.tagItemsArray insertObject:panItem atIndex:tempInsertIndex];
            // 更新所有Item的tag
            [self updateItemsTag];
            
            // 向前插入
            if (tempPanIndex > tempInsertIndex)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self updateAfterItemFrameWithIndex:tempInsertIndex];
                }];
            }
            // 向后插入
            else
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [self updateBeforeItemFrameWithIndex:tempInsertIndex];
                }];
            }
        }
    }
    
    // 拖动完成
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:0.3 animations:^{
            panItem.transform = CGAffineTransformIdentity;
            [self updateAllItemFrame];
        }];
    }
    
    [gesture setTranslation:CGPointZero inView:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

#pragma mark - JWTagConfig
static JWTagConfig *config;

@implementation JWTagConfig

+ (JWTagConfig *)config
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[JWTagConfig alloc] init];
    });
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tagMargin = 10;
        self.tagInsideHorizontalMargin = 5;
        self.tagInsideVerticalMargin = 5;
        self.tagDeleteImage = nil;
        self.tagTitleNormalColor = [UIColor redColor];
        self.tagTitleHighlightColor = [UIColor whiteColor];
        self.tagTitleFont = [UIFont systemFontOfSize:13];
        self.tagBorderColor = [UIColor clearColor];
        self.tagBorderWidth = 1.0;
        self.tagCornerRadius = 5;
        self.tagBackgroundNormalColor = [UIColor whiteColor];
        self.tagBackgroundHighlightColor = [UIColor redColor];
        self.tagCanPanSort = NO;
        self.tagAutoUpdateHeight = YES;
        self.tagKeepSeleted = NO;
    }
    return self;
}

- (void)setTagBackgroundNormalColor:(UIColor *)tagBackgroundNormalColor
{
    _tagBackgroundNormalColor = tagBackgroundNormalColor;
    
    _tagBackgroundNormalImage = [self imageWithColor:tagBackgroundNormalColor];
}

- (void)setTagBackgroundHighlightColor:(UIColor *)tagBackgroundHighlightColor
{
    _tagBackgroundHighlightColor = tagBackgroundHighlightColor;
    
    _tagBackgroundHighlightImage = [self imageWithColor:tagBackgroundHighlightColor];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
