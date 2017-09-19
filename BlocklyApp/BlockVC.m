//
//  ViewController.m
//  BlocklyApp
//
//  Created by 张 on 2017/5/25.
//  Copyright © 2017年 text. All rights reserved.
//

#import "BlockVC.h"
#import "BlocklyToolBoxHealper.h"
#import "APPControll.h"
#import "BluetoothVC.h"
#import "BLEControl.h"
#import "BlocklyControl.h"
#import "HTTPRequest.h"
#import "SetModel.h"
#import "BlocklyControl.h"
#import "InputNameView.h"
#import "ValueView.h"
#import "SelfVC.h"

@interface BlockVC () <UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) BKYWorkbenchViewController * workbenchViewController;
    
@property (copy, nonatomic) NSString * ptitle;

@property (strong, nonatomic) ValueView * valueView;

@property (strong, nonatomic) NSTimer * timer;

@end

@implementation BlockVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.titleLabel.font = DEFAULT_FONT;
    [self loadBlockWork];
    
    [self coffButton];
    
}

- (void)dealloc {
    
    if ([self.timer isValid]) {
        
        [self.timer invalidate];
    }
}

- (ValueView *)valueView {
    
    if (!_valueView) {
        
        _valueView = [[NSBundle mainBundle] loadNibNamed:@"ValueView" owner:self options:nil].lastObject;
        CGFloat backWidth = [APPControll blocklyResizeWithWidth:70];
        CGFloat backHeight = [APPControll blocklyResizeWithWidth:50];
        _valueView.frame = CGRectMake(0, backHeight, backWidth, backHeight*3);
        NSDictionary * dic = [BlocklyControl shardControl].values;
        [_valueView setValueModels:dic];
    }
    
    return _valueView;
}

- (void)coffButton {
    
    
    CGFloat backWidth = [APPControll blocklyResizeWithWidth:70];
    CGFloat backHeight = [APPControll blocklyResizeWithWidth:50];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat width = self.view.bounds.size.width * 0.05;
    
    button.frame = CGRectMake(20, (backHeight - width)/2, width, width);
    
    [button setBackgroundImage:[UIImage imageNamed:@"gj_gerenzhongxin"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(backButtonClink) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    UIButton * runButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat leftPading = (backWidth - 2.3*width)/2;
    runButton.frame = CGRectMake(leftPading, self.view.bounds.size.height - width - 20, width*2.3, width);
    
    [runButton setBackgroundImage:[UIImage imageNamed:@"z1_yunxiang"] forState:UIControlStateNormal];
    [runButton setBackgroundImage:[UIImage imageNamed:@"gj_tingzhi"] forState:UIControlStateSelected];
    [runButton addTarget:self action:@selector(runButtonClink:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:runButton];
    
    UIButton * blueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    blueButton.frame = button.frame;
    blueButton.center = CGPointMake(self.view.bounds.size.width - 10 - width/2, button.center.y);
    [blueButton setBackgroundImage:[UIImage imageNamed:@"gj_lanya"] forState:UIControlStateNormal];
    [blueButton addTarget:self action:@selector(blueButtonClink:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:blueButton];
    
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 4*width, width)];
    self.titleLabel.font = DEFAULT_FONT;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.userInteractionEnabled = YES;
    self.titleLabel.center = CGPointMake(self.view.bounds.size.width/2+backWidth/2, blueButton.center.y);
    self.titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    
    [self.view addSubview:self.titleLabel];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateTitle) userInfo:nil repeats:YES];
    
    UIButton * saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(blueButton.frame.origin.x,
                                  blueButton.frame.origin.y + width*2, width*0.8, width*0.8);
    [saveButton setBackgroundImage:[UIImage imageNamed:@"gj_baocun"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveClink) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveButton];
    
    
    UIButton * updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.frame = CGRectMake(saveButton.frame.origin.x,
                                  saveButton.frame.origin.y + width*2, width*0.8, width*0.8);
    [updateButton setBackgroundImage:[UIImage imageNamed:@"gj_gengxin"] forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(updateClink) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:updateButton];
    
}

