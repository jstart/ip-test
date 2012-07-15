//
//  IPBookmarkSearchViewController.h
//  IPTest
//
//  Created by Truman, Christopher on 7/14/12.
//
//

#import <UIKit/UIKit.h>

@interface IPBookmarkSearchViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
