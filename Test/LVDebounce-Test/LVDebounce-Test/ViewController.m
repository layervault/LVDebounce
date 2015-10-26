//
//  ViewController.m
//  LVDebounce-Test
//
//  Created by Colas on 26/10/2015.
//  Copyright (c) 2015 LVDebounce. All rights reserved.
//

#import "ViewController.h"
#import "LVDebounce.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)pushForAlice:(id)sender {
    [LVDebounce fireAfter:4
                   target:self
                 selector:@selector(printText:)
               withObject:@"Alice"];
}


- (IBAction)pushForBob:(id)sender {
    [LVDebounce fireAfter:4
                   target:self
                 selector:@selector(printText:)
               withObject:@"Bob"];
}




- (void)printText:(NSString *)text
{
    self.label.text = text;
}

@end
