//
//  CharactersVM.swift
//  RickAndMorti
//
//  Created by Hasan Hasanov on 27.10.22.
//

import Foundation
class CharactersVM{
    var successOnGetCharacters: ((Bool, CharactersResponse?) -> Void)?
    var pageNum = 1
    var endPoint = ""
    func calculateCellSize(textSize: CGSize, hasIcon: Bool) -> CGSize{
        
        var width = 0.0
        if hasIcon{
            width = textSize.width + 45
        }else{
            width = textSize.width + 25
        }
        
        return CGSize(width: width, height: textSize.height + 20)
    }
    func getCharacters(filterData: [FilterData] = FilterData.filterOptions, text: String? = nil){
        pageNum = 1
        var endpoint = "&"
        filterData.forEach { item in
            if item.type == .texfield && item.selectedTextField{
                if let text{
                    if text != ""{
                        endpoint += "\(item.title.lowercased())=\(text)&"
                    }
                }
            }else{
                if let options = item.options{
                    if item.selectedOptionIndex != 0{
                        endpoint += "\(item.title.lowercased())=\(options[item.selectedOptionIndex])&"
                    }
                }
            }
            
        }
        endpoint.removeLast()
        
        self.endPoint = endpoint
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(pageNum)\(endpoint)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: urlString){
            var urlReq = URLRequest(url: url)
            urlReq.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: urlReq) { data, res, err in
                
                if let err{
                    
                    print(err)
                }else{
                    if let data{
                        do{
                            let decodedData = try JSONDecoder().decode(CharactersResponse.self, from: data)
                            self.successOnGetCharacters?(false, decodedData)
                        }catch{
                            
                            print(error)
                        }
                        
                    }
                }
                    
            }
            session.resume()
        }
        
    }
    func getNextPage(){
        pageNum += 1
        let urlString = "https://rickandmortyapi.com/api/character/?page=\(pageNum)\(endPoint)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let url = URL(string: urlString){
            var urlReq = URLRequest(url: url)
            urlReq.httpMethod = "GET"
            let session = URLSession.shared.dataTask(with: urlReq) { data, res, err in
                
                if let err{
                    
                    print(err)
                }else{
                    if let data{
                        do{
                            let decodedData = try JSONDecoder().decode(CharactersResponse.self, from: data)
                            self.successOnGetCharacters?(true, decodedData)
                        }catch{
                            
                            print(error)
                        }
                        
                    }
                }
                    
            }
            session.resume()
        }
        
    }
}
