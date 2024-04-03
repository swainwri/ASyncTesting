//
//  Format.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

actor Format {

    public func toXy(_ pointSet: [[String: Double]]) -> [HullPoint] {
        return toXy(pointSet, ["[String: Double]"])
    }
    
    public func toXy(_ pointSet: [[String: Int]]) -> [HullPoint] {
        return toXy(pointSet, ["[String: Int]"])
    }
    
    public func toXy(_ pointSet: [Double]) -> [HullPoint] {
        return toXy(pointSet, nil)
    }
    
    public func toXy(_ pointSet: [Int]) -> [HullPoint] {
        return toXy(pointSet, nil)
    }
    
    private func toXy(_ pointSet: [Any], _ format: [String]?) -> [HullPoint] {
        if format == nil {
            return (pointSet as? [[Any]])!.map { (point: [Any]) -> HullPoint in
                if point[0] is Int {
                    return HullPoint(xxx: Double((point[0] as? Int)!), yyy: Double((point[1] as? Int)!))
                }
                if point[0] is Double {
                    return HullPoint(xxx: (point[0] as? Double)!, yyy: (point[1] as? Double)!)
                }
                return HullPoint(xxx: 0, yyy: 0)
            }
        }
        if pointSet is [[String: Int]] {
            return (pointSet as? [[String: Int]])!.map { (point: [String: Int]) -> HullPoint in
                return HullPoint(xxx: Double(point[format![0]]!), yyy: Double(point[format![1]]!))
            }
        }
        if pointSet is [[String: Double]] {
            return (pointSet as? [[String: Double]])!.map { (point: [String: Double]) -> HullPoint in
                return HullPoint(xxx: point[format![0]]!, yyy: point[format![1]]!)
            }
        }
        return [HullPoint]()
    }

    public func fromXyDouble(_ pointSet: [HullPoint], _ format: [String]?) -> [[String: Double]] {
        return fromXy(pointSet, format, true) as! [[String: Double]]
    }
    
    public func fromXyInt(_ pointSet: [HullPoint], _ format: [String]?) -> [[String: Int]] {
        return fromXy(pointSet, format, false) as! [[String: Int]]
    }
    
    public func fromXyDouble(_ pointSet: [HullPoint]) -> [[Double]] {
        return fromXy(pointSet, nil, true) as! [[Double]]
    }

    public func fromXyInt(_ pointSet: [HullPoint]) -> [[Int]] {
        return fromXy(pointSet, nil, false) as! [[Int]]
    }
    
    private func fromXy(_ pointSet: [HullPoint], _ format: [String]?, _ doubles: Bool) -> [Any] {
        if let _format = format {
            if doubles {
                return pointSet.map { (point: HullPoint) -> [String: Double] in
                    var origin: [String: Double] = [String: Double]()
                    origin[_format[0]] = point.xxx
                    origin[_format[1]] = point.yyy
                    return origin
                }
            }
            else {
                return pointSet.map { (point: HullPoint) -> [String: Int] in
                    var origin: [String: Int] = [String: Int]()
                    origin[_format[0]] = Int(point.xxx)
                    origin[_format[1]] = Int(point.yyy)
                    return origin
                }
            }
        }
        else {
            if doubles {
                return pointSet.map { (point: HullPoint) -> [Double] in
                    return [point.xxx, point.yyy]
                }
            }
            else {
                return pointSet.map { (point: HullPoint) -> [Int] in
                    return [Int(point.xxx), Int(point.yyy)]
                }
            }
        }
    }

}
