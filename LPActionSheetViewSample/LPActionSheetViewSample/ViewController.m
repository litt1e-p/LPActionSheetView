//
//  ViewController.m
//  LPActionSheetViewSample
//
//  Created by litt1e-p 16/2/22.
//  Copyright © 2016年 litt1e-p. All rights reserved.
//

#import "ViewController.h"
#import "LPActionSheetView.h"

@interface ViewController ()<LPActionSheetViewDataSource, LPActionSheetViewDelegate>

@property (nonatomic, strong) LPActionSheetView *actionSheetView;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UIView *footer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"LPActionSheetView";
    self.view.backgroundColor = [UIColor redColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.actionSheetView show];
    //    NSLog(@"%@", self.actionSheetView.selectedSheetCell);
//        NSLog(@"%@", self.actionSheetView.allSheetCells);
}

- (LPActionSheetView *)actionSheetView
{
    if (!_actionSheetView) {
        CGFloat height = self.view.frame.size.height * 0.4;
        LPActionSheetView *actionSheetView = [[LPActionSheetView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height  - height, self.view.frame.size.width, height)];
        actionSheetView.maskViewExtend = LPMaskViewExtendUnderNavigationBar;
        actionSheetView.delegate = self;
        actionSheetView.dataSource = self;
        actionSheetView.separatorStyle = LPActionSheetCellSeparatorStyleUnderLine;
        self.actionSheetView = actionSheetView;
    }
    return _actionSheetView;
}

#pragma mark - LPActionSheetViewDataSource 📌
- (NSInteger)numberOfSheetCell
{
    return 3;
}

//- (CGFloat)heightForSheetCellAtIndex:(NSInteger)index
//{
//    return 44;
//}

- (LPActionSheetCell *)sheetCellForRowAtIndex:(NSInteger)index
{
    LPActionSheetCell *cell = nil;
    switch (index) {
        case 0:
            cell = [[LPActionSheetCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
            cell.detailTextLabel.text = @"I am row 1";
            break;
            
        case 1:
            cell = [[LPActionSheetCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
            cell.detailTextLabel.text = @"I am row 2";
            break;
            
        case 2:
            cell = [[LPActionSheetCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
            cell.detailTextLabel.text = @"I am row 3";
            break;
            
        default:
            break;
    }
    return cell;
}

- (UIView *)sheetViewHeader
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    header.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 35)];
    la.text = @"I am title";
    la.textColor = [UIColor blackColor];
    la.textAlignment = NSTextAlignmentCenter;
    [header addSubview:la];
    la.center = header.center;
    self.header = header;
    return header;
}

- (UIView *)sheetViewFooter
{
    UIButton *footer = [UIButton buttonWithType:UIButtonTypeCustom];
    footer.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    footer.backgroundColor = [UIColor greenColor];
    [footer setTitle:@"cancel" forState:UIControlStateNormal];
    [footer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footer addTarget:self action:@selector(didClickFooterBtn) forControlEvents:UIControlEventTouchUpInside];
    return footer;
}

- (void)didClickFooterBtn
{
    [self.actionSheetView dismiss];
}

#pragma mark - LPActionSheetViewDelegate 📌
- (void)didSelectedSheetRowAtIndex:(NSInteger)index
{
    NSLog(@"selected row at %zi", index);
    NSLog(@"%@", self.actionSheetView.allSheetCells);
}

- (void)didDeSelectedSheetRowAtIndex:(NSInteger)index
{
    NSLog(@"deselected row at %zi", index);
}

@end
