//
//  Chart.swift
//  ASyncTesting
//
//  Created by Steve Wainwright on 01/04/2024.
//

import SwiftUI
import Charts

struct MyPoint: Hashable, Identifiable {
    var id: String { return "\(x), \(y)" }
    var x: Double = .random(in: Double(0.0)..<Double(1000.0))
    var y: Double = .random(in: Double(0.0)..<Double(500.0))
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension MyPoint {
    static var data: [MyPoint] {
        return (0...200).map { _ in
            MyPoint()
        }
    }
}

struct MyPoints: Identifiable {
    
    let name: String
    var points: [MyPoint]
    let index: Int
    var id: String { "\(index): " + name }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(points)
    }
}

struct Point3D: Identifiable {
    var id: String { return "\(x), \(y), \(z)" }
    var x: Double
    var y: Double
    var z: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
    }
}



struct ChartExampleView: View {

    var dataPoints: [MyPoint] = MyPoint.data
    @State var hullDataPoints: [MyPoint] = []
    @State var clustersHullDataPoints: [MyPoints] = []
//    @State var clustersHullDataPoints0: MyPoints = MyPoints(name: "Dummy", points: [], index: 0)
//    @State var clustersHullDataPoints1: MyPoints = MyPoints(name: "Dummy", points: [], index: 1)
//    @State var clustersHullDataPoints2: MyPoints = MyPoints(name: "Dummy", points: [], index: 2)
//    @State var clustersHullDataPoints3: MyPoints = MyPoints(name: "Dummy", points: [], index: 3)
//    @State var clustersHullDataPoints4: MyPoints = MyPoints(name: "Dummy", points: [], index: 4)
    let hull = Hull()
    
    let rawContourPoints: [Point3D] = [ Point3D(x: 875.0, y: 3375.0, z: 632.0),
                                        Point3D(x: 500.0, y: 4000.0, z: 634.0),
                                        Point3D(x: 2250.0, y: 1250.0, z: 654.2),
                                        Point3D(x: 3000.0, y: 875.0, z: 646.4),
                                        Point3D(x: 2560.0, y: 1187.0, z: 641.5),
                                        Point3D(x: 1000.0, y: 750.0, z: 650.0),
                                        Point3D(x: 2060.0, y: 1560.0, z: 634.0),
                                        Point3D(x: 3000.0, y: 1750.0, z: 643.3),
                                        Point3D(x: 2750.0, y: 2560.0, z: 639.4),
                                        Point3D(x: 1125.0, y: 2500.0, z: 630.1),
                                        Point3D(x: 875.0, y: 3125.0, z: 638.0),
                                        Point3D(x: 1000.0, y: 3375.0, z: 632.3),
                                        Point3D(x: 1060.0, y: 3500.0, z: 630.8),
                                        Point3D(x: 1250.0, y: 3625.0, z: 635.8),
                                        Point3D(x: 750.0, y: 3375.0, z: 625.6),
                                        Point3D(x: 560.0, y: 4125.0, z: 632.0),
                                        Point3D(x: 185.0, y: 3625.0, z: 624.2)]
    @State var contoursDataPoints: [MyPoints] = []
    @State var contoursHullDataPoints: [MyPoints] = []
    @State var minX: Double = 0.0
    @State var maxX: Double = 0.0
    @State var minY: Double = 0.0
    @State var maxY: Double = 0.0
    @State var minZ: Double = 0.0
    @State var maxZ: Double = 0.0
    
    let colors: [Color] = [.purple, .cyan, .orange, .yellow, .green, .mint, .brown, .indigo, .pink, .teal, .gray]
    
