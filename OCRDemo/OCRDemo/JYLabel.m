//
//  JYLabel.m
//  OCRDemo
//
//  Created by jason on 2017/7/10.
//  Copyright © 2017年 jason. All rights reserved.
//

#import "JYLabel.h"

@interface JYLabel()

@property(nonatomic,strong)UIPasteboard * pasteborad;

@end

@implementation JYLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.numberOfLines = 0;
        self.pasteborad = [UIPasteboard generalPasteboard];
        [self attachHandle];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.numberOfLines = 0;
    self.pasteborad = [UIPasteboard generalPasteboard];
    [self attachHandle];
}

-(void)attachHandle
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tap];
}

-(void)handleTap:(UITapGestureRecognizer *)tap
{
    [self becomeFirstResponder];
    UIMenuController * menu = [UIMenuController sharedMenuController];
    [menu setTargetRect:self.frame inView:self.superview];
    [menu setMenuVisible:YES animated:YES];
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:)) {
        return YES;
    }
    if (action == @selector(paste:)) {
        return YES;
    }
    if (action == @selector(delete:)) {
        return YES;
    }
    if (action == @selector(selectAll:)) {
        return YES;
    }
    if (action == @selector(cut:)) {
        return YES;
    }
    return NO;
}

-(void)paste:(id)sender
{
    self.text = self.pasteborad.string;
    NSLog(@"剪切");
}


- (void)copy:(id)sender {
    //    self.pasteBoard.string = self.text;
    //    NSLog(@"复制");
    self.pasteborad.string = self.text;
//    self.pasteborad.color = self.backgroundColor;
}

-(void)cut:(id)sender {
    self.pasteborad.string = self.text;
    self.text = @"";
    NSLog(@"剪切");
}

- (void)delete:(id)sender {
    self.text = nil;
    self.pasteborad = nil;
}

- (void)selectAll:(id)sender {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    pasteBoard.string = self.text;
    self.textColor = [UIColor blueColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
