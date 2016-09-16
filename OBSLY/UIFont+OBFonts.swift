//
//  UIFont+OBFonts.swift
//  OBSLY
//
//  Created by Tung Fam on 9/10/16.
//  Copyright © 2016 Tung Fam. All rights reserved.
//

import UIKit

extension UIFont    {
    
    class func applicationRegularFontOfSize(size: CGFloat) -> UIFont   {
        return UIFont(name: "SFUIText-Regular", size: size)!
    }
    
    class func applicationMediumFontOfSize(size: CGFloat) -> UIFont   {
        return UIFont(name: "SFUIDisplay-Medium", size: size)!
    }
    
    class func applicationBoldFontOfSize(size: CGFloat) -> UIFont   {
        return UIFont(name: "SFUIDisplay-Bold", size: size)!
    }
    
    
}

