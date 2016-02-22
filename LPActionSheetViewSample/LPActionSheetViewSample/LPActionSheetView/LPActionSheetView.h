//
//  LPActionSheetView.h
//  LPActionSheetView
//
//  Created by litt1e-p on 16/2/22.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPActionSheetCell.h"

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
- (NSInteger)numberOfSheetCell;
- (LPActionSheetCell *)sheetCellForRowAtIndex:(NSInteger)index;

@optional
- (CGFloat)heightForSheetCellAtIndex:(NSInteger)index;
- (UIView *)sheetViewHeader;
- (UIView *)sheetViewFooter;

@end

@protocol LPActionSheetViewDelegate <NSObject>

- (void)didSelectedSheetRowAtIndex:(NSInteger)index;

@end

@interface LPActionSheetView : UIView

@property (nonatomic, weak) id<LPActionSheetViewDataSource> dataSource;
@property (nonatomic, weak) id<LPActionSheetViewDelegate> delegate;

@property (nonatomic, assign) LPMaskViewExtend maskViewExtend;
@property (nonatomic, strong, readonly) NSArray *selectedSheetRows;
@property (nonatomic, assign) LPActionSheetCellSeparatorStyle separatorStyle;

- (void)show;
- (void)dismiss;

@end
