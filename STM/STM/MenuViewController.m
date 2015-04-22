//
//  MenuViewController.m
//  STM
//
//  Created by Alap Parikh on 4/21/15.
//  Copyright (c) 2015 BrandonPlaster. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()
@property (strong, nonatomic) IBOutlet UIProgressView *saveProgressView;
@property (strong, nonatomic) NSTimer *timer1;
@property NSInteger count;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.saveProgressView setHidden:YES];
    self.saveProgressView.progressTintColor = [UIColor colorWithRed:0.26 green:0.46 blue:0.47 alpha:1.0];
    
}
- (IBAction)resumeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)settingsDoneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)helpDoneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)saveButtonPressed:(id)sender {
    [self.saveProgressView setHidden:NO];
    
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timer1DidFire:) userInfo:nil repeats:YES];
    
}

-(void) timer1DidFire: (NSTimer *)timer {
    self.count += 1;
    [self.saveProgressView setProgress:(float)self.count*0.2 animated:YES];
    if (self.count == 5) {
        [timer invalidate];
        [self.saveProgressView setHidden:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)quitButtonPressed:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Wait!"
                                                                   message:@"Do you want to save before quitting?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [self saveButtonPressed:nil];
    }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {
                                                          [self dismissViewControllerAnimated:YES completion:nil];
                                                          
                                                      }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action) {}];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
