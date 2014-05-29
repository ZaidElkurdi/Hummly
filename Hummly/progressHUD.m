//
//  progressHUD.m
//  Serum
//
//  Created by Zaid Elkurdi on 3/21/14.
//  Copyright (c) 2014 Aryaman Sharda. All rights reserved.
//

#import "progressHUD.h"

@implementation progressHUD

- (id)initWithFrame:(CGRect)frame
{
    NSInteger xOrigin = 80;
    NSInteger yOrigin = (frame.size.height/2)-140;
    CGRect hudFrame = CGRectMake(xOrigin, yOrigin, 160, 160);
    
    self = [super initWithFrame:frame];
    if (self)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:hudFrame];
        bgView.backgroundColor = [UIColor grayColor];
        bgView.alpha = 0.7f;
        [bgView.layer setCornerRadius:8.0f];
        bgView.layer.borderColor = [UIColor grayColor].CGColor;
        bgView.layer.borderWidth = 2.0f;
        [bgView.layer setMasksToBounds:YES];
        
        NSInteger xOrigin = 60;
        NSInteger yOrigin = 40;

        CGRect progressFrame = CGRectMake(xOrigin, yOrigin, 40, 40);
        self.progressIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.progressIndicator.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.progressIndicator.frame = progressFrame;
        
        
        CGRect labelFrame = CGRectMake(35, yOrigin+70, 100, 20);
        UILabel *progressMessage = [[UILabel alloc] initWithFrame:labelFrame];
        progressMessage.textColor = [UIColor whiteColor];
        progressMessage.text = @"Processing";
        
        [bgView addSubview:progressMessage];
        [bgView addSubview:self.progressIndicator];
        [self addSubview:bgView];
    
        [self.progressIndicator startAnimating];
    }
    return self;
}

- (void)initViewWithFrame:(CGRect)frame
{

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
