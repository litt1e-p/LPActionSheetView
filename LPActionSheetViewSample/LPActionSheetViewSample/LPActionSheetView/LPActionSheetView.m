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

@end

@implementation LPActionSheetView

@synthesize maskViewExtend = _maskViewExtend;
@synthesize dataSource = _dataSource;
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
    [self.keyWindow addSubview:self.actionSheet];
}

#pragma mark - show or dismiss with animation 📌
- (void)show
{
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.hidden   = NO;
        self.actionSheet.frame = [self actionSheetTransFrame:YES];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25f animations:^{
        self.maskView.hidden   = YES;
        self.actionSheet.frame = [self actionSheetTransFrame:NO];
    }];
}

- (CGRect)actionSheetTransFrame:(BOOL)show
{
    CGRect frame = self.frame;
    if (!show) {
        frame = CGRectMake(frame.origin.x, self.keyWindow.frame.size.height, frame.size.width, frame.size.height);
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedSheetRowAtIndex:)]) {
        [self.delegate didSelectedSheetRowAtIndex:indexPath.row];
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
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfSheetCell)]) {
        num = [self.dataSource numberOfSheetCell];
    }
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(heightForSheetCellAtIndex:)]) {
        height = [self.dataSource heightForSheetCellAtIndex:indexPath.row];
    } else {
        height = (self.actionSheet.frame.size.height - self.actionSheet.tableHeaderView.frame.size.height - self.actionSheet.tableFooterView.frame.size.height) / [self.dataSource numberOfSheetCell];
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sheetCellForRowAtIndex:)]) {
        NSString *identifier = [NSString stringWithFormat:@"kIdentifier%zi", indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [self.dataSource sheetCellForRowAtIndex:indexPath.row];
        }
    }
    return cell;
}

#pragma mark - setupActionSheetHeaderAndFooter 📌
- (void)setupActionSheetHeaderAndFooter
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sheetViewHeader)]) {
        self.actionSheet.tableHeaderView = [self.dataSource sheetViewHeader];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(sheetViewFooter)]) {
        self.actionSheet.tableFooterView = [self.dataSource sheetViewFooter];
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

#pragma mark - lazyloads 📌
- (UITableView *)actionSheet
{
    if (!_actionSheet) {
        CGRect frame      = self.frame;
        UITableView *tb   = [[UITableView alloc] initWithFrame:CGRectMake(frame.origin.x, self.keyWindow.frame.size.height, frame.size.width, frame.size.height)];
        tb.separatorStyle = (UITableViewCellSeparatorStyle)self.separatorStyle;
        tb.dataSource     = self;
        tb.delegate       = self;
        _actionSheet      = tb;
    }
    return _actionSheet;
}

- (UIView *)maskView
{
    if (!_maskView) {
        UIView *mask         = [[UIView alloc] initWithFrame:[self maskViewFrameCalc]];
        mask.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7];
        [mask addGestureRecognizer:self.tapGR];
        _maskView            = mask;
        _maskView.hidden     = YES;
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
