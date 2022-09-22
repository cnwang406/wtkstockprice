//
//  wtkstockpriceWidget.swift
//  wtkstockpriceWidget
//
//  Created by Chun nan Wang on 2022/9/22.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
        
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 24 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct wtkstockpriceWidgetEntryView : View {
    var entry: Provider.Entry
    var lastPrice:Double = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice") ?? 150.0
    var lastPrice2:Double = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice2") ?? 150.0
    var lastUpdate1970 =  UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastUpdated") ?? 0.0
    var body: some View {
        
        RoundedRectangle(cornerRadius: 20)
            .strokeBorder(style: .init(lineWidth: 4.0))
            .foregroundColor(checkAlarm())
            
            .overlay(
                VStack(spacing:0){
                    HStack{
                        Text("聯穎股價")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical,3)
                    
                    PriceCircleView(scale: 0.3, lastPrice: lastPrice, lastPrice2: lastPrice2)
                    HStack{
                        Text("\(lastUpdate1970 == 0.0 ? "not updated" : Date(timeIntervalSince1970: lastUpdate1970).formatted())")
//                        Text("\(checkAlarm().description)")
                    }
                        .font(.footnote)
                        .opacity(lastUpdate1970 == 0 ? 0.5 : 1.0)
                }
                    .padding(5)
            )
        
        
                        
    }
    func checkAlarm() -> Color {
        let low = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceLow") ?? 100.0
        let high = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "priceHigh") ?? 150.0
        let price = UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.double(forKey: "lastPrice") ?? 0.0
        if (UserDefaults(suiteName: "group.com.cnwang.wtkstock")?.bool(forKey: "notifyMe") ?? true) {
            if price == 0.0 {
                return .gray
            }
            if price <= low {
                print ("now \(price) <= \(low) , LOW ALARM !!!")
                return .green
            } else if price >= high {
                print ("now \(price) >= \(high) , HIGH ALARM !!!")
                return .red
            }
        }
        
        
        return .clear
    }
    
}


@main
struct wtkstockpriceWidget: Widget {
    let kind: String = "wtkstockpriceWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            wtkstockpriceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("WTK Stock")
        .description("WTK stock widget")
        .supportedFamilies([.systemSmall])
    }
}

struct wtkstockpriceWidget_Previews: PreviewProvider {
    static var previews: some View {
        wtkstockpriceWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}


