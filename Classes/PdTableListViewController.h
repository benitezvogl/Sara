//
//  PdTableListViewController.h
//  SARA
//
//  Created by Chris Yanc on 3/21/14.
//
//

#import <UIKit/UIKit.h>

@interface PdTableListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{

}
@property (retain, nonatomic) IBOutlet UITableView *PdTable;
@property (retain, nonatomic) NSMutableArray *tableData;

@end
