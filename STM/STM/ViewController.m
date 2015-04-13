//
//  ViewController.m
//  STM
//
//  Created by Brandon Plaster on 4/8/15.
//  Copyright (c) 2015 BrandonPlaster. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *pig_dialogue1;
@property (strong, nonatomic) IBOutlet UIImageView *pig_dialogue2;
@property (strong, nonatomic) NSTimer *timer1;
@property (strong, nonatomic) NSTimer *timer2;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.pig_dialogue1 setHidden:YES];
    [self.pig_dialogue2 setHidden:YES];
}

- (IBAction)pig1ButtonPressed:(id)sender {
    [self.pig_dialogue1 setHidden:NO];
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timer1DidFire:) userInfo:nil repeats:NO];
}

- (IBAction)pig2ButtonPressed:(id)sender {
    [self.pig_dialogue2 setHidden:NO];
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(timer2DidFire:) userInfo:nil repeats:NO];

}

-(void) timer1DidFire: (NSTimer *) timer {
    [self.pig_dialogue1 setHidden:YES];
}

-(void) timer2DidFire: (NSTimer *) timer {
    [self.pig_dialogue2 setHidden:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
