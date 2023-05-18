//
//  CommitContributionChartView.swift
//  Commitment
//
//  Created by Stef Kors on 11/05/2023.
//

// https://www.avanderlee.com/swift/expressible-literals/#initializing-a-custom-cache-from-a-dictionary
// final class Cache<T> {
//     private var store: [String: T]
//
//     init(objects: [String: T]) {
//         self.store = objects
//     }
//
//     func cache(_ object: T, forKey key: String) {
//         store[key] = object
//     }
//
//     func object(for key: String) -> T? {
//         return store[key]
//     }
// }
//
// extension Cache: ExpressibleByDictionaryLiteral {
//     convenience init(dictionaryLiteral elements: (String, T)...) {
//         self.init(objects: [String: T](uniqueKeysWithValues: elements))
//     }
// }
//
// let cache: Cache<URL> = ["SwiftLee": URL(string: "https://www.avanderlee.com")!]
// print(cache.object(for: "SwiftLee")!) // Prints: https://www.avanderlee.com


import SwiftUI

struct Contribution {
    let activity: Int
    let date: Date

    func increaseActivity() -> Contribution {
        return Contribution(activity: self.activity + 1, date: self.date)
    }
}

// TODO: Not showing todays commit activity?
struct ContributionBlockView: View {
    let contribution: Contribution

    @State private var isHovering: Bool = false

    private let targetValue = 20
    var body: some View {
        ZStack {
            let opacityRatio: Double = Double(contribution.activity) / Double(targetValue)
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(Color.windowBackgroundColor)
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.accentColor)
                .opacity(opacityRatio)
                .border(Color.accentColor.opacity(opacityRatio+0.1), width: 1, cornerRadius: 2)
        }
        .onHover(perform: { hoverState in
            if contribution.activity > 0 {
                isHovering = hoverState
            }
        })
        .popover(isPresented: $isHovering, content: {
            Text("\(contribution.activity) contributions on \(contribution.date.formatted())")
                .padding()
        })
        // .help("\(contribution.activity) contributions on \(contribution.date.formatted())")
    }
}

struct CommitContributionChartView: View {
    @EnvironmentObject private var repo: RepoState

    @State private var data: [Contribution] = []

    let rows = (1...7).map { _ in
        GridItem(.fixed(10), spacing: 4)
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            VStack(spacing: 0) {
                LazyHGrid(rows: rows, spacing: 4) {
                    ForEach(Array(zip(data.indices, data)), id: \.0) { (index, contribution) in
                        ContributionBlockView(contribution: contribution)
                    }
                }
            }
        }
        .task {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-YYYY"
            // Iterate by 1 day
            let dayDurationInSeconds: TimeInterval = 60*60*24
            let endDate = Date.now.advanced(by: dayDurationInSeconds)

            var userLocale = Locale.autoupdatingCurrent
            var gregorianCalendar = Calendar(identifier: .gregorian)
            gregorianCalendar.locale = userLocale

            let startDate = gregorianCalendar.date(
                byAdding: .yearForWeekOfYear,
                value: -1,
                to: endDate
            )!

            for date in stride(from: startDate, to: endDate, by: dayDurationInSeconds) {
                data.append(Contribution(activity: 0, date: date))
            }

            // needs largest value
            // map 0...largestValue to 0.0...0.5 for correct shading

            for commit in repo.commits {
                // check if date is part of graph
                if commit.commiterDate > startDate {
                    let index = gregorianCalendar.numberOfDaysBetween(startDate, and: commit.commiterDate)
                    if let prevContribution = data[safe: index] {
                        data[index] = prevContribution.increaseActivity()
                    }
                }
            }
        }
    }
}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>

        return numberOfDays.day!
    }
}

extension Date: Strideable {
    public func distance(to other: Date) -> TimeInterval {
        return other.timeIntervalSinceReferenceDate - self.timeIntervalSinceReferenceDate
    }

    public func advanced(by n: TimeInterval) -> Date {
        return self + n
    }
}
struct CommitContributionChartView_Previews: PreviewProvider {
    static var previews: some View {
        CommitContributionChartView()
    }
}
