//
//  GMRConstants.h
//  GMRmobile
//
//  Created by Mac Book Pro  on 03/11/2013.
//  Copyright (c) 2013 Poise Interactive. All rights reserved.
//

#ifndef GMRmobile_GMRConstants_h
#define GMRmobile_GMRConstants_h

#define GMR_CENTER_NAVIGATION_CONTROLLER_BACK_BUTTON_TAG         11000
#define GMR_CENTER_NAVIGATION_CONTROLLER_DRAWER_BUTTON_TAG       11001
#define GMR_CENTER_NAVIGATION_CONTROLLER_SEARCH_BUTTON_TAG       11002
#define GMR_CONTEST_CATEGORY_CELL_COUNT_LABEL_TAG                100

#define GMR_IS_USER_LOGGEDIN            @"gmr_is_user_loggedin"
#define GMR_USER_LOGIN_MN           @"gmr_user_login_manual"
#define GMR_USER_LOGIN_FB           @"gmr_user_login_facebook"
#define GMR_IS_USER_LOGGEDIN            @"gmr_is_user_loggedin"
#define GMR_USER_LOGIN_ACCOUNT           @"gmr_user_login_account"

#define GMR_USER_LOGIN_TYPE           @"gmr_user_login_type"
#define GMR_USER_LOGIN_FB_DATA           @"gmr_user_login_facebook_data"

#define GMR_HOME_CELL_REUSE_IDENTIFIER                         @"gmr_home_cell_reuse_identifier"
#define GMR_COLLAPSABLE_CELL_REUSE_IDENTIFIER                         @"gmr_collapsable_cell_reuse_identifier"



inline static BOOL OSVersionIsAtLeastiOS7() {
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}

#endif
