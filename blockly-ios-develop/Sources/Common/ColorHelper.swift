/*
* Copyright 2016 Google Inc. All Rights Reserved.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation

/**
 Utility class for creating `UIColor` instances.
 */
@objc(BKYColorHelper)
public class ColorHelper: NSObject {
  /**
   Parses a RGB string and returns its corresponding color.

   - parameter rgb: Supported formats are: (RRGGBB, #RRGGBB).
   - parameter alpha: The alpha to set on the color. Defaults to 1.0, if none specified.
   - returns: A parsed RGB color, or nil if the string could not be parsed.
   */
  public static func makeColor(rgb: String, alpha: CGFloat = 1.0) -> UIColor? {
    var rgbUpper = rgb.uppercased()

    // Strip "#" if it exists
    if rgbUpper.hasPrefix("#") {
      rgbUpper = rgbUpper.substring(from: rgbUpper.characters.index(after: rgbUpper.startIndex))
    }

    // Verify that the string contains 6 valid hexidecimal characters
    let invalidCharacters = CharacterSet(charactersIn: "0123456789ABCDEF").inverted
    if rgbUpper.characters.count != 6 ||
      rgbUpper.rangeOfCharacter(from: invalidCharacters) != nil {
      return nil
    }

    // Parse rgb as a hex value and return the color
    let scanner = Scanner(string: rgbUpper)
    var rgbValue: UInt32 = 0
    scanner.scanHexInt32(&rgbValue)

    return UIColor(
      red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
      alpha: alpha)
  }

  /**
   Returns a `UIColor` based on a given hue, with defaults set for saturation (0.45),
   brightness (0.65), and alpha (1.0).

   - parameter hue: The hue in degrees, which is clamped to a value between 0 and 360.
   - returns: A `UIColor`
   */
  public static func makeColor(hue: CGFloat) -> UIColor {
    
    
    
    return makeColor(hue: hue, saturation: 0.5, brightness: 0.6, alpha: 1.0)
    
  }

    ///2017 07 28 特例菜单颜色 
  public static func makeNewColor(hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor {
        
        //2017 06 03 修改工具栏和block颜色
        var h: CGFloat = hue/360.0;
        var b: CGFloat = saturation;
        var s: CGFloat = brightness;
        if hue == 36 {
            
            h = 0.105;
            b = 0.857;
            s = 0.662;
        }
        
        if hue == 340 {
            h = 0.946;
            b =  0.743;
            s = 0.571;
        }
        
        if hue == 170 {
            h = 0.47;
            b = 0.716;
            s = 0.64;
        }
        if hue == 209 {
            
            h = 0.573;
            b =  0.631;
            s = 0.435;
        }
        
        if hue == 200 {
            h = 0.573;
            b =  0.731;
            s = 0.533;
        }
    
    if hue == 105 {
        h = 0.294;
        b =  0.535;
        s = 0.684;
    }
    
    if hue == 276 {
        h = 0.769;
        b =  0.577;
        s = 0.661;
    }
        if hue == 311 {
            h = 0.865;
            b =  0.635;
            s = 0.457;
        }
        if hue == 235 {
            h = 0.651;
            b = 0.576;
            s = 0.442;
        }
        
        if h == 0 {
            
            let percentHue = (min(max(hue, 0), 360)) / 360
            return UIColor(hue: percentHue, saturation: s, brightness: b, alpha: alpha);
            
        } else {
            
            return UIColor(hue: h, saturation: s, brightness: b, alpha: alpha);
        }

        
    }
    
  /**
   Returns a `UIColor` based on hue, saturation, brightness, and alpha values.

   - parameter hue: The hue in degrees, which is clamped to a value between 0 and 360.
   - parameter saturation: The saturation, which should be a value between 0.0 and 1.0.
   - parameter brightness: The brightness, which should be a value between 0.0 and 1.0.
   - parameter alpha: The alpha.
   - returns: A `UIColor`
   */
  public static func makeColor(
    hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) -> UIColor
  {
    
    
    return makeNewColor(hue:hue, saturation:saturation, brightness: brightness, alpha: alpha);
    
    }
}
