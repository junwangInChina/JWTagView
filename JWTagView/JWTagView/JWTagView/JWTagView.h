//
//  JWTagView.h
//  JWTagView
//
//  Created by wangjun on 16/9/11.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWTagView : UIView

/**
 *  Tag总高度
 */
@property (nonatomic, assign, readonly) CGFloat tagAllHeight;

/**
 *  Tag点击回调的Block
 */
@property (nonatomic, copy) void(^tagComplete)(NSString *tapTag);

/**
 *  添加一个Tag
 *
 *  @param tag Tag内容(标题)
 */
- (void)addTag:(NSString *)tag;

/**
 *  添加一组Tag
 *
 *  @param tags Tag内容数组
 */
- (void)addTags:(NSArray *)tags;

/**
 *  删除一个Tag
 *
 *  @param tags 需要删除的tag
 */
- (void)deleteTag:(NSString *)tag;

/**
 *  删除所有的Tag
 */
- (void)deleteAllTag;

@end

@interface JWTagConfig : NSObject

/**
 *  单利模式，设置标签的一些属性
 *
 *  @return 返回设置实例
 */
+ (JWTagConfig *)config;

/**
 *  每个Tag之间的Margin（top、left、bottom、right） default is 10
 */
@property (nonatomic, assign) CGFloat tagMargin;

/**
 *  Tag内部Margin(标题与图片之间的) default is 5
 */
@property (nonatomic, assign) CGFloat tagInsideMargin;

/**
 *  Tag的删除图标 ❌ default is nil
 */
@property (nonatomic, strong) UIImage *tagDeleteImage;

/**
 *  Tag标题颜色 defaule is [UIColor redColor]
 */
@property (nonatomic, strong) UIColor *tagTitleColor;

/**
 *  Tag标题字体 default is [UIFont systemFontOfSize:13]
 */
@property (nonatomic, strong) UIFont *tagTitleFont;

/**
 *  Tag边框颜色 defaule is [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *tagBorderColor;

/**
 *  Tag边框宽度 default is 0(无边框)
 */
@property (nonatomic, assign) CGFloat tagBorderWidth;

/**
 *  Tag圆角半径 default is 5
 */
@property (nonatomic, assign) CGFloat tagCornerRadius;

/**
 *  Tag的背景色 default is [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *tagBackgroundColor;

/**
 *  Tag的背景图 default is nil
 */
@property (nonatomic, strong) UIImage *tagBackgroundImage;

/**
 *  Tag是否支持拖动 default is NO
 */
@property (nonatomic, assign) BOOL tagCanPanSort;

/**
 *  Tag是否自动更新本身的高度 default is YES
 */
@property (nonatomic, assign) BOOL tagAutoUpdateHeight;

@end
