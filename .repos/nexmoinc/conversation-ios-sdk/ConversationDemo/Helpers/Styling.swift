//
//  Styling.swift
//  NexmoChat
//
//  Created by James Green on 26/05/2016.
//  Copyright © 2016 Nexmo. All rights reserved.
//

import UIKit

public class Styling {
    public static let THEME_DARK_COLOR: UIColor = UIColor(red: 31, green: 131, blue: 192)
    public static let THEME_LIGHT_COLOR: UIColor = UIColor(red: 222, green: 237, blue: 246)
    public static let SNOW_COLOR: UIColor = UIColor(red: 240, green: 240, blue: 240)
    
    public static let TX_MESSAGE_BG_COLOR: UIColor = THEME_DARK_COLOR
    public static let TX_IN_TRANSIT_MESSAGE_BG_COLOR: UIColor = THEME_DARK_COLOR.withAlpha(0.4)
    public static let RX_MESSAGE_BG_COLOR: UIColor = THEME_LIGHT_COLOR
    public static let AVATAR_BORDER_COLOR: UIColor = THEME_DARK_COLOR
}
