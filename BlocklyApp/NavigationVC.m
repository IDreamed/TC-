#import "NavigationVC.h"
#import "LoginVC.h"

@interface NavigationVC ()
    
    @end

@implementation NavigationVC
    
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut:) name:@"loginOut" object:nil];
}
    
- (void)loginOut:(NSNotification *)noti {
    
    [CustomHUD showText:@"登陆信息实效"];
    [NSThread sleepForTimeInterval:1];
    
    LoginVC * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVC"];
    
    vc.notFirst = YES;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (BOOL)shouldAutorotate {
    
    return YES;
}
    
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

@end
