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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.autocompleteTableView.delegate=self;
    self.autocompleteTableView.dataSource=self;
    
    self.autocompleteUrls = [[NSMutableArray alloc] init];
    
    self.autocompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 215, 300, 150) style:UITableViewStylePlain];
    self.autocompleteTableView.scrollEnabled = YES;
    self.autocompleteTableView.hidden = YES;
    [self.view addSubview:self.autocompleteTableView];
    
    self.pastUrls = [[NSArray alloc] init];
    
    searchView = [[searchBar alloc] initWithFrame:self.view.frame];
    searchView.searchField.delegate=self;
    [self.view addSubview:searchView];
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(10, 345, 300, 200)];
    test.backgroundColor = [UIColor redColor];
    [self.view addSubview:test];
    
    NSArray *categories = [NSArray arrayWithObjects:@"Rock", @"Pop", @"Jazz", @"Country", @"Alternative", nil];
    NSArray *values = [NSArray arrayWithObjects:@"100", @"65", @"30", @"24", @"103", nil];
    NSDictionary *testDict = [NSDictionary dictionaryWithObjects:values forKeys:categories];
    
    categoryTiles *tiles = [[categoryTiles alloc] initWithFrame:CGRectMake(10, 345, 300, 200) withDictionary:testDict];
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
    
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
        return NO;
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

    [self endEditView]; // dismiss the keyboard
    
    [super touchesBegan:touches withEvent:event];
}

#pragma  -mark viewMethods
-(void)endEditView
{
    [self.view endEditing:YES]; // dismiss the keyboard
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
    
    cell.textLabel.text = [self.autocompleteUrls objectAtIndex:indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    return self.autocompleteUrls.count;
}


@end
