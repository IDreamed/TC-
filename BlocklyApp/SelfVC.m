//
//  SelfVC.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "SelfVC.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "APPControll.h"

@interface SelfVC ()
    @property (weak, nonatomic) IBOutlet UIButton *heardImageButton;
    @property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SetModel * model = [APPControll getUserInfo];

    [self.heardImageButton setNeedsLayout];
    [self.heardImageButton layoutIfNeeded];
    self.heardImageButton.layer.masksToBounds = YES;
    self.heardImageButton.layer.cornerRadius = self.heardImageButton.bounds.size.width/2;
    [self.heardImageButton setBackgroundImage:[UIImage imageNamed:@"touxiang"] forState:UIControlStateNormal];
    
    if (model.avatar.length == 0) {
        
    } else {
        
        [self.heardImageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)popClink:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
