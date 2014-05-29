//
//  categoryTiles.h
//  LAHacks
//
//  Created by Zaid Elkurdi on 4/12/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface categoryTiles : UIView
@property (nonatomic, strong) NSDictionary *categoryDict;
@property (nonatomic, strong) NSMutableDictionary *sizeDict;
- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary*)dictionary;
@end
