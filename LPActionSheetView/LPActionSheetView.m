//
//  LPActionSheetView.m
//  LPActionSheetView
//
//  Created by litt1e-p on 16/2/22.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "LPActionSheetView.h"

@interface LPActionSheetView()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *actionSheet;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIWindow *keyWindow;
@property (nonatomic, strong) UITapGestureRecognizer *tapGR;
@property (nonatomic, weak) UIView *header;
@property (nonatomic, weak) UIView *footer;
@property (nonatomic, strong) UIView *container;

@end

@implementation LPActionSheetView

@synthesize maskViewExtend = _maskViewExtend;
@synthesize dataSource     = _dataSource;
@synthesize separatorStyle = _separatorStyle;

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self sharedInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self sharedInit];
    }
    return self;
}

- (void)sharedInit
{
    [self.keyWindow addSubview:self.maskView];
    [self.container addSubview:self.actionSheet];
    [self.keyWindow addSubview:self.container];
}

#pragma mark - show or dismiss with animation 📌
- (void)show
{
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.hidden   = NO;
        self.container.frame = [self containerTransFrame:YES];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.hidden   = YES;
        self.container.frame = [self containerTransFrame:NO];
    }];
}

- (CGRect)containerTransFrame:(BOOL)show
{
    CGRect frame = self.frame;
    if (!show) {
        frame.origin.y = self.keyWindow.frame.size.height;
    }
    return frame;
}

#pragma mark - mask tap 📌
- (void)tapToDismiss
{
    [self dismiss];
}

#pragma mark - UITableViewDelegate 📌
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedSheetRowAtIndex:)]) {
            [self.delegate didSelectedSheetRowAtIndex:indexPath.row];
        } else if ([self.delegate respondsToSelector:@selector(actionSheetView:didSelectedSheetRowAtIndex:)]) {
            [self.delegate actionSheetView:self didSelectedSheetRowAtIndex:indexPath.row];
        }
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didDeSelectedSheetRowAtIndex:)]) {
            [self.delegate didDeSelectedSheetRowAtIndex:indexPath.row];
        } else if ([self.delegate respondsToSelector:@selector(actionSheetView:didDeSelectedSheetRowAtIndex:)]) {
            [self.delegate actionSheetView:self didDeSelectedSheetRowAtIndex:indexPath.row];
        }   
    }
}

#pragma mark - UITableViewDadaSource 📌
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfSheetCell)]) {
            num = [self.dataSource numberOfSheetCell];
        } else if ([self.dataSource respondsToSelector:@selector(numberOfSheetCellForActionSheetView:)]) {
            num = [self.dataSource numberOfSheetCellForActionSheetView:self];
        }
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (self.dataSource && ([self.dataSource respondsToSelector:@selector(heightForSheetCellAtIndex:)] || [self.dataSource respondsToSelector:@selector(actionSheetView:heightForSheetCellAtIndex:)])) {
        if ([self.dataSource respondsToSelector:@selector(heightForSheetCellAtIndex:)]) {
            height = [self.dataSource heightForSheetCellAtIndex:indexPath.row];
        } else if ([self.dataSource respondsToSelector:@selector(actionSheetView:heightForSheetCellAtIndex:)]) {
            height = [self.dataSource actionSheetView:self heightForSheetCellAtIndex:indexPath.row];
        }
    } else {
        CGFloat headerHeight = self.header ? self.header.frame.size.height : 0.f;
        CGFloat footerHeight = self.footer ? self.footer.frame.size.height : 0.f;
        height = (self.container.frame.size.height - headerHeight - footerHeight) / [self.dataSource numberOfSheetCell];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.dataSource) {
        NSString *identifier = [NSString stringWithFormat:@"kIdentifier%zi", indexPath.row];
        cell                 = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            if ([self.dataSource respondsToSelector:@selector(sheetCellForRowAtIndex:)]) {
                cell = [self.dataSource sheetCellForRowAtIndex:indexPath.row];
            } else if ([self.dataSource respondsToSelector:@selector(actionSheetView:sheetCellForRowAtIndex:)]) {
                cell = [self.dataSource actionSheetView:self sheetCellForRowAtIndex:indexPath.row];
            }
        }
    }
    return cell;
}

#pragma mark - setupActionSheetHeaderAndFooter 📌
- (void)setupActionSheetHeaderAndFooter
{
    if (self.dataSource) {
        UIView *header;
        if ([self.dataSource respondsToSelector:@selector(sheetViewHeader)]) {
            header = [self.dataSource sheetViewHeader];
        } else if ([self.dataSource respondsToSelector:@selector(sheetViewHeaderForActionSheetView:)]) {
            header = [self.dataSource sheetViewHeaderForActionSheetView:self];
        }
        header.frame           = CGRectMake(0, 0, header.frame.size.width, header.frame.size.height);
        CGRect sheetFrame      = self.actionSheet.frame;
        sheetFrame.size.height -= header.frame.size.height;
        sheetFrame.origin.y    += CGRectGetHeight(header.frame);
        self.actionSheet.frame = sheetFrame;
        self.header            = header;
        [self.container addSubview:header];
    }
    if (self.dataSource) {
        UIView *footer;
        if ([self.dataSource respondsToSelector:@selector(sheetViewFooter)]) {
            footer = [self.dataSource sheetViewFooter];
        } else if ([self.dataSource respondsToSelector:@selector(sheetViewFooterForActionSheetView:)]) {
            footer = [self.dataSource sheetViewFooterForActionSheetView:self];
        }
        footer.frame           = CGRectMake(0, CGRectGetHeight(self.container.frame) - footer.frame.size.height, footer.frame.size.width, footer.frame.size.height);
        CGRect sheetFrame      = self.actionSheet.frame;
        sheetFrame.size.height -= footer.frame.size.height;
        self.actionSheet.frame = sheetFrame;
        self.footer            = footer;
        [self.container addSubview:footer];
    }
}

