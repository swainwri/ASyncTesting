//
//  Convex.swift
//  Hull
//
//  Created by Sany Maamari on 09/03/2017.
//  Copyright © 2017 AppProviders. All rights reserved.
//  (c) 2014-2016, Andrii Heonia
//  Hull.js, a JavaScript library for concave hull generation by set of points.
//  https://github.com/AndriiHeonia/hull
//

import Foundation

actor Convex {
    private var convex: [HullPoint] = []
    public func getConvex() -> [HullPoint] { convex }
    public func setConvex(_ convex: [HullPoint]) { self.convex = convex }
    
    init(_ pointSet: [HullPoint]) async {
        let upper = upperTangent(pointSet)
        let lower = lowerTangent(pointSet)
        setConvex(lower + upper)
        convex.append(convex[0])
    }

    private func cross(_ ooo: HullPoint, _ aaa: HullPoint, _ bbb: HullPoint) -> Double {
        return (aaa.xxx - ooo.xxx) * (bbb.yyy - ooo.yyy) - (aaa.yyy - ooo.yyy) * (bbb.xxx - ooo.xxx)
    }

    private func upperTangent(_ pointSet: [HullPoint]) -> [HullPoint] {
        var lower = [HullPoint]()
        for point in pointSet {
            while lower.count >= 2 && (cross(lower[lower.count - 2], lower[lower.count - 1], point) <= 0) {
                _ = lower.popLast()
            }
            lower.append(point)
        }
        _ = lower.popLast()
        return lower
    }

    private func lowerTangent(_ pointSet: [HullPoint]) -> [HullPoint] {
        let reversed = pointSet.reversed()
        var upper = [HullPoint]()
        for point in reversed {
            while upper.count >= 2 && (cross(upper[upper.count - 2], upper[upper.count - 1], point) <= 0) {
                _ = upper.popLast()
            }
            upper.append(point)
        }
        _ = upper.popLast()
        return upper
    }

}
