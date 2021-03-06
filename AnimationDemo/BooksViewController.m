//
//  BooksViewController.m
//  AnimationDemo
//
//  Created by Rachel Bobbins on 1/31/15.
//  Copyright (c) 2015 Rachel Bobbins. All rights reserved.
//

#import "BooksViewController.h"
#import "BookCell.h"

static NSString * const kBookCellIdentifier = @"kBookCellIdentifier";

@interface BooksViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSDictionary *bookDescriptions;
@property (strong, nonatomic) NSArray *bookTitles;
@property (strong, nonatomic) NSMutableSet *expandedIndexPaths;
@end

@implementation BooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([BookCell class])
                                    bundle:nil];
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:kBookCellIdentifier];
    self.expandedIndexPaths = [NSMutableSet set];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.title = @"Foldable UITableViewCells";
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookCell *cell = (id)[tableView dequeueReusableCellWithIdentifier:kBookCellIdentifier];
    NSString *bookTitle = self.bookTitles[indexPath.row];
    cell.bookTitleLabel.text = bookTitle;
    cell.bookDescriptionLabel.text = self.bookDescriptions[bookTitle];
    cell.withDetails = [self.expandedIndexPaths containsObject:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if ([self.expandedIndexPaths containsObject:indexPath]) {
        BookCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        [cell animateClosed];
        [self.expandedIndexPaths removeObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        [self.expandedIndexPaths addObject:indexPath];
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        BookCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
        [cell animateOpen];
    }
}

#pragma mark - Private

- (NSArray *)bookTitles {
    if (!_bookTitles) {
        _bookTitles = [self.bookDescriptions allKeys];
    }
    return _bookTitles;
}

- (NSDictionary *)bookDescriptions {
    if (!_bookDescriptions) {
       _bookDescriptions = @{
          @"Harry Potter and the Deathly Hallows": @"The final book in the Harry Potter series.",
          @"A Tale of Two Cities": @"It was the best of times, when Mr. Dickens loved rhymes.",
          @"A Tree Grows in Brooklyn": @"Also, a young author grows up in Brooklyn.",
          @"Moby Dick" : @"This book is a whale of a good time!",
          @"Great Gatsby" : @"The book that inspired thousands of obliviously themed parties!",
          };
    }
    return _bookDescriptions;
}


@end
