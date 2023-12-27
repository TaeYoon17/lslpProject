import UIKit

var pins:[[String]] = Array(repeating: [], count: 5)
for idx in (0..<5){
    if pins[idx].count >= 10{ continue }
    pins[0].append("123")
}

var myPins = pins.compactMap{$0.joined(separator:"#")}
print(myPins)