#pragma mark - maskViewFrameCalc 📌
- (CGRect)maskViewFrameCalc
{
    CGRect frame = self.keyWindow.frame;
    switch (self.maskViewExtend) {
        case LPMaskViewExtendUnderStatusBar:
            frame.size.height -= 20;
            frame.origin.y    = 20;
            break;
            
        case LPMaskViewExtendUnderNavigationBar:
            frame.size.height -= 64;
            frame.origin.y    = 64;
            break;
            
        default:
            frame = self.keyWindow.frame;
            break;
    }
    return frame;
}

#pragma mark - settters & getters 📌
- (LPMaskViewExtend)maskViewExtend
{
    return _maskViewExtend;
}

- (void)setMaskViewExtend:(LPMaskViewExtend)maskViewExtend
{
    _maskViewExtend     = maskViewExtend;
    self.maskView.frame = [self maskViewFrameCalc];
}

- (NSArray *)selectedSheetRows
{
    NSMutableArray *selectedRows = [NSMutableArray array];
    NSArray *selectedIndexPaths = [self.actionSheet indexPathsForSelectedRows];
    if (selectedIndexPaths.count) {
        [selectedIndexPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = obj;
            [selectedRows addObject:@(indexPath.row)];
        }];
    }
    return selectedRows;
}

- (id<LPActionSheetViewDataSource>)dataSource
{
    return _dataSource;
}

- (void)setDataSource:(id<LPActionSheetViewDataSource>)dataSource
{
    _dataSource = dataSource;
    [self setupActionSheetHeaderAndFooter];
}

- (void)setSeparatorStyle:(LPActionSheetCellSeparatorStyle)separatorStyle
{
    _separatorStyle = separatorStyle;
    if (separatorStyle == LPActionSheetCellSeparatorStyleNone) {
        self.actionSheet.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else if (separatorStyle == LPActionSheetCellSeparatorStyleUnderLine) {
        self.actionSheet.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

- (LPActionSheetCellSeparatorStyle)separatorStyle
{
    return _separatorStyle;
}

- (LPActionSheetCell *)selectedSheetCell
{
    LPActionSheetCell *cell = nil;
    NSIndexPath *indexPath = [self.actionSheet indexPathForSelectedRow];
    if (indexPath) {
        cell = [self.actionSheet cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

- (NSArray *)allSheetCells
{
    NSMutableArray *cells = [NSMutableArray array];
    NSInteger count;
    if (self.dataSource) {
        if ([self.dataSource respondsToSelector:@selector(numberOfSheetCell)]) {
            count = [self.dataSource numberOfSheetCell];
        } else if ([self.dataSource respondsToSelector:@selector(numberOfSheetCellForActionSheetView:)]) {
            count = [self.dataSource numberOfSheetCellForActionSheetView:self];
        }
    }
    if (count <= 0) {
        return cells;
    }
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        LPActionSheetCell *cell = [self.actionSheet cellForRowAtIndexPath:indexPath];
        if (cell) {
            [cells addObject:cell];
        }
        /** from below cell's frame is not correct */
//        else (self.dataSource && [self.dataSource respondsToSelector:@selector(sheetCellForRowAtIndex:)]) {
//            cell = [self.dataSource sheetCellForRowAtIndex:i];
//            if (cell) {
//                [cells addObject:cell];
//            }
//        }
    }
    return cells;
}

#pragma mark - lazyloads 📌
- (UIView *)container
{
    if (!_container) {
        CGRect frame   = self.frame;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, self.keyWindow.frame.size.height, frame.size.width, frame.size.height)];
        self.container = container;
    }
    return _container;
}

- (UITableView *)actionSheet
{
    if (!_actionSheet) {
        UITableView *tb    = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.container.frame.size.width, self.container.frame.size.height)];
        tb.separatorStyle  = (UITableViewCellSeparatorStyle)self.separatorStyle;
        tb.tableFooterView = [[UIView alloc] init];
        tb.dataSource      = self;
        tb.delegate        = self;
        _actionSheet       = tb;
    }
    return _actionSheet;
}

- (UIView *)maskView
{
    if (!_maskView) {
        UIView *mask         = [[UIView alloc] initWithFrame:[self maskViewFrameCalc]];
        mask.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
        _maskView            = mask;
        _maskView.hidden     = YES;
        [_maskView addGestureRecognizer:self.tapGR];
    }
    return _maskView;
}

- (UITapGestureRecognizer *)tapGR
{
    if (!_tapGR) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDismiss)];
        tap.delegate                = self;
        self.tapGR                  = tap;
    }
    return _tapGR;
}

- (UIWindow *)keyWindow
{
    if (!_keyWindow) {
        _keyWindow = [UIApplication sharedApplication].keyWindow;
    }
    return _keyWindow;
}

@end
