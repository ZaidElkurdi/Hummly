//
//  categoryTiles.m
//  LAHacks
//
//  Created by Zaid Elkurdi on 4/12/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import "categoryTiles.h"
#import "math.h"
@implementation categoryTiles

- (id)initWithFrame:(CGRect)frame withDictionary:(NSDictionary*)dictionary
{
    self.sizeDict = [[NSMutableDictionary alloc] init];
    self.categoryDict = [[NSDictionary alloc] init];
    self.categoryDict = dictionary;
    
    self = [super initWithFrame:frame];
    if (self)
    {
        [self calculateSizes];
        [self determinePlacement];
    }
    return self;
}

-(void)calculateSizes
{
    NSArray *keyArray =  [self.categoryDict allKeys];
    int count = [keyArray count];
    double totalPopularity = 0;
    for (int i=0; i < count; i++)
    {
       totalPopularity += [[self.categoryDict objectForKey:[keyArray objectAtIndex:i]] doubleValue];
    }
    
    NSLog(@"Total is: %f",totalPopularity);
    
    for (int i=0; i < count; i++)
    {
        double currPopularity = [[self.categoryDict objectForKey:[keyArray objectAtIndex:i]] doubleValue];
        double relativePopularity = currPopularity/totalPopularity;
        NSLog(@"Relative is: %f",relativePopularity);
        NSNumber *numBlocks = [NSNumber numberWithDouble:round(relativePopularity*24)];
        [self.sizeDict setObject:numBlocks forKey:[keyArray objectAtIndex:i]];
    }
    
    NSLog(@"%@",self.sizeDict);
}

-(void)determinePlacement
{
    NSMutableArray *boardArray = [[NSMutableArray alloc] initWithObjects:[[NSMutableArray alloc] initWithCapacity:4],[[NSMutableArray alloc] initWithCapacity:4],[[NSMutableArray alloc] initWithCapacity:4],[[NSMutableArray alloc] initWithCapacity:4],[[NSMutableArray alloc] initWithCapacity:4],[[NSMutableArray alloc] initWithCapacity:4], nil];
    
    NSArray *sizeArray =  [self.sizeDict allKeys];
    int count = [sizeArray count];
    bool solutionFound=false;
    while(!solutionFound)
    {
        for (int i=0; i < count; i++)
        {
            NSLog(@"On Genre %d",i);
            NSInteger numBlocks = [[self.sizeDict objectForKey:[sizeArray objectAtIndex:i]] intValue];
            bool finishedPlacing=false;
            for(NSMutableArray *yArray in boardArray)
            {
                for (int x=0; x < 6; x++)
                {
                    if([yArray count] < 4)
                    {
                        NSLog(@"Placed a block");
                        [yArray addObject:[NSNumber numberWithInt:i]];
                        numBlocks--;
                    }
                    
                    if(numBlocks==0)
                    {
                        finishedPlacing=true;
                        break;
                    }
                    
                    else
                        break;
                    
                }
                
                if(finishedPlacing==true)
                    break;
            }
            
        }
        solutionFound = true;
    }
    NSLog(@"Board: %@",boardArray);
}
@end
