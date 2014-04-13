//
//  ViewController.h
//  LAHacks
//
//  Created by Aryaman Sharda on 4/11/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchBar.h"
#import "categoryCardCell.h"
#import <sqlite3.h>
#import "SerumDB.h"

@interface ViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
        NSArray *tableData;
}
@property (nonatomic, retain) NSMutableArray *songArray;
@property (nonatomic, retain) NSMutableArray *autocompleteUrls;
@property (nonatomic, retain) UICollectionView *categoryView;
@property (nonatomic, retain) UITableView *autocompleteTableView;
@property (nonatomic) sqlite3 *database;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
@end
