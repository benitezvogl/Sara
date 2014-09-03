//
//  PdTableListViewController.m
//  SARA
//
//  Created by Chris Yanc on 3/21/14.
//
//

#import "PdTableListViewController.h"
#import "FVData.h"

@interface PdTableListViewController ()

@end

@implementation PdTableListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.PdTable.delegate = self;
    self.PdTable.dataSource = self;
    // Do any additional setup after loading the view from its _nib.
    self.tableData = [self LoadFilesFromDirectory];
    
}


-(NSURL*) ApplicationDataDirectory {
    NSFileManager* sharedFM = [NSFileManager defaultManager];
    NSArray* possibleURLs = [sharedFM URLsForDirectory:NSApplicationSupportDirectory
                                             inDomains:NSUserDomainMask];
    NSURL* appSupportDir = nil;
    NSURL* appDirectory = nil;
    
    if ([possibleURLs count] >= 1) {
        // Use the first directory (if multiple are returned)
        appSupportDir = [possibleURLs objectAtIndex:0];
    }
    
    // If a valid app support directory exists, add the
    // app's bundle ID to it to specify the final directory.
    if (appSupportDir) {
        NSString* appBundleID = [[NSBundle mainBundle] bundleIdentifier];
        appDirectory = [appSupportDir URLByAppendingPathComponent:appBundleID];
    }
    
    return appDirectory;
}

-(NSMutableArray*) LoadFilesFromDirectory{
    NSMutableArray *returnList = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSLog(@"Directory: %@", documentsDirectory);
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    [returnList addObject:@"Gyro"];
    [returnList addObject:@"Color"];
    [returnList addObject:@"Synth Gyro"];
    [returnList addObject:@"Synth Color"];
    [returnList addObject:@"Arpeggo Synth Gyro and Color"];
    
    for (NSString *s in fileList){
        if([s.pathExtension isEqualToString: @"pd"]){
            //NSLog(@"%@", s);
            [returnList addObject:s];
        }
    }
    
    return returnList;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FVData *obj=[FVData getInstance];
    NSString *pdfile = obj.pd;
    NSString *rowName = [self.tableData objectAtIndex:indexPath.row];
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        
    }
    [cell.textLabel setText:[self.tableData objectAtIndex:indexPath.row]];
    
    if(rowName == pdfile){
        //[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        //[cell setSelected:YES];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@", [self.tableData objectAtIndex:indexPath.row]);
    
    FVData *obj=[FVData getInstance];
    [obj PDFile:[self.tableData objectAtIndex:indexPath.row]];
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_PdTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPdTable:nil];
    [super viewDidUnload];
}
@end
