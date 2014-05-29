//
//  categoryCardCell.m
//  LAHacks
//
//  Created by Zaid Elkurdi on 4/12/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import "categoryCardCell.h"

@implementation categoryCardCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *cardView = [[UIImageView alloc] init];
        self.cardGraphic = cardView;
        
        CGRect labelFrame = CGRectMake(5, 100, 110, 40);
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:labelFrame];
        categoryLabel.textAlignment = NSTextAlignmentCenter;
        categoryLabel.adjustsFontSizeToFitWidth = TRUE;
        categoryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0];
        categoryLabel.textColor = [UIColor whiteColor];
        self.cardLabel = categoryLabel;
        
        [self addSubview:categoryLabel];
        [self addSubview:cardView];
        // Initialization code
        
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
    return self;
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