    var body: some View {
        Chart(content: {
            ForEach(dataPoints) { point in
                PointMark(x: CGFloat(point.x), y: .value("y", point.y))
                    .foregroundStyle(.red)
                    .symbol(Circle().strokeBorder(lineWidth: 1.5))
            }
            //            ForEach(hullDataPoints) { point in
            //                LineMark(x: .value("x", point.x), y: .value("y", point.y))
            //                    .foregroundStyle(.blue)
            //                //                    .symbol(Circle().strokeBorder(lineWidth: 1.5))
            //            }
//        }
//        .chartXScale(domain: [0, 1000])
//        .chartYScale(domain: [0, 500])
//        .chartXAxis {
//            AxisMarks(values: .automatic(desiredCount: 10))
//        }
//        .chartYAxis {
//            AxisMarks(values: .automatic(desiredCount: 5))
//        }
//        Chart(content: {
            ForEach(clustersHullDataPoints) { cluster in
                ForEach(cluster.points) { point in
                    LineMark(x: .value("x", point.x), y: .value("y", point.y))
                        .foregroundStyle(colors[cluster.index])
                }
                
            }
        })
//        Chart(content: {
//            ForEach(clustersHullDataPoints0.points) { point in
//                LineMark(x: .value("x", point.x), y: .value("y", point.y))
//                    .foregroundStyle(colors[clustersHullDataPoints0.index])
//            }
//            ForEach(clustersHullDataPoints1.points) { point in
//                LineMark(x: .value("x", point.x), y: .value("y", point.y))
//                    .foregroundStyle(colors[clustersHullDataPoints1.index])
//            }
//            ForEach(clustersHullDataPoints2.points) { point in
//                LineMark(x: .value("x", point.x), y: .value("y", point.y))
//                    .foregroundStyle(colors[clustersHullDataPoints2.index])
//            }
//            ForEach(clustersHullDataPoints3.points) { point in
//                LineMark(x: .value("x", point.x), y: .value("y", point.y))
//                    .foregroundStyle(colors[clustersHullDataPoints3.index])
//            }
//            ForEach(clustersHullDataPoints4.points) { point in
//                LineMark(x: .value("x", point.x), y: .value("y", point.y))
//                    .foregroundStyle(colors[clustersHullDataPoints4.index])
//            }
//
//        })
        .chartXScale(domain: [0, 1000])
        .chartYScale(domain: [0, 500])
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 10))
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .task {
            await calcHull()
            await calcGMMClusters()
//            clustersHullDataPoints0 = clustersHullDataPoints[0]
//            clustersHullDataPoints1 = clustersHullDataPoints[1]
//            clustersHullDataPoints2 = clustersHullDataPoints[2]
//            clustersHullDataPoints3 = clustersHullDataPoints[3]
//            clustersHullDataPoints4 = clustersHullDataPoints[4]
        }
        Chart(content: {
            ForEach(contoursDataPoints) { contour in
                ForEach(contour.points) { point in
                    PointMark(x: .value("x", point.x), y: .value("y", point.y))
                        .foregroundStyle(colors[contour.index])
                        .symbolSize(10)
                }
            }
//            ForEach(contoursHullDataPoints) { contour in
//                ForEach(contour.points) { point in
//                    LineMark(x: .value("x", point.x), y: .value("y", point.y))
//                        .foregroundStyle(colors[contour.index])
//                }
//            }
        })
        .chartXScale(domain: [self.minX, self.maxX])
        .chartYScale(domain: [self.minY, self.maxY])
        .task {
            await calcKriging()
//            await hull.setConcavity(100.0)
//            var i = 0
//            for contour in contoursDataPoints {
//                let points = await hull.hull(hullPoints: contour.points.map({ HullPoint(xxx: $0.x, yyy: $0.y)}))
//                clustersHullDataPoints.append(MyPoints(name: "Cluster \(i)", points: points.map({ MyPoint(x: $0.xxx, y: $0.yyy) }), index: i))
//                i += 1
//            }
        }
    }
    
    func calcHull() async {
        await hull.setConcavity(500.0)
        let _hullPoints = dataPoints.map({ HullPoint(xxx: $0.x, yyy: $0.y)})
        let tmp = await hull.hull(hullPoints: _hullPoints)
        hullDataPoints = tmp.map({ MyPoint(x: $0.xxx, y: $0.yyy)})
//        print(dataPoints)
//        print(hullDataPoints)
    }
    
    func calcGMMClusters() async {
        
        // Use  the Gaussian Mixed Model GMMCluster to determine clusters
        let gmmPoints = dataPoints.map({ GMMPoint(x: $0.x, y: $0.y) })
        let gmmCluster: GMMCluster = await GMMCluster(usingGMMPointsWithInitialSubclasses: 10, noClasses: 1, vector_dimension: 2, samples: [gmmPoints]) //GMMCluster(usingGMMPointsWithNoClasses: 1, vector_dimension: 2, samples: [gmmPoints])
        await gmmCluster.cluster()
        
        var clusterAreas: [[HullPoint]]?
        if let signatureSet = await gmmCluster.signatureSet {
            print("No classes: \(signatureSet.nclasses)\n")
            var countAllSubclasses: Int = 0
            for i in 0..<signatureSet.nclasses {
                print("  class: \(i) no Subclasses: \(signatureSet.classSig[i].nsubclasses)\n")
                for _ in 0..<signatureSet.classSig[i].nsubclasses {
                    countAllSubclasses += 1
                }
            }
            // collect the discontinuous clusters
            clusterAreas = [[HullPoint]](repeating: [], count: countAllSubclasses)
            for i in 0..<signatureSet.nclasses {
                let classSignature = signatureSet.classSig[i]
                for j in 0..<classSignature.nsubclasses {
                    var m: Int = 0, nearestSubclassIndex: Int = 0
                    var nearestMeanToPointDistance: Double, meanToPointDistance: Double
                    for k in 0..<gmmPoints.count {
                        nearestMeanToPointDistance = Double.greatestFiniteMagnitude;
                        for l in 0..<classSignature.nsubclasses {
                            let _subSig = classSignature.subSig[l]
                            meanToPointDistance = sqrt(pow(_subSig.means[0] - gmmPoints[k].x, 2.0) + pow(_subSig.means[1] - gmmPoints[k].y, 2.0))
                            if meanToPointDistance < nearestMeanToPointDistance {
                                nearestSubclassIndex = l
                                nearestMeanToPointDistance = meanToPointDistance
                            }
                        }
                        if ( nearestSubclassIndex == j ) {
                            clusterAreas?[j].append(HullPoint(xxx: gmmPoints[k].x, yyy: gmmPoints[k].y))
                            m += 1
                        }
                    }
                }
            }
            
            // if any clusters are adjacent ie within deltaX or deltaY, merge the clusters
            if let _clusterAreas = clusterAreas {
                await hull.setConcavity(100.0)
                for i in 0..<countAllSubclasses {
                    if !_clusterAreas[i].isEmpty {
                        let points = await hull.hull(hullPoints: _clusterAreas[i])
                        clustersHullDataPoints.append(MyPoints(name: "Cluster \(i)", points: points.map({ MyPoint(x: $0.xxx, y: $0.yyy) }), index: i))
                    }
                }
            }
        }
    }
    
    func calcKriging() async {
        
        let knownXPositions: [Double] = rawContourPoints.map({ $0.x })
        let knownYPositions: [Double] = rawContourPoints.map({ $0.y })
        let knownValues: [Double] = rawContourPoints.map({ $0.z })
        if let _minX = knownXPositions.min(),
           let _maxX = knownXPositions.max(),
           let _minY = knownYPositions.min(),
           let _maxY = knownYPositions.max(),
           let _minZ = knownValues.min(),
           let _maxZ = knownValues.max() {
            self.minX = _minX
            self.maxX = _maxX
            self.minY = _minY
            self.maxY = _maxY
            self.minZ = _minZ
            self.maxZ = _maxZ
            // include edges
            //        knownXPositions += vertices[info.plotdata.count..<vertices.count].map({ $0.x })
            //        knownYPositions += vertices[info.plotdata.count..<vertices.count].map({ $0.y })
            //        knownValues += vertices[info.plotdata.count..<vertices.count].map({ $0.value })
            let kriging: Kriging = Kriging()
            await kriging.train(t: knownValues, x: knownXPositions, y: knownYPositions, model: .gauss, sigma2: 0.0, alpha: 10.0)
            
            let deltaX = (_maxX - _minX) / 100.0
            let deltaY = (_maxY - _minY) / 100.0
            let deltaZ = (_maxZ - _minZ) / 10.0
            var contourLevels: [Double] = Array(repeating: 0, count: 11)
            var z: Double = minZ
            var i: Int = 0
            while z <= maxZ {
                contourLevels[i] = z
                z += deltaZ
                i += 1
            }
            for i in 0..<11 {
                contoursDataPoints.append(MyPoints(name: "\(contourLevels[i].rounded())", points: [], index: i))
                contoursDataPoints[i].points.reserveCapacity(10000)
            }
            if await kriging.error == KrigingError.none {
                var x: Double = minX
                while x < maxX {
                    var y: Double = minY
                    while y < maxY {
                        z = await kriging.predict(x: x, y: y)
                        if let index = (0..<(contourLevels.count-1)).firstIndex(where: { z >= contourLevels[$0] && z < contourLevels[$0+1] }) {
                            contoursDataPoints[index].points.append(MyPoint(x: x, y: y))
                        }
                        else if z < contourLevels[0] {
                            contoursDataPoints[0].points.append(MyPoint(x: x, y: y))
                        }
                        else if z > contourLevels[10] {
                            contoursDataPoints[10].points.append(MyPoint(x: x, y: y))
                        }
                        y += deltaY
                    }
                    x += deltaX
                }
            }
        }
    }
}


