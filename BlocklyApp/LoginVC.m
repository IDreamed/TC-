//
//  LoginVC.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "LoginVC.h"
#import "APPControll.h"
#import "CustomHUD.h"
#import "HTTPRequest.h"
#import "updateModel.h"
//#import "BLEControl.h"

@interface LoginVC () <UITextFieldDelegate>
    @property (weak, nonatomic) IBOutlet UIButton *loginButton;
    @property (weak, nonatomic) IBOutlet UIImageView *idImage;
    @property (weak, nonatomic) IBOutlet UITextField *idInput;
    @property (weak, nonatomic) IBOutlet UIImageView *passwordImage;
    @property (weak, nonatomic) IBOutlet UITextField *passwordInput;
    
    @end


@implementation LoginVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.loginButton addTarget:self action:@selector(loginClink) forControlEvents:UIControlEventTouchUpInside];
    self.idInput.delegate = self;
    self.passwordInput.delegate = self;
    
    [self.idInput setNeedsLayout];
    [self.idInput layoutIfNeeded];
    
    CGFloat height = self.idInput.frame.size.height;
    
    UIFont * font = [UIFont systemFontOfSize:DEFAULT_FONT_SIZE];
    
    self.idInput.font = font;
    self.passwordInput.font = font;
    
    SetModel * model = [APPControll getUserInfo];
    if (model) {
        
        self.idInput.text = model.mobile;
        if (model.mobile.length > 0) {
            self.idImage.hidden = YES;
        }
        self.passwordInput.text = model.password;
        if (model.password.length > 0) {
            self.passwordImage.hidden = YES;
        }
    }
    
    [self getUpdateVersion];
}
    
- (void)getUpdateVersion {
    
    //    return_version_ios
    //    参数：type
    //    11,12,13代表TC的三个版本，
    //    21,22,23代表TG
    
    NSDictionary * info = [[NSBundle mainBundle] infoDictionary];
    
    NSInteger type = [HTTPRequest getAppType]+11;
    
    [[HTTPRequest sharedHttpRequest] checkAppType:type VersionWithCallback:^(NSDictionary * _Nullable dict) {
        
        NSInteger status = [[dict objectForKey:@"status"] integerValue];
        
        if (status == 1) {
            NSString * version = VERSION;
            NSDictionary * data = dict[@"data"];
            updateModel * model = [updateModel mj_objectWithKeyValues:data];
            [updateModel setModel:model];
            
            if ([version floatValue] < model.versionCode) {
            
                [self showAlertWithModel:model];
            }
        }
        
    }];
    
}
    
    - (void)showAlertWithModel:(updateModel *)model {
        
        NSString * title = [NSString stringWithFormat:@"发现新版本：%@",model.versionName];
        NSString * message = model.desciption;
        UIAlertController * al = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        if (!model.must) {
            [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [al dismissViewControllerAnimated:YES completion:nil];
                
            }]];
        }
        [al addAction:[UIAlertAction actionWithTitle:@"升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSString * url = [NSString stringWithFormat:APP_URL,APP_ID];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            
            if (model.must) {
                
                [self showAlertWithModel:model];
            }
            
        }]];
        
        [self presentViewController:al animated:YES completion:nil];
    }
    
    
- (void)loginClink {
    
    //    [[BLEControl sharedControl] updateDevice];
    
    NSString * userId = self.idInput.text;
    
    NSString * password = self.passwordInput.text;
    
    [self.view endEditing:YES];
    
    
    if (userId.length == 0) {
        
        [CustomHUD showText:@"请输入账号"];
        return ;
    }
    
    if (password.length == 0) {
        
        [CustomHUD showText:@"请输入密码"];
        return ;
    }
    
    if ([APPControll valiMobile:userId]) {
        
        HTTPRequest * request = [HTTPRequest sharedHttpRequest];
        
        [CustomHUD showwithTextDailog:nil];
        [request postUrl:@"g=portal&m=app&a=login" parameter:@{@"mobile":userId,@"password":password} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
            
            NSMutableDictionary * data = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
            [data setObject:password forKey:@"password"];
            [APPControll writeUserInfo:data];
            
            if (self.notFirst) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            } else {
                [self performSegueWithIdentifier:@"PresentChackView" sender:self];
                
            }
            
            
            
            [CustomHUD showText:responseObject[@"info"]];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            [CustomHUD showText:@"登陆失败"];
        }];
        
    } else {
        
        [CustomHUD showText:@"请输入正确的手机号"];
        return ;
    }
    
    
}
    
- (void)keybordShow:(NSNotification *)nota
    {
        NSDictionary * info = [nota userInfo];
        NSValue * value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
        
        CGFloat Height = isPad?[value CGRectValue].size.height:[value CGRectValue].size.height/2;
        
        NSLog(@"%f", Height/2);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.view.frame = CGRectMake(0, -Height/2, self.view.bounds.size.width, self.view.bounds.size.height);
            
        }];
        
    }
- (void)keybordHiden:(NSNotification *)nota
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            self.view.frame = self.view.bounds;
            
        }];
        
    }
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [APPControll registForKeybordNotificationWithObserver:self showAction:@selector(keybordShow:) hidenAction:@selector(keybordHiden:)];
}
    
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [APPControll removeKeybordNotificationWithObserver:self];
}
    
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
    {
        NSLog(@"touch");
        [self.view endEditing:YES];
    }
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
    {
        if (textField == self.idInput) {
            
            self.idImage.hidden = YES;
        } else {
            self.passwordImage.hidden = YES;
        }
        
        return YES;
    }
    
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
    {
        if (textField.text.length > 0) {
            
            return YES;
        }
        
        if (textField == self.idInput) {
            
            self.idImage.hidden = NO;
        } else {
            self.passwordImage.hidden = NO;
        }
        
        
        return YES;
    }
    
- (BOOL)shouldAutorotate {
    
    return YES;
}
    
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
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
