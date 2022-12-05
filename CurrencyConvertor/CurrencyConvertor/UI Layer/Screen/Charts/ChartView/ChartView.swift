//
//  ChartView.swift
//  CurrencyConverter
//
//  Created by byndr on 04/12/22.//

import SwiftUI
import Charts

struct ChartView: View {
    
    @State var dataSource: [(day: String, count: Int)]
    
    var body: some View {
        if !dataSource.isEmpty {
            GroupBox("Currency statistics") {
                Chart(dataSource, id: \.day) { item in
                    BarMark(x: .value("Category", item.day), y: .value("Value", item.count))
                        .foregroundStyle(Color.orange)
                        .annotation(position: .overlay, alignment: .top, spacing: 3.0) {
                            Text("\(item.count)")
                        }
                }
            }.padding()
        } else {
            Text("No Data")
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChartView(dataSource: [("Today", 23)])
    }
}
