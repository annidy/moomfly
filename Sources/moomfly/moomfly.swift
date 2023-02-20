import Foundation

struct Mdquery: Codable {
    var c: Int
    
    private enum CodingKeys: String, CodingKey {
        case c
    }
}


@main
public struct moomfly {
    
    static var plist: URL = {
        let path = (NSHomeDirectory() as NSString).appendingPathComponent("Library/Preferences/.byhost.spotlight.mdquery")
        return URL(fileURLWithPath: path)
    }()
    
    public static func main() {
        while true {
            guard let data = try? Data(contentsOf: plist),
                  var model = try? PropertyListDecoder().decode(Mdquery.self, from: data)
            else {
                print("\(plist) not exist")
                exit(1)
            }
            print("check")
            if model.c >= 99 {
                print("fly...")
                model.c = 1
                let encoder = PropertyListEncoder()
                encoder.outputFormat = .xml
                do {
                    let data = try encoder.encode(model)
                    try data.write(to: plist)
                } catch {
                    print(error)
                }
                print("kill app")
                _ = shell("/usr/bin/killall", ["Moom"])
                print("start app")
                _ = shell("/usr/bin/open", ["-a", "Moom"])
            }
            usleep(1000000 * 5)
        }
    }
}

func shell(_ launchPath: String, _ arguments: [String]) -> String? {
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    
    return output
}
