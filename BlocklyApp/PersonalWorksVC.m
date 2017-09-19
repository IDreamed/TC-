//
//  PersonalWorksVC.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/7.
//  Copyright © 2017年 text. All rights reserved.
//

#import "PersonalWorksVC.h"
#import "PersonalWorksCell.h"
#import "HTTPRequest.h"
#import "PersonalWorksModel.h"
#import "BlockVC.h"

@interface PersonalWorksVC () <UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (copy, nonatomic) NSString * cellKey;
@property (strong, nonatomic) NSMutableArray * dataSource;
@property (weak, nonatomic) IBOutlet UILabel *titlLabel;

@end

@implementation PersonalWorksVC

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlLabel.font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.dataSource = [NSMutableArray array];
    self.cellKey = @"PersonalWorksCell";
    
    [self getHttpData];
    
}

- (void)getHttpData {
    
    SetModel * model = [APPControll getUserInfo];
    NSDictionary * parameter = @{@"uid":model.uid, @"token":model.token, @"type":@([HTTPRequest getAppType])};
    [[HTTPRequest sharedHttpRequest] postUrl:@"g=portal&m=app&a=find_program_list" parameter:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = responseObject;
        NSArray * datas = dic[@"data"];
        
        NSMutableArray * models = [PersonalWorksModel mj_objectArrayWithKeyValuesArray:datas];
        self.dataSource = models;
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CustomHUD showText:@"加载数据失败"];
    }];
    
}


    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backClink:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - collection view data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PersonalWorksCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellKey forIndexPath:indexPath];
    PersonalWorksModel * model = self.dataSource[indexPath.row];
    
    [cell updateValueWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.deleteCallback = ^(PersonalWorksCell *cell) {
        
        [weakSelf delegateCell:cell];
        
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
    PersonalWorksModel * model = self.dataSource[indexPath.item];
    BlockVC * bvc = [[BlockVC alloc] init];
    
    bvc.isHighLive = model.level;
    bvc.isChange = YES;
    bvc.wid = model.wid;
    bvc.appTitle = model.title;
    bvc.content = model.content;
    
    [self.navigationController pushViewController:bvc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    UICollectionViewFlowLayout * layout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    CGFloat speace = layout.minimumLineSpacing;
    
    CGFloat width = (screenSize.width - speace * 5)/4;
    CGFloat height = width/3.0*4.2;
    
    return CGSizeMake(width, height);
}


- (void)delegateCell:(PersonalWorksCell *)cell {
    
    HTTPRequest * request = [HTTPRequest sharedHttpRequest];
    SetModel * model = [APPControll getUserInfo];

    NSDictionary * dic = @{@"uid":model.uid,@"id":cell.model.wid,@"token":model.token};
    __weak typeof(self) weakSlef = self;
    [request postUrl:@"g=portal&m=app&a=delete_program" parameter:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            
            [weakSlef.dataSource removeObject:cell.model];
            [weakSlef.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CustomHUD showText:@"删除失败，请重试"];
    }];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
