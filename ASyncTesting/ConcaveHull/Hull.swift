//
//  Hull.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation
import MapKit

struct HullPoint: Sendable {
    var xxx: Double
    var yyy: Double
    
    func description() -> String {
        return xxx.description + "," + yyy.description
    }
}

/**
 Only public class of this pod, Use it to call the hull function Hull().hull(_, _, _)
 */
actor Hull {

    /**
     A private polygon created with the getPolygon Functions
     */
    private var polygon: MKPolygon = MKPolygon()

    /**
     The hull created with the hull functions
     */
    private var hullPoints: [HullPoint] = []
    public func getHullPoints() -> [HullPoint] {
        self.hullPoints
    }
    public func setHullPoints(_ points: [HullPoint]) {
        self.hullPoints = points
    }
    /**
     The points input format
     */
    private var format: [String]?
    public func getFormat() -> [String]? {
        return self.format
    }
    public func setFormat(_ format: [String]?) {
        self.format = format
    }

    /**
     The concavity paramater for the hull function, 20 is the default
    */
    private var concavity: Double = 20
    public func getConcavity() -> Double {
        return self.concavity
    }
    public func setConcavity(_ concavity: Double) {
        self.concavity = concavity
    }
    /**
     Init function
     */
    init() {
    }

    /**
     Init function and set the concavity, if nil, the concavity will be equal to 20
     */
    init(concavity: Double?) {
        self.init()
        
        if let _concavity = concavity {
            Task {
                await self.setConcavity(_concavity)
            }
        }
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return 
     hull.
     - parameter pointSet: The list of point, can be of type [Int], [Double], [[String: Double]] or [[String: Int]]
     - parameter format: The name of String in [[String: Double]] or [[String: Int]] in an array, nil of pointSet 
     is [Int] or [Double]
     - returns: An array of point in the same format as poinSet, which is the hull of the pointSet
     */
    func hull(_ pointSet: [[String: Double]]) async -> [HullPoint] {
        
        if pointSet.count < 4 {
            return await Format().toXy(pointSet)
        }

        hullPoints = await HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return hullPoints
    }
    
    func hull(_ pointSet: [[String: Int]]) async -> [HullPoint] {
        
        if pointSet.count < 4 {
            return await Format().toXy(pointSet)
        }

        hullPoints = await HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return hullPoints
    }
    
    func hull(_ pointSet: [Double]) async -> [HullPoint] {
        
        if pointSet.count < 4 {
            return await Format().toXy(pointSet)
        }

        hullPoints = await HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return hullPoints
    }
    
    func hull(_ pointSet: [Int]) async -> [HullPoint] {
        
        if pointSet.count < 4 {
            return await Format().toXy(pointSet)
        }

        hullPoints = await HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return hullPoints
    }
    
    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return
     hull.
     - parameter pointSet: The list of point, can be of type [Int], [Double], [[String: Double]] or [[String: Int]]
     - parameter format: The name of String in [[String: Double]] or [[String: Int]] in an array, nil of pointSet
     is [Int] or [Double]
     - returns: An array of point in the same format as poinSet, which is the hull of the pointSet
     */
    func hull(hullPoints: [HullPoint]) async -> [HullPoint] {
        
        if hullPoints.count < 4 {
            return hullPoints
        }
        
        self.hullPoints = await HullHelper().getHull(hullPoints, concavity: self.concavity, format: self.format)

        return self.hullPoints
    }
    
    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return 
     hull.
     In this function, there is no need for the format
     - parameter mapPoints: The list of point as MKMapPoint
     - returns: An array of point in the same format as pointSet, which is the hull of the pointSet
     */
    func hull(mapPoints: [MKMapPoint]) async -> [MKMapPoint] {

        if mapPoints.count < 4 {
            return mapPoints
        }

        let pointSet = mapPoints.map { (point: MKMapPoint) -> [Double] in
            return [point.x, point.y]
        }

        hullPoints = await HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return (hullPoints as? [[Double]])!.map { (point: [Double]) -> MKMapPoint in
            return MKMapPoint(x: point[0], y: point[1])
        }
    }

    /**
     This main function allows to create the hull of a set of point by defining the desired concavity of the return 
     hull. In this function, there is no need for the format
     - parameter coordinates: The list of point as CLLocationCoordinate2D
     - returns: An array of point in the same format as pointSet, which is the hull of the pointSet
     */
    func hull(coordinates: [CLLocationCoordinate2D]) async -> [CLLocationCoordinate2D] {

        if coordinates.count < 4 {
            return coordinates
        }

        let pointSet = coordinates.map { (point: CLLocationCoordinate2D) -> [Double] in
            return [point.latitude, point.longitude]
        }

        hullPoints = await HullHelper().getHull(pointSet, concavity: self.concavity, format: self.format)

        return (hullPoints as? [[Double]])!.map { (point: [Double]) -> CLLocationCoordinate2D in
            return CLLocationCoordinate2D(latitude: point[0], longitude: point[1])
        }
    }

    /**
     Create and set in the class a polygon from the hull extracted from the hull function, the hull needs to be in 
     [[Int]] or [[Double]] or needs to have a format equal to ["x", "y"] or ["y", "x"]
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    func getPolygonWithHull() -> MKPolygon {
        if let format = format {
            if !(format[0] == "x" && format[1] == "y" || format[1] == "x" && format[0] == "y") {
                return polygon
            }
            if hullPoints is [[String: Int]] {
                let points: [MKMapPoint] = (hullPoints as? [[String: Int]])!.map { (point: [String: Int]) -> MKMapPoint in
                    return MKMapPoint(x: Double(point["x"]!), y: Double(point["y"]!))
                }
                polygon = MKPolygon(points: points, count: points.count)
            }
            if hullPoints is [[String: Double]] {
                let points = (hullPoints as? [[String: Double]])!.map { (point: [String: Double]) -> MKMapPoint in
                    return MKMapPoint(x: point["x"]!, y: point["y"]!)
                }
                polygon = MKPolygon(points: points, count: points.count)
            }

            return polygon
        }

        let points: [MKMapPoint] = (hullPoints as? [[Any]])!.map { (point: [Any]) -> MKMapPoint in
            if point[0] is Int {
                return MKMapPoint(x: Double((point[0] as? Int)!), y: Double((point[1] as? Int)!))
            }
            if point[0] is Double {
                return MKMapPoint(x: (point[0] as? Double)!, y: (point[1] as? Double)!)
            }
            return MKMapPoint()
        }
        polygon = MKPolygon(points: points, count: points.count)

        return polygon
    }

    /**
     Create and set in the class a polygon from the hull extracted from the hull function with a specified format, 
     in order for this function to work, you should specify, which value of the format is the lat value and which
     value is the lng value.
     If you don't have a format variable of type [String], meaning, your using a pointSet of type [[Int]] or 
     [[Double]], you should use the getPolygonWithHull without arguments
     - parameter latFormat: the value of the format array to represent the latitude
     - parameter lngFormat: the value of the format array to represent the longitude
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    func getPolygonWithHull(latFormat: String, lngFormat: String) -> MKPolygon {
        if format == nil {
            return getPolygonWithHull()
        }

        if hullPoints is [[String: Int]] {
            let coords = (hullPoints as? [[String: Int]])!.map { (point: [String: Int]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: Double(point[latFormat]!), longitude: Double(point[lngFormat]!))
            }
            polygon = MKPolygon(coordinates: coords, count: coords.count)
        }
        if hullPoints is [[String: Double]] {
            let coords = (hullPoints as? [[String: Double]])!.map { (point: [String: Double]) -> CLLocationCoordinate2D in
                return CLLocationCoordinate2D(latitude: point[latFormat]!, longitude: point[lngFormat]!)
            }
            polygon = MKPolygon(coordinates: coords, count: coords.count)
        }

        return polygon
    }

    /**
     Create and set in the class a polygon from an array of CLLocationCoordinate2D
     - parameter coords: An array of CLLocationCoordinate2D
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    func getPolygonWithCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKPolygon {
        polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        return polygon
    }

    /**
     Create and set in the class a polygon from an array of MKMapPoint
     - parameter points: An array of MKMapPoint
     - returns: An MKPolygon for direct reuse and set it in the class for future use
     */
    func getPolygonWithMapPoints(_ mapPoints: [MKMapPoint]) -> MKPolygon {
        polygon = MKPolygon(points: mapPoints, count: mapPoints.count)
        return polygon
    }

    /**
     Check if CLLocationCoordinate2D is inside a polygon
     - parameter coord: A CLLocationCoordinate2D variable
     - returns: A Boolean value, true if CLLocationCoordinate2D is in polygon, false if not
     */
    func coordInPolygon(coord: CLLocationCoordinate2D) -> Bool {
        let mapPoint: MKMapPoint = MKMapPoint(coord)
        return self.pointInPolygon(mapPoint: mapPoint)
    }

    /**
     Check if MKMapPoint is inside a polygon
     - parameter mapPoint: An MKMapPoint variable
     - returns: A Boolean value, true if MKMapPoint is in polygon, false if not
     */
    func pointInPolygon(mapPoint: MKMapPoint) -> Bool {
        let polygonRenderer: MKPolygonRenderer = MKPolygonRenderer(polygon: polygon)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: mapPoint)
        if polygonRenderer.path == nil {
            return false
        }
        return polygonRenderer.path.contains(polygonViewPoint)
    }
    
    func centreOfPoints(_ pointSet: [Any], _ format: [String]?) async -> Any? {
        
        self.format = format
        var points: [HullPoint]
        if pointSet is [HullPoint] {
            points = pointSet as! [HullPoint]
        }
        else {
            if pointSet is [[String: Double]],
                let _pointSet = pointSet as? [[String: Double]] {
                points = await Format().toXy(_pointSet)
            }
            else if pointSet is [[String: Int]],
                let _pointSet = pointSet as? [[String: Int]] {
                points = await Format().toXy(_pointSet)
            }
            else if pointSet is [Double],
                let _pointSet = pointSet as? [Double] {
                points = await Format().toXy(_pointSet)
            }
            else if pointSet is [Int],
                let _pointSet = pointSet as? [Int] {
                points = await Format().toXy(_pointSet)
            }
            else {
                points = []
            }
        }
        
        if let centroid = points.centroid() {
            if  pointSet is [HullPoint] {
                return centroid
            }
            else {
                if pointSet is [[String: Double]] {
                    let outPoints = await Format().fromXyDouble([centroid], format)
                    return outPoints[0]
                }
                else if pointSet is [[String: Int]] {
                    let outPoints = await Format().fromXyInt([centroid], format)
                    return outPoints[0]
                }
                else if pointSet is [Double] {
                    let outPoints = await Format().fromXyDouble([centroid])
                    return outPoints[0]
                }
                else if pointSet is [Int] {
                    let outPoints = await Format().fromXyInt([centroid])
                    return outPoints[0]
                }
                else {
                    return nil
                }
            }
        }
        else {
            return nil
        }
    }

}

