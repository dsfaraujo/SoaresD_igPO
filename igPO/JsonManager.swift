/*==================================*/
import Foundation
/*==================================*/
//classe lien entre le projet et le ficier json
class JsonManager
{
    /* ------------------------------------- */
    var jsonParsed:NSMutableDictionary = [:]
    var urlToJsonFile: String = ""
    /* ------------------------------------- */
    //initialisation du fichier json
    init(urlToJsonFile: String)
    {
        self.urlToJsonFile = urlToJsonFile
    }
    /* ------------------------------------- */
    //fonction pour parse le json
    func parser(_ jsonFilePath: String) -> NSMutableDictionary
    {
        let data = try! Data(contentsOf: URL(string: jsonFilePath)!)
        return try! JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers) as! NSMutableDictionary
    }
    /* ------------------------------------- */
    //fonction qui doit importer le ficher json
    func importJSON()
    {
        self.jsonParsed = self.parser(self.urlToJsonFile)
    }
    /* ------------------------------------- */
    //fonction qui fait l'upload du fichier json
    func upload(_ stringToSend: String, urlForAdding: String)
    {
        let url:URL = URL(string: urlForAdding)!
        
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let data = stringToSend.data(using: String.Encoding.utf8)
        
        let task = session.uploadTask(with: request as URLRequest, from: data, completionHandler:
        {(data,response,error) in
            guard let _:Data = data, let _:URLResponse = response, error == nil else
            {
                print("error")
                return
            }
                _ = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            }
        );
        
        task.resume()
    }
    //fonction qui retourne les valeurs du fichier json
    /* ------------------------------------- */
    func returnValues(_ dataIndex: Int) -> [String]
    {
        var arrayForData: [String] = []
        
        for (_, b) in self.jsonParsed
        {
            arrayForData.append((b as! NSArray)[dataIndex] as! String)
        }
        
        return arrayForData
    }
    //fonction qui retourne les clés du fichier json
    /* ------------------------------------- */
    func returnKeys() -> [String]
    {
        var arrayForData: [String] = []
        
        for (a, _) in self.jsonParsed
        {
            arrayForData.append(a as! String)
        }
        
        return arrayForData
    }
    /* ------------------------------------- */
    //fonction qui fait la conversion du fichier json par le csv
    func converJsonToCsv(_ fieldNamesSeperatedByComas: String) -> String
    {
        var CSV: String = "\(fieldNamesSeperatedByComas)\n"
        
        for (a, b) in self.jsonParsed
        {
            var newString = "\""
            newString +=  a as! String
            newString += "\""
            CSV += newString + ","
            
            for c in 0 ..< (b as! NSArray).count
            {
                var newString = "\""
                newString +=  ((b as! NSArray)[c] as! String)
                newString += "\""
                CSV += newString + ","
            }
            
            CSV = CSV.substring(to: CSV.characters.index(before: CSV.endIndex))
            CSV += "\n"
        }
        
        return CSV.substring(to: CSV.characters.index(before: CSV.endIndex))
    }
    /* ------------------------------------- */
    //fonction qui fait le filtre des valeurs du fichier json pour montrer dans l'application
    func filter(_ index: Int, title: String) -> String
    {
        var strToDisplay = "\(title) :\n"
        
        for (_, b) in self.jsonParsed
        {
            if (b as AnyObject)[index] as! String != ""
            {
                strToDisplay += "\t. \((b as AnyObject)[index] as! String)\n"
            }
        }
        
        return strToDisplay
    }
    /* ------------------------------------- */
}
/*==================================*/















