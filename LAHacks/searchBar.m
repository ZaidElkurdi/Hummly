//
//  searchBar.m
//  LAHacks
//
//  Created by Zaid Elkurdi on 4/12/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import "searchBar.h"

@implementation searchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initInterface];
    }

    return self;
}

-(void)initInterface
{
    CGRect bgFrame = CGRectMake(10, 250, 300, 75);
    UIView *bg = [[UIView alloc] initWithFrame:bgFrame];
    bg.backgroundColor = [UIColor colorWithRed:234.0f/255.0f green:95.0f/255.0f blue:56.0f/255.0f alpha:1.0];
    self.bgView = bg;
    [self addSubview:bg];
    
    CGRect coverFrame = CGRectMake(16, 256, 288, 63);
    UIView *cover = [[UIView alloc] initWithFrame:coverFrame];
    cover.backgroundColor = [UIColor whiteColor];
    self.coverView = cover;
    [self addSubview:cover];
    
    CGRect searchFrame = CGRectMake(20, 256, 255, 63);
    UITextField *searchBar = [[UITextField alloc] initWithFrame:searchFrame];
    searchBar.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:27.0f];
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.placeholder = @"Search for a song";
    searchBar.returnKeyType = UIReturnKeySearch;
    self.searchField = searchBar;
    [self addSubview:searchBar];
    
    CGRect magnifyingFrame = CGRectMake(270, 275, 25, 30);
    UIImageView *magnifyingView = [[UIImageView alloc] initWithFrame:magnifyingFrame];
    magnifyingView.image = [UIImage imageNamed:@"magnifyingGlass.png"];
    [self addSubview:magnifyingView];
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect = 
    [[UIInterpolatingMotionEffect alloc] 
    initWithKeyPath:@"center.y"
             type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);

    // Set horizontal effect 
    UIInterpolatingMotionEffect *horizontalMotionEffect = 
    [[UIInterpolatingMotionEffect alloc] 
    initWithKeyPath:@"center.x"     
             type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);

    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];

    // Add both effects to your view
    [self addMotionEffect:group];
    
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