extension Data {

    init<T>(from value: T) {
        // 1
        let pointer = UnsafeMutablePointer<T>.allocate(capacity: 1)
        // 2
        pointer.initialize(to: value)
        defer {
            pointer.deinitialize(count: 1)
            pointer.deallocate()
        }
        // 3
        let bufferPointer = UnsafeBufferPointer(start: pointer, count: 1)
        self.init(buffer: bufferPointer)
    }

    func to<T>(type: T.Type) -> T {
        return self.withUnsafeBytes { $0.load(as: T.self) }
    }
}

extension Array where Element == HullPoint {
    /// Calculate signed area.
    ///
    /// See https://en.wikipedia.org/wiki/Centroid#Of_a_polygon
    ///
    /// - Returns: The signed area

    func signedArea() -> CGFloat {
        if isEmpty { return .zero }

        var sum: Double = 0
        for (index, point) in enumerated() {
            let nextPoint: HullPoint
            if index < count-1 {
                nextPoint = self[index+1]
            } else {
                nextPoint = self[0]
            }

            sum += point.xxx * nextPoint.yyy - nextPoint.xxx * point.yyy
        }

        return sum / 2
    }

    /// Calculate centroid
    ///
    /// See https://en.wikipedia.org/wiki/Centroid#Of_a_polygon
    ///
    /// - Note: If the area of the polygon is zero (e.g. the points are collinear), this returns `nil`.
    ///
    /// - Parameter points: Unclosed points of polygon.
    /// - Returns: Centroid point.

