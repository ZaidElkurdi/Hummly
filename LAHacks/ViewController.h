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
        sqlite3 *database;
}
@property (nonatomic, retain) NSArray *pastUrls;
@property (nonatomic, retain) NSMutableArray *autocompleteUrls;
@property (nonatomic, retain) UICollectionView *categoryView;
@property (nonatomic, retain) UITableView *autocompleteTableView;
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring;
@end
