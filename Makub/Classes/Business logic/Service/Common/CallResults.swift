//
//  CallResults.swift
//  Makub
//
//  Created by Елена Яновская on 15.03.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

enum ServiceCallResult<Payload> {
    case serviceSuccess(payload: Payload)
    case serviceFailure(error: NSError)
}

enum TransportCallResult {
    case transportSuccess(payload: TransportResponseResult)
    case transportFailure(error: NSError)
}

enum ParserCallResult<Model> {
    case parserSuccess(model: Model)
    case parserFailure(error: NSError)
}