    func centroid() -> HullPoint? {
        if isEmpty { return nil }

        let area = signedArea()
        if area == 0 { return nil }

        var sumPoint: HullPoint = HullPoint(xxx: 0, yyy: 0)

        for (index, point) in enumerated() {
            let nextPoint: HullPoint
            if index < count-1 {
                nextPoint = self[index+1]
            } else {
                nextPoint = self[0]
            }

            let factor = point.xxx * nextPoint.yyy - nextPoint.xxx * point.yyy
            sumPoint.xxx += (point.xxx + nextPoint.xxx) * factor
            sumPoint.yyy += (point.yyy + nextPoint.yyy) * factor
        }

        return sumPoint / 6 / area
    }

    func mean() -> HullPoint? {
        if isEmpty { return nil }

        return reduce(HullPoint(xxx: 0, yyy: 0), +) / Double(count)
    }
}

extension HullPoint {
    static func + (lhs: HullPoint, rhs: HullPoint) -> HullPoint {
        HullPoint(xxx: lhs.xxx + rhs.xxx, yyy: lhs.yyy + rhs.yyy)
    }

    static func - (lhs: HullPoint, rhs: HullPoint) -> HullPoint {
        HullPoint(xxx: lhs.xxx - rhs.xxx, yyy: lhs.yyy - rhs.yyy)
    }

    static func / (lhs: HullPoint, rhs: Double) -> HullPoint {
        HullPoint(xxx: lhs.xxx / rhs, yyy: lhs.yyy / rhs)
    }

    static func * (lhs: HullPoint, rhs: Double) -> HullPoint {
        HullPoint(xxx: lhs.xxx * rhs, yyy: lhs.yyy * rhs)
    }
}
