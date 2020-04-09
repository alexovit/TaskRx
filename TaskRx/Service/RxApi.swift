//
//  RxApi.swift
//  TaskRx
//
//  Created by Alexey on 09.04.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class RxApi {
    
    class func requestGet(url: URL, headers: [String: String]? = nil) -> Observable<[String: Any]> {
        let response = Observable.from([url])
            .map { url -> URLRequest in
                var request = URLRequest(url: url)
                if let headers = headers {
                    for (key, value) in headers {
                        request.addValue(value, forHTTPHeaderField: key)
                    }
                }
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data:  Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .share(replay: 1)
            .filter { response, _ in
                let ok = response.statusCode == 200
                if(!ok) {
                    NSLog("%d", response.statusCode)
                }
                return ok
            }
            .map { _, data -> [String: Any] in
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                    let result = jsonObject as? [String: Any] else {
                        return [:]
                }
                return result
            }
            return response
    }
    
}
