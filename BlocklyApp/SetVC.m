//
//  SetVC.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "SetVC.h"
#import "SetTableCell.h"
#import "SetModel.h"
#import "APPControll.h"
#import "HTTPRequest.h"
#import "ImageVC.h"
@interface SetVC () <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate, UIImagePickerControllerDelegate>
    
    @property (nonatomic, copy) NSString * cellKey;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    
    @property (nonatomic, strong) NSMutableArray * dataSource;
    
    @property (nonatomic, strong) SetModel * model;
    
    @property (nonatomic, strong) UIImagePickerController * imgPicker;
    
    
    @end

@implementation SetVC
    
- (BOOL)shouldAutorotate {
    return YES;
}
    
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cellKey = @"SetTableCell";
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = [NSMutableArray arrayWithArray:@[@"头像",@"昵称",@"性别",@"手机号",@"程序延迟时间(ms)",@"判断程序延迟时间(ms)",@"红外线参数配置",@"声控参数配置",@"亮度参数控制"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.model = [APPControll getUserInfo];
    [APPControll registForKeybordNotificationWithObserver:self showAction:@selector(keyBordShow:) hidenAction:@selector(keyBorkHidden:)];
    
}
    
    - (IBAction)backClink:(id)sender
    {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
- (IBAction)sinoutClink:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
    
- (IBAction)saveAction:(id)sender {
    
    [self.view endEditing:YES];
    
    UIImage * image = [HTTPRequest sharedHttpRequest].image;
    if (image) {
        
        __block __weak SetModel * weakModel = self.model;
        __block __weak SetVC * weakSelf = self;
        [[HTTPRequest sharedHttpRequest] postHrardImageWidthcallback:^(NSString *str) {
            
            weakModel.avatar = str;
            
            [weakSelf saveChangeWidth:0];
            
        }];
        
    } else {
        
        [self saveChangeWidth:1];
    }
    
    
}
    
- (void)saveChangeWidth:(int)index {
    
    SetModel * model = [APPControll getUserInfo];
    
    NSArray * propertys = [APPControll getPropertyNamesForClass:[SetModel class]];
    
    NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    for (int i = index; i<4; i++) {
        
        NSString * key = propertys[i];
        
        NSString * old = [model valueForKey:key];
        NSString * new = [self.model valueForKey:key];
        
        if (![new isEqualToString:old]) {
            
            [dic setObject:new forKey:key];
        }
        
    }
    [dic setObject:model.uid forKey:@"id"];
    NSString * json = [dic mj_JSONString];
    NSDictionary * diction = @{@"token":model.token,@"data":json,@"id":model.uid};
    
    [[HTTPRequest sharedHttpRequest] postUrl:@"g=portal&m=app&a=update_info" parameter:diction progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HTTPRequest sharedHttpRequest].image = nil;
        [APPControll writeUserInfo:[self.model mj_keyValues]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [CustomHUD showText:@"保存失败请重试"];
        
    }];
    
    
}
    
    //tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SetTableCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellKey forIndexPath:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        [cell updateCellWithName:self.dataSource[indexPath.row] index:indexPath.row];
        
        return  cell;
    }
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 100;
}
    
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        SetTableCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 0) {
            
            [self.view endEditing:YES];
            
            NSArray * titles = @[@"从相册选取",@"拍照",@"取消"];
            
            [self ShowActionSheetWith:titles blocks:@[^{ [self openImagePickerWithType:NO]; },^{ [self openImagePickerWithType:YES]; },^{ }] clinkView:cell];
            
            
            
        } else if (indexPath.row == 2) {
            
            [self.view endEditing:YES];
            
            NSArray * titles = @[@"男",@"女",@"取消"];
            NSArray * blocks = @[^{
                self.model.sex = @"0";
                [self.tableView reloadData];},
                                  ^{
                                      self.model.sex = @"1";
                                      [self.tableView reloadData];
                                  },^{}];
            
            [self ShowActionSheetWith:titles blocks:blocks clinkView:cell];
            
        } else {
            
            
            [cell.inputView becomeFirstResponder];
        }
    }
    
- (void)ShowActionSheetWith:(NSArray *)titles blocks:(NSArray *)blocks clinkView:(UIView *)view {
    
    UIAlertController * avc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i=0; i<titles.count; i++) {
        
        UIAlertAction * action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            void (^bloc)() = blocks[i];
            bloc();
            
        }];
        
        if (i == titles.count -1) {
            action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleCancel handler:nil];
        }
        [avc addAction:action];
    }
    
    UIPopoverPresentationController *popover = avc.popoverPresentationController;
    
    if (popover) {
        
        popover.sourceView = view;
        popover.sourceRect = view.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    
    [self presentViewController:avc animated:YES completion:nil];
    
}
    
- (void)cencelSelect {
    
    [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    
}
    
- (void)openImagePickerWithType:(BOOL)isCap {
    
    self.imgPicker = [[ImageVC alloc] init];
    self.imgPicker.delegate = self;
    self.imgPicker.allowsEditing = YES;
    
    UIPopoverPresentationController * popPC;
    
    if (isCap) {
        
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"打开相机");
            [self.imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            self.imgPicker.modalPresentationStyle = UIModalPresentationFullScreen;  //苹果推荐使用全屏
            popPC =self.imgPicker.popoverPresentationController;
            //            [popPC setSourceRect:CGRectMake(0, 0, 600, 600)];
            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popPC.delegate=self;
            popPC.sourceView = self.tableView;
            popPC.sourceRect = CGRectMake(0, 0, self.tableView.bounds.size.width/2, 10);
            popPC.delegate = self;
            [self presentViewController:self.imgPicker animated:YES completion:nil];
            
        }else{
            [CustomHUD showText:@"请前往设置界面允许程序访问摄像头!"];
        }
        
        
    } else {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSLog(@"打开相册");
            [self.imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            self.imgPicker.modalPresentationStyle = UIModalPresentationFullScreen; //调用本地相册，必须使用popover
            popPC = self.imgPicker.popoverPresentationController;
            popPC.permittedArrowDirections = UIPopoverArrowDirectionAny;
            popPC.delegate=self;
            //            [popPC setBarButtonItem:item];
            
            self.imgPicker.preferredContentSize = CGSizeMake(500, 500);
            
            popPC.sourceView = self.tableView;
            popPC.sourceRect = CGRectMake(0, 0, 10, 10);
            popPC.delegate = self;
            [self presentViewController:self.imgPicker animated:YES completion:nil];
            
            
            
        }else{
            [CustomHUD showText:@"请前往设置界面允许程序访问相册!"];
        }
        
    }
    
}
    
    
- (void)keyBordShow:(NSNotification *)noti {
    
    CGRect keyBoardRect=[noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
    
- (void)keyBorkHidden:(NSNotification *)noti {
    
    self.tableView.contentInset = UIEdgeInsetsZero;
}
    
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
    {
        [self.view endEditing:YES];
    }
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark 选择图片的相关方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
    {
        NSLog(@"cancel");
        [self.imgPicker dismissViewControllerAnimated:YES completion:nil];
    }
    
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage * image = info[@"UIImagePickerControllerOriginalImage"];
    
    [HTTPRequest sharedHttpRequest].image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.tableView reloadData];
}
    
- (void)dealloc {
    
    [HTTPRequest sharedHttpRequest].image = nil;
}
    
    /*
     #pragma mark - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    @end
