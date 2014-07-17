//
//  ProductsViewController.m
//  ShoppingCartExample
//
//  Created by Jose Gustavo Rodriguez Baldera on 5/22/14.
//  Copyright (c) 2014 Jose Gustavo Rodriguez Baldera. All rights reserved.
//

#import "ProductsViewController.h"
#import "Product.h"
#import "ProductCell.h"
#import "Cart.h"
#import "AppDelegate.h"
#import "CartViewController.h"

//#import "AeHttpLib.h"
#import "AeSdkIOS.h"


@interface ProductsViewController ()

@property (strong, nonatomic) NSMutableArray *products;

- (void)addToCart:(UIButton *)sender;

@end

@implementation ProductsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    [self.tableView registerNib:[UINib nibWithNibName:@"ProductCell" bundle:nil] forCellReuseIdentifier:@"ProductCell"];
 
    self.navigationItem.title = @"Products";

    [self loadProducts];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProductCell";

    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    Product *product = [self.products objectAtIndex:[indexPath row]];
    
    // Configure the cell...
    cell.productImage.image = [UIImage imageNamed:product.image];
    cell.productImage.contentMode = UIViewContentModeScaleAspectFit;
    cell.productTitle.text = product.name;

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundDown];
    cell.productPrice.text = [NSString stringWithFormat:@"$%@", [formatter stringFromNumber:[NSNumber numberWithDouble:product.price]]];

    [cell.addToCartButton addTarget:self action:@selector(addToCart:) forControlEvents:UIControlEventTouchUpInside];
    cell.addToCartButton.tag = [indexPath row];

    return cell;
}

- (void)loadProducts
{
    self.products = [Product listProducts];

    [self.tableView reloadData];
}

- (void)addToCart:(UIButton *)button
{
    Product *product = [self.products objectAtIndex:button.tag];
    BOOL success = [Cart addProduct:product];
    
    NSString *pid =[@(product.id) stringValue];
    NSString *price =[@(product.price) stringValue];
    
    
    
    NSDictionary* jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    pid, @"pid",
                                    product.name, @"pname",
                                    price, @"price",
                                    nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:NSJSONWritingPrettyPrinted error:&error];
   // AeHttpPost *t = [[AeHttpPost alloc] init];
   // [t senddatam:jsonData];
    
    AeSdkIOS *ae = [[AeSdkIOS alloc] init];
    [ae aesdkios:jsonData];

    if(success)
    {
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] updateCartTabBadge];

        // reload cart items
        UINavigationController *cartNavController = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:1];
        CartViewController *cartViewController = (CartViewController *)[cartNavController.viewControllers objectAtIndex:0];
        [cartViewController loadItems];

        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Add Product" message:@"Product added to cart" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
}





/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];

    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
 
 */

@end