- (void)updateClink {
    
    if ([BLEControl sharedControl].peripheral) {
        
        UIAlertController * al = [UIAlertController alertControllerWithTitle:@"是否更新设备" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [al addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [al addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[BLEControl sharedControl] updateDevice];

        }]];
        
        [self.navigationController presentViewController:al animated:YES completion:nil];
        
    } else {
    
        [CustomHUD showText:@"未连接设备"];
    }
    
}

- (void)updateTitle {
    
    if ([BLEControl sharedControl].peripheral) {
        
        NSString * title = [NSString stringWithFormat:@"已连接：%@",[BLEControl sharedControl].peripheral.name];
        self.titleLabel.text = title;
        CGSize size = [APPControll getSizeOfText:title font:DEFAULT_FONT realSize:CGSizeMake(0, self.titleLabel.height)];
        self.titleLabel.width = size.width;
    } else {
        self.titleLabel.text = @"未连接设备";
    
    }

}

- (void)backButtonClink {
    
    SelfVC * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SelfVC"];
    
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)saveClink {
 
//    [[BLEControl sharedControl] updateDevice];
//    
//    return ;
    
    
    InputNameView * view = [[NSBundle mainBundle] loadNibNamed:@"InputNameView" owner:self options:nil].lastObject;
    view.frame = self.view.bounds;
    view.nameText.text = self.appTitle;
    [view addEnterTarget:self Action:@selector(postSave:)];
    
    [self.view addSubview:view];
}

- (void)postSave:(NSString *)title {
    
    
        
        if ([self.workbenchViewController.workspace allBlocks].count > 0) {
            
            SetModel * model = [APPControll getUserInfo];
            NSError * error;
            NSString * xmlStr = [self.workbenchViewController.workspace toXMLWithError:&error];
            
            if (error) {
                
                [CustomHUD showText:@"保存失败请重试"];
            }
            NSString * url = self.isChange ? @"g=portal&m=app&a=edit_program":@"g=portal&m=app&a=add_program";
            
            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":model.uid,@"token":model.token,@"type":@([HTTPRequest getAppType]),@"title":title,@"content":xmlStr}];
            
            if (self.isChange) {
                
                [dic setObject:self.wid forKey:@"id"];
                
            } else {
                
                [dic setObject:@(self.isHighLive) forKey:@"level"];
            }
            
            [[HTTPRequest sharedHttpRequest] postUrl:url parameter:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"%@",responseObject);
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [CustomHUD showText:@"保存失败请重试"];
            }];
            
        } else {
            
            [CustomHUD showText:@"没有可保存的作品"];
        }

}

- (void)runButtonClink:(UIButton *)button {
    
    button.selected = !button.selected;
    
    if (button.selected) {
    
        if (![BLEControl sharedControl].peripheral) {
            
            [CustomHUD showText:@"未连接设备"];
            button.selected = !button.selected;
            return ;
        }
        
        [CustomHUD showwithTextDailog:@"程序准备中，请稍等"];
    
        NSArray<BKYBlock *> * blocks = [self.workbenchViewController getBlockTree];
        [BlocklyControl shardControl].vc = self;
        [[BlocklyControl shardControl] setBlocks:blocks];
        
        
        
    } else {
        
        
        [self showVlaueView:NO];
        [[BlocklyControl shardControl] stopAllBlockTree];

        [[BLEControl sharedControl] stopBluetooth];
        
    }

}


- (void)showVlaueView:(BOOL)isShow {
    
    __weak __block typeof(self)weakSlef = self;

    if (isShow && self.valueView.bounds.size.width != 0) {
        self.valueView.frame = CGRectMake(-self.valueView.bounds.size.width, self.valueView.frame.origin.y, self.valueView.bounds.size.width, self.valueView.bounds.size.height);
        if (!self.valueView.superview) {
            
            [self.view addSubview:self.valueView];

        }
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSlef.valueView.frame = CGRectMake(0, self.valueView.frame.origin.y, self.valueView.bounds.size.width, self.valueView.bounds.size.height);
            
        }];

    } else {
        [UIView animateWithDuration:0.2 animations:^{
            
            weakSlef.valueView.frame = CGRectMake(-self.valueView.bounds.size.width, self.valueView.frame.origin.y, self.valueView.bounds.size.width, self.valueView.bounds.size.height);
            
        } completion:^(BOOL finished) {
            
            [weakSlef.valueView removeFromSuperview];
        }];
        
    }
}

- (void)loadBlockWork
{
    self.workbenchViewController =
    [[BKYWorkbenchViewController alloc] initWithStyle:BKYWorkbenchViewControllerStyleDefaultStyle];
    
    [self addChildViewController:self.workbenchViewController];
    [self.view addSubview:self.workbenchViewController.view];
    self.workbenchViewController.view.frame = self.view.bounds;
    self.workbenchViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.workbenchViewController didMoveToParentViewController:self];
    
//    NSLog(@"view %@,    workView %@",NSStringFromCGRect(self.view.bounds),NSStringFromCGRect(self.workbenchViewController.view.bounds));
    
    BKYBlockFactory * factory = self.workbenchViewController.blockFactory;
    NSError * error = nil;
    BOOL isload = [factory loadFromJSONPaths:[BlocklyToolBoxHealper loadJSONArray] bundle:nil error:&error];
    BKYToolbox * toolBox = [BKYToolbox makeToolboxWithXmlString:[BlocklyToolBoxHealper loadToolBoxStringWithIsHigh:self.isHighLive] factory:factory error:&error];
    
    if (error) {
        NSLog(@"读取toolbox失败");
    }
    
    
    [self.workbenchViewController loadToolbox:toolBox error:nil];
    
    if (!self.isChange) {
        
        self.content = @"<?xml version='1.0' encoding='utf-8' standalone='no'?><xml xmlns='http://www.w3.org/1999/xhtml'><block x='48' type='while_start' id='A2D39380-4647-4AFB-8D90-88B5FC6A135F' y='87' /></xml>";
    }
    
    [self.workbenchViewController.workspace loadBlocksFromXMLString:self.content factory:factory error:nil];
        

}

- (void)buttonClink {
    
    NSString * xml = [self.workbenchViewController.workspace toXMLWithError:nil];
    NSLog(@"%@",xml);
}

#pragma mark 显示蓝牙
- (void)blueButtonClink:(UIButton *)button {

    
    if ([BLEControl sharedControl].peripheral) {
        
        UIAlertController * avc = [UIAlertController alertControllerWithTitle:@"是否断开当前链接" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [avc addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [avc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [[BLEControl sharedControl].manager cancelPeripheralConnection:[BLEControl sharedControl].peripheral];
            
        }]];
        
        [self presentViewController:avc animated:YES completion:nil];
        
    } else {
        
        BluetoothVC * vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"BluetoothVC"];
        vc.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController * pop = vc.popoverPresentationController;
        
        pop.permittedArrowDirections = UIPopoverArrowDirectionAny;
        //            [popPC setBarButtonItem:item];
        
        vc.preferredContentSize = CGSizeMake(800, 500);
        
        pop.sourceView = self.view;
        pop.sourceRect = button.frame;
        pop.delegate = self;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    

}
    



- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    
    return NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [touches.anyObject locationInView:self.view];
    
    if (CGRectContainsPoint(self.titleLabel.frame, point)) {
        
        if ([BLEControl sharedControl].peripheral) {
            
            InputNameView * view = [[NSBundle mainBundle] loadNibNamed:@"InputNameView" owner:self options:nil].lastObject;
            view.frame = self.view.bounds;
            view.nameText.text = [BLEControl sharedControl].peripheral.name;
            view.titlLabel.text = @"请输入要更改的名称";
            [view addEnterTarget:self Action:@selector(chageBluetoothName:)];
            
            [self.view addSubview:view];
        }
        
    }
}

- (void)chageBluetoothName:(NSString *)name {

    [[BLEControl sharedControl] changeDeviceName:name];
}

@end
