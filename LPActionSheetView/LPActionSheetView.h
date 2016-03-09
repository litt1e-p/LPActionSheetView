//
//  LPActionSheetView.h
//  LPActionSheetView
//
//  Created by litt1e-p on 16/2/22.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPActionSheetCell.h"
@class LPActionSheetView;

typedef NS_ENUM(NSInteger, LPMaskViewExtend)
{
    LPMaskViewExtendUnderStatusBar,
    LPMaskViewExtendUnderNavigationBar,
    LPMaskViewExtendFullScreen
};

typedef NS_ENUM(NSInteger, LPActionSheetCellSeparatorStyle)
{
    LPActionSheetCellSeparatorStyleNone,
    LPActionSheetCellSeparatorStyleUnderLine
};

@protocol LPActionSheetViewDataSource <NSObject>

@required
/**
 *  for simplified implementation
 */
- (NSInteger)numberOfSheetCell;
- (LPActionSheetCell *)sheetCellForRowAtIndex:(NSInteger)index;

@optional
/**
 *  for complex implementation
 */
- (NSInteger)numberOfSheetCellForActionSheetView:(LPActionSheetView *)actionSheetView;
- (LPActionSheetCell *)actionSheetView:(LPActionSheetView *)actionSheetView sheetCellForRowAtIndex:(NSInteger)index;

/**
 *  for simplified implementation
 */
- (CGFloat)heightForSheetCellAtIndex:(NSInteger)index;
- (UIView *)sheetViewHeader;
- (UIView *)sheetViewFooter;

/**
 *  for complex implementation
 */
- (CGFloat)actionSheetView:(LPActionSheetView *)actionSheetView heightForSheetCellAtIndex:(NSInteger)index;
- (UIView *)sheetViewHeaderForActionSheetView:(LPActionSheetView *)actionSheetView;
- (UIView *)sheetViewFooterForActionSheetView:(LPActionSheetView *)actionSheetView;

@end

@protocol LPActionSheetViewDelegate <NSObject>

@optional
/**
 *  for simplified implementation
 */
- (void)didSelectedSheetRowAtIndex:(NSInteger)index;
- (void)didDeSelectedSheetRowAtIndex:(NSInteger)index;

/**
 *  for complex implementation
 */
- (void)actionSheetView:(LPActionSheetView *)actionSheetView didSelectedSheetRowAtIndex:(NSInteger)index;
- (void)actionSheetView:(LPActionSheetView *)actionSheetView didDeSelectedSheetRowAtIndex:(NSInteger)index;

@end

@interface LPActionSheetView : UIView

@property (nonatomic, weak) id<LPActionSheetViewDataSource> dataSource;
@property (nonatomic, weak) id<LPActionSheetViewDelegate> delegate;

@property (nonatomic, assign) LPMaskViewExtend maskViewExtend;
@property (nonatomic, strong, readonly) LPActionSheetCell *selectedSheetCell;
@property (nonatomic, strong, readonly) NSArray *selectedSheetRows;
@property (nonatomic, strong, readonly) NSArray *allSheetCells;
@property (nonatomic, assign) LPActionSheetCellSeparatorStyle separatorStyle;

- (void)show;
- (void)dismiss;

@end
