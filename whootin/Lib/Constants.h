//
//  Constants.h
//  WalkieTalkieRadio
//
//  Created by Senthilkumar R on 26/09/12.
//  Copyright (c) 2012 DMBC. All rights reserved.
//


#define kAppName @"ToDoNot.es"

#define kFolderId [[NSUserDefaults standardUserDefaults] objectForKey:@"FOLDER_ID"]

#define kCreateFolder @"http:/whootin.com/api/v1/folders/new"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define kAccessToken  [[NSUserDefaults standardUserDefaults] objectForKey:@"ACCESS_TOKEN"]

#define kUserId  [[NSUserDefaults standardUserDefaults] objectForKey:@"UserId"]
#define kUsername  [[NSUserDefaults standardUserDefaults] objectForKey:@"Username"]
#define kName  [[NSUserDefaults standardUserDefaults] objectForKey:@"Name"]
#define kProfileImg  [[NSUserDefaults standardUserDefaults] objectForKey:@"ProfileImg"]

#define WH_CLIENT_ID @"v5PzABFFpSqG2SlunHDIDBFuom4k5F2bxFFlDYq1"


#define WH_CLIENT_SECRET @"QFUQ75RIFngfkwqlX8e2UCP2wzaSaOIXxCNKaMKN"


//#define WH_CLIENT_ID @"b1qYnYw43UPN0WMHCAvXNCC8wntbHPyAIjv7oIqQ"


//#define WH_CLIENT_SECRET @"rIMuLecFVplqBBkIRFBrXeppVmMSyHryfDaEWlLH"


#define kLoginURL [NSString stringWithFormat:@"http://whootin.com/oauth/authorize?response_type=token&redirect_uri=onewayradio://wh12345678&client_id=%@&client_secret=%@",WH_CLIENT_ID, WH_CLIENT_SECRET]

#define kUserProfile @"http://whootin.com/api/v1/user.xml"

#define kGetUsers @"http:/whootin.com/api/v1/user/entourage.xml?count=200"

#define kNewMessage @"http://whootin.com/api/v1/direct_messages/new.xml"

#define kMessages @"http://whootin.com/api/v1/direct_messages.json?count=20"

#define kRegister @"http://whootin.com/api/v1/user/new.xml"

#define kLogin_whoot @"http://whootin.com/api/v1/user/login.xml"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//RGB color macro with alpha
#define UIColorFromRGBWithAlpha(rgbValue,a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]



