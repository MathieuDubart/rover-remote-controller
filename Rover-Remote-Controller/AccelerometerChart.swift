//
//  AccelerometerChart.swift
//  Accelero
//
//  Created by digital on 24/10/2024.
//

import SwiftUI
import Charts

struct AccelerometerDataPoint: Identifiable {
    let id = UUID()
    let type: String
    let value: Double
    let timestamp: Date
}

struct AccelerometerChart: View {
    @EnvironmentObject var accelerometerManager: AccelerometerManager
        
        private var chartData: [AccelerometerDataPoint] {
            var data: [AccelerometerDataPoint] = []
            
            let measurements = accelerometerManager.accelerometerData.suffix(50)
            
            for measurement in measurements {
                data.append(AccelerometerDataPoint(type: "X", value: measurement.x, timestamp: measurement.timestamp))
                data.append(AccelerometerDataPoint(type: "Y", value: measurement.y, timestamp: measurement.timestamp))
                data.append(AccelerometerDataPoint(type: "Z", value: measurement.z, timestamp: measurement.timestamp))
            }
            
            return data
        }
        
        var body: some View {
            Chart(chartData) { dataPoint in
                LineMark(
                    x: .value("Time", dataPoint.timestamp),
                    y: .value("Value", dataPoint.value)
                )
                .foregroundStyle(by: .value("Type", dataPoint.type))
            }
            .frame(height: 300)
            .chartYScale(domain: -3...3)
            .chartForegroundStyleScale([
                "X": Color.red,
                "Y": Color.blue,
                "Z": Color.green
            ])
            .chartLegend(position: .top)
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 10))
            }
            .chartXAxis {
                AxisMarks(position: .bottom, values: .automatic(desiredCount: 5))
            }
        }
}

/*Preview {
    AccelerometerChart()
}*/
