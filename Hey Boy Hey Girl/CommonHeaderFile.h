//
//  CommonHeaderFile.h
//  OnWine
//
//  Created by Arka Banerjee on 31/08/17.
//  Copyright © 2017 Arun Halder. All rights reserved.
//

#ifndef CommonHeaderFile_h
#define CommonHeaderFile_h


#define BASE_URL @"http://lab-5.sketchdemos.com/PHP-WEB-SERVICES/P-974-OnWine/api/"

#define Image_URL @"http://lab-5.sketchdemos.com/PHP-WEB-SERVICES/P-974-OnWine/assets/uploads/files/"

#define SIGNIN_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"login"]
#define Registration_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"registration"]
#define Verify_otp_reg_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"verify_otp_reg"]
#define Forgotpassword_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"forgotpassword"]
#define Resetpassword_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"resetpassword"]
//#define Update_mobile_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"update_mobile"]
#define Changepassword_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"changepassword"]
#define Categories_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"categories"]
#define Accessories_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"accessories"]
#define Fetch_address_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"fetch_address"]
#define Wines_sizes_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"wines_sizes"]
#define Add_to_fav_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"add_to_fav"]
#define Fetch_favorite_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"fetch_favorite"]
#define Fetch_order_history_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"fetch_order_history"]
#define Add_accessory_to_cart_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"add_accessory_to_cart"]
#define Fetch_cart_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"fetch_cart"]
#define Remove_from_cart_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"remove_from_cart"]
#define Update_quantity_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"update_quantity"]
#define Delete_favorite_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"delete_favorite"]
#define Search_wine_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"search_wine"]
#define Final_order_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"final_order"]
#define Reorder_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"reorder"]
#define ADDTOCART_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"add_to_cart"]
#define Update_mobile_direct_URL [NSString stringWithFormat:@"%@%@",BASE_URL,@"update_mobile_direct"]




#define kLoginData @"loginData"
#define kEmail @"email"
#define kMobile @"mobile"
#define kWineData @"wineData"
#define itemList 1001
#define profile 1002
#define cart 1003
#define maxDate 31/12/2050
#define kisFirstTimeLogin @"isFirstTimeLogin"
#define kisKeepSignin @"keepSignin"


#endif /* CommonHeaderFile_h */

