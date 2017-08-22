//
//  ChackBlocklyVC.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/5.
//  Copyright © 2017年 text. All rights reserved.
//

#import "ChackBlocklyVC.h"
#import "BlockVC.h"

@interface ChackBlocklyVC ()
    @property (weak, nonatomic) IBOutlet UIView *live1View;
    @property (weak, nonatomic) IBOutlet UIView *live2VIew;
    @property (weak, nonatomic) IBOutlet UIButton *selfButton;
@property (weak, nonatomic) IBOutlet UIImageView *backgrroundImageView;

@end

@implementation ChackBlocklyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.live1View setNeedsLayout];
    [self.live1View layoutIfNeeded];
    
    [self.live2VIew setNeedsLayout];
    [self.live2VIew layoutIfNeeded];
    
//    self.backgrroundImageView.image = [self.backgrroundImageView.image stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    if (CGRectContainsPoint(self.live1View.frame, point)) {
        
        NSLog(@"一起研究");
        BlockVC * vc = [[BlockVC alloc] init];
        vc.isHighLive = NO;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if (CGRectContainsPoint(self.live2VIew.frame, point)) {
        
        NSLog(@"一起创造");
        
        BlockVC * vc = [[BlockVC alloc] init];
        vc.isHighLive = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }

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
