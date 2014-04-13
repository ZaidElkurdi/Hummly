//
//  ViewController.m
//  LAHacks
//
//  Created by Aryaman Sharda on 4/11/14.
//  Copyright (c) 2014 LaHacks. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController
{
    searchBar *searchView;
    UIImageView *autocompleteBorder;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    self.pastUrls = [[NSArray alloc] init];
    
    
    //autocompleteBorder = [[UIImageView alloc] initWithFrame:CGRectMake(20,215,285,130 )];
    //autocompleteBorder.image = [UIImage imageNamed:@"autocompleteBorder.png"];
    //autocompleteBorder.hidden = true;
    //[self.view addSubview:autocompleteBorder];
    
    
    
    searchView = [[searchBar alloc] initWithFrame:self.view.frame];
    searchView.searchField.delegate=self;
    [self.view addSubview:searchView];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.categoryView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 345, 320, 200) collectionViewLayout:layout];
    self.categoryView.backgroundColor = [UIColor clearColor];
    self.categoryView.delegate = self;
    self.categoryView.dataSource = self;
    self.categoryView.showsHorizontalScrollIndicator = FALSE;
    
    [self.view addSubview:self.categoryView];
    
    NSArray *categories = [NSArray arrayWithObjects:@"Rock", @"Pop", @"Jazz", @"Country", @"Alternative", nil];
    NSArray *values = [NSArray arrayWithObjects:@"100", @"65", @"30", @"24", @"103", nil];
    NSDictionary *testDict = [NSDictionary dictionaryWithObjects:values forKeys:categories];
    
    [self.categoryView registerClass:[categoryCardCell class] forCellWithReuseIdentifier:@"categoryCellIdentifier"];
    
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(25, 228, 275, 111) style:UITableViewStylePlain];
    //self.autocompleteTableView.delegate=self;
    //self.autocompleteTableView.dataSource=self;
    //self.autocompleteTableView.allowsSelectionDuringEditing = YES;
    //[self.view addSubview:self.autocompleteTableView];
    //self.autocompleteTableView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark TextView methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"Being called");
    if(self.autocompleteTableView.hidden==true)
    {
        self.autocompleteTableView.hidden = FALSE;
        autocompleteBorder.hidden = FALSE;
    }
    
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
    }
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    NSString *compareText = [substring stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([compareText isEqualToString:@""])
    {
        self.autocompleteTableView.hidden=TRUE;
        autocompleteBorder.hidden=TRUE;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:
     ^{
         CGRect newFrame = searchView.frame;
         newFrame.origin.y -= 110;
         searchView.frame=newFrame;
     }
     
                     completion:nil];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:500.0f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:
     ^{
         CGRect newFrame = searchView.frame;
         newFrame.origin.y += 110;
         searchView.frame=newFrame;
     }
     
                     completion:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(CGRectContainsPoint(self.autocompleteTableView.bounds, [touches.anyObject locationInView:self.autocompleteTableView])==false)
        [self endEditView]; // dismiss the keyboard
    
    if(CGRectContainsPoint(self.autocompleteTableView.bounds, [touches.anyObject locationInView:self.autocompleteTableView])&&self.autocompleteTableView.hidden==true)
        [self endEditView];
    
    [super touchesBegan:touches withEvent:event];
}

#pragma  -mark viewMethods
-(void)endEditView
{
    [self.view endEditing:YES]; // dismiss the keyboard
    self.autocompleteTableView.hidden = TRUE;
    autocompleteBorder.hidden = TRUE;
}

#pragma -mark autocomplete methods

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
{
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    [self.autocompleteUrls removeAllObjects];
    for(NSMutableString *curString in self.pastUrls) {
        
        NSString * temp = [substring lowercaseString];
        NSString * temp2 = [curString lowercaseString];
        
        NSRange substringRange = [temp2 rangeOfString:temp];
        
        if (substringRange.location != NSNotFound) {
            [self.autocompleteUrls addObject:curString];
        }
    }
    
    [self.autocompleteTableView reloadData];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.autocompleteTableView.hidden = FALSE;
    
    NSString *substring = [NSString stringWithString:searchBar.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:text];
    [self searchAutocompleteEntriesWithSubstring:substring];
    
    NSString *compareText = [substring stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([compareText isEqualToString:@""])
        self.autocompleteTableView.hidden = TRUE;
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    cell.textLabel.text = @"Search Results";
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15.0f];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return 4;//return self.autocompleteUrls.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Calling selected");
}
#pragma -mark Collection View Methods

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CREATING CELL");
    static NSString *categoryIdentifier = @"categoryCellIdentifier";
    
    categoryCardCell *collectionCell = nil;
    collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:categoryIdentifier forIndexPath:indexPath];
    
    if(collectionCell==nil)
    {
        collectionCell = [[categoryCardCell alloc] init];
    }
    UIColor *cardColor = [UIColor clearColor];
    UIImage *cardGraphic;
    NSString *title = @"Placeholder";
    CGRect cardGraphicFrame = CGRectMake(0, 0, 0, 0);
    switch(indexPath.row)
    {
        case 0:
            cardColor = [UIColor colorWithRed:95.0f/255.0f green:188.0f/255.0f blue:245.0f/255.0f alpha:1.0f];
            cardGraphic = [UIImage imageNamed:@"microphoneIcon.png"];
            cardGraphicFrame = CGRectMake(35, 20, 45, 80);
            title = @"Popular";
            break;
        case 1:
            cardColor = [UIColor colorWithRed:233.0f/255.0f green:89.0f/255.0f blue:114.0f/255.0f alpha:1.0f];
            cardGraphic = [UIImage imageNamed:@"countryIcon.png"];
            cardGraphicFrame = CGRectMake(15, 30, 88, 55);
            title = @"Country";
            break;
        case 2:
            cardColor = [UIColor colorWithRed:147.0f/255.0f green:165.0f/255.0f blue:177.0f/255.0f alpha:1.0f];
            cardGraphic = [UIImage imageNamed:@"familyIcon.png"];
            cardGraphicFrame = CGRectMake(10, 25, 95, 70);
            title = @"Kid-Friendly";
            break;
        case 3:
            cardColor = [UIColor colorWithRed:80.0f/255.0f green:173.0f/255.0f blue:178.0f/255.0f alpha:1.0f];
            cardGraphic = [UIImage imageNamed:@"guitarIcon.png"];
            cardGraphicFrame = CGRectMake(18, 20, 85, 80);
            title = @"Rock and Roll";
            break;
        case 4:
            cardColor = [UIColor colorWithRed:255.0f/255.0f green:175.0f/255.0f blue:9.0f/255.0f alpha:1.0f];
            cardGraphic = [UIImage imageNamed:@"boomboxIcon.png"];
            cardGraphicFrame = CGRectMake(15, 25, 95, 80);
            title = @"Hip Hop";
            break;
    }
    collectionCell.cardLabel.text = title;
    collectionCell.cardGraphic.frame = cardGraphicFrame;
    collectionCell.cardGraphic.image = cardGraphic;
    collectionCell.backgroundColor = cardColor;
    
    return collectionCell;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(120, 180);
}


@end