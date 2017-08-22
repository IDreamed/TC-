//
//  BluetoothVC.m
//  BlocklyApp
//
//  Created by 张 on 2017/6/8.
//  Copyright © 2017年 text. All rights reserved.
//

#import "BluetoothVC.h"
#import "BLEControl.h"
#import "BluetoothCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CustomHUD.h"
#import "BlockVC.h"

@interface BluetoothVC () <UITableViewDelegate, UITableViewDataSource, CBCentralManagerDelegate>

    @property (nonatomic, copy) NSString * cellKey;
//    @property (nonatomic, strong) NSArray *heardTitles;
    @property (nonatomic, assign) BOOL openBluetooth;
    @property (nonatomic, copy) NSString * heardKey;
    @property (strong, nonatomic) IBOutlet UITableView *tableView;
    @property (strong, nonatomic) NSMutableArray * keys;
    
    @property (strong, nonatomic) NSMutableDictionary * peripherals;
    
    @property (strong, nonatomic) CBCentralManager * manager;
    
    @property (strong, nonatomic) CBPeripheral * peripheral;

@property (weak, nonatomic) CBPeripheral * selectPeri;

@end

@implementation BluetoothVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellKey = @"BluetoothCell";
    self.title = @"设备列表";
    self.heardKey = @"bluetoothHeardFootView";
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:self.heardKey];
    
    self.keys = [NSMutableArray array];
    self.peripherals = [NSMutableDictionary dictionary];
    
    BLEControl * con = [BLEControl sharedControl];
    
    if (con.manager) {
        
        self.manager = con.manager;
        self.manager.delegate = self;
    }
    if (con.peripheral) {
        self.peripheral = con.peripheral;
    }
    
    [self searchBluetooth];
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
    
        return self.keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BluetoothCell * cell = [tableView dequeueReusableCellWithIdentifier:self.cellKey forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSLog(@"%@", NSStringFromCGRect(cell.contentView.frame));
    
    NSString * key = self.keys[indexPath.row];
    CBPeripheral * per = self.peripherals[key];
//    int rssi = abs([per.RSSI intValue]);
//    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"UUID:%@",key];
    cell.nameLabel.text = per.name;
    cell.keyLabel.text = length;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:self.heardKey];
    view.backgroundColor = [UIColor colorWithRed:92/255.0 green:147/255.0 blue:1 alpha:1];
    view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 50);

    [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView * backView = [[UIView alloc] initWithFrame:view.bounds];
    backView.backgroundColor = [UIColor colorWithRed:92/255.0 green:147/255.0 blue:1 alpha:1];
    [view addSubview:backView];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, view.frame.size.width, view.frame.size.height - 20)];
    label.font = [UIFont boldSystemFontOfSize:24];
    label.textColor = [UIColor whiteColor];
    label.text = self.title;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    return view;
}
   
    
    
- (void)searchBluetooth {

    if (!self.manager) {
        
        self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    } else {
        CBUUID * uuid = [CBUUID UUIDWithString:BLUUID];
        
        [self.manager scanForPeripheralsWithServices:@[uuid] options:nil];
        self.openBluetooth = YES;
        [self.tableView reloadData];

    }
    
//    [CustomHUD showwithTextDailog:nil];
    
    
}

    - (void)centralManagerDidUpdateState:(CBCentralManager *)central
    {
        switch (central.state) {
            case 0:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
            case 1:
            NSLog(@"CBCentralManagerStateResetting");
            break;
            case 2:
            NSLog(@"CBCentralManagerStateUnsupported");//不支持蓝牙
            break;
            case 3:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
            case 4:
            {
                [CustomHUD showText:@"蓝牙未开始，请重试"]; //蓝牙未开启
                self.manager = nil;
                
            }
            break;
            case 5:
            {
                NSLog(@"CBCentralManagerStatePoweredOn");//蓝牙已开启
                // 在中心管理者成功开启后再进行一些操作
                // 搜索外设
                
                //                [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:BLUUID]] options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
                CBUUID * uuid = [CBUUID UUIDWithString:BLUUID];
                [self.manager scanForPeripheralsWithServices:@[uuid] options:nil];
                self.openBluetooth = YES;
                [self.tableView reloadData];
                [CustomHUD hidenHUD];
            }
            break;
            default:
            break;
            
        }
    }
    
    //发现外围设备回调
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
    {
        
        [self.manager connectPeripheral:peripheral options:nil];

        NSString * key = peripheral.identifier.UUIDString;
        [self.peripherals setObject:peripheral forKey:key];
        if (![self.keys containsObject:key]) {
            
            [self.keys addObject:key];
        }
        
        
        
    }
    
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * key = self.keys[indexPath.row];
    
    if (self.peripheral) {
        
        [self.manager cancelPeripheralConnection:self.peripheral];
        self.peripheral = nil;
    }
    
    [CustomHUD showwithTextDailog:@"正在链接蓝牙设备"];
    
    CBPeripheral * per = self.peripherals[key];
    self.selectPeri = per;
    [self.manager connectPeripheral:per options:nil];
    
}
    
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    if (self.selectPeri == peripheral) {
        
        self.peripheral = peripheral;
        NSLog(@"连接成功");
        [CustomHUD showText:@"连接成功"];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
            BLEControl * con = [BLEControl sharedControl];
            con.manager = self.manager;
            con.peripheral = self.peripheral;
            
        }];

        
    } else {
        
        NSString * name = peripheral.name;
        NSLog(@"%@",name);
        [self.manager cancelPeripheralConnection:peripheral];
       
        [self.tableView reloadData];
        
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    [CustomHUD showText:@"连接失败,请重试"];
}
    
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    NSLog(@"%@",peripheral.identifier.UUIDString);
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if (self.manager) {
        
        [BLEControl sharedControl].manager = self.manager;
    }
    if (self.peripheral) {
        
        [BLEControl sharedControl].peripheral = self.peripheral;
    }
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
