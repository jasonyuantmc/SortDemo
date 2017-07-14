//
//  ViewController.m
//  InterviewTest
//
//  Created by jason on 2017/6/12.
//  Copyright © 2017年 jason. All rights reserved.
//

#import "ViewController.h"
#import "CustomCollectionView.h"
#import "CustomCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet CustomCollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray * array1;
@property(nonatomic,strong)NSTimer * timer;
@end

static NSString * cellID = @"cell";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView registerNib:[UINib nibWithNibName:@"CustomCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:cellID];
    
    _array1 =[[NSMutableArray alloc]init];
    
    for (int i = 0; i < 15; i ++) {
        NSInteger target = (arc4random() * 100) % 9;
        [_array1 addObject:@(target)];
    }
    
    [_collectionView reloadData];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(exchangeArray) userInfo:nil repeats:YES];
    [_timer fire];
    
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)exchangeArray{
    BOOL needStop = YES;
    for (int i =1; i<[_array1 count]; i++) {
        
        for (int j =0; j<[_array1 count] -i; j++) {
            
            if(([_array1[j] compare:_array1[j+1]]) == NSOrderedDescending){
                needStop = NO;
                [_array1 exchangeObjectAtIndex:j withObjectAtIndex:j+1];
              
                [_collectionView moveItemAtIndexPath:  [NSIndexPath indexPathWithIndex:j] toIndexPath:[NSIndexPath indexPathWithIndex:j+1]];
                return;
            }
            
           
        }
        
        if (i < [_array1 count] - 2 && needStop == YES) {
            [_timer invalidate];
        }
    }
  
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _array1.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell * cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.number.text = [[_array1 objectAtIndex:indexPath.section]stringValue];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(50, 50);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
