//
//  Parser.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

final class Parser <Response> where Response: Decodable {

    func parse(from data: Data) -> ParserCallResult<Response> {
        do {
            let model = try JSONDecoder().decode(Response.self, from: data)
            return ParserCallResult.parserSuccess(model: model)
        } catch {
            return ParserCallResult.parserFailure(error: error as NSError)
        } 
    }
}
