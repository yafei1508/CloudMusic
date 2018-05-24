//
//  RootTableViewController.m
//  CloudMusic
//
//  Created by lyf on 2018/5/10.
//  Copyright © 2018年 lyf. All rights reserved.
//

#import "RootTableViewController.h"
#import <BmobSDK/BmobQuery.h>
#import "MusicObj.h"
#import "PlayerViewController.h"
#import "AppDelegate.h"
@interface RootTableViewController ()
@property(nonatomic,strong)AppDelegate *appDelegate;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *loveIcons;
@end

@implementation RootTableViewController
- (IBAction)loveThisMusic:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    //修改navigationBar的颜色为红色
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    //将通知栏颜色改为亮色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [self initData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) initData {
    self.appDelegate.musicList = [[NSMutableArray alloc]init];
    BmobQuery *query = [BmobQuery queryWithClassName:@"MusicInfo"];
    [query orderByDescending:@"updatedAt"];
    query.limit = 20;
    //执行查询
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //处理查询结果
        for (BmobObject *obj in array) {
            MusicObj *info    = [[MusicObj alloc] init];
            if ([obj objectForKey:@"music_name"]) {
                info.musicName    = [obj objectForKey:@"music_name"];
                NSLog(@"%@", info.musicName);
            }
            if ([obj objectForKey:@"music_url"]) {
                info.musicUrl  = [obj objectForKey:@"music_url"];
            }
            if ([obj objectForKey:@"music_singer"]) {
                info.musicSinger = [obj objectForKey:@"music_singer"];
            }
            if ([obj objectForKey:@"image_url"]) {
                info.imageUrl = [obj objectForKey:@"image_url"];
            }
            [self.appDelegate.musicList addObject:info];
        }
        
        [self.tableView reloadData];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.appDelegate.musicList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [[self.appDelegate.musicList objectAtIndex:indexPath.row] musicName];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"PlayThisMusic"]) {
        NSIndexPath *index = [self.tableView indexPathForSelectedRow];
        _appDelegate.musicObj = [_appDelegate.musicList objectAtIndex:index.row];
        _appDelegate.musicIndex = index.row;
        PlayerViewController *playerViewController = segue.destinationViewController;
        playerViewController.intoViewType = 1;
    }else if([segue.identifier isEqualToString:@"ShowPlayerView"]) {
        PlayerViewController *playerViewController = segue.destinationViewController;
        playerViewController.intoViewType = 0;
    }
}


@end
