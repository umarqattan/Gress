//
//  ErrorConstants.swift
//  Gress
//
//  Created by Umar Qattan on 9/23/15.
//  Copyright (c) 2015 Umar Qattan. All rights reserved.
//

import Foundation

struct Request {
    
    struct Error {
        static let Message = "Could not complete request due to the following error:"
    }
    
    struct Success {
        static let Message = "Successfully completed request!"
    }
    
}


struct Format {
    
    struct JSON {
        
        struct Error {
            static let Message = "Could not format JSON response."
        }
        
        struct Parse {
            struct Error {
                static let Message = "Could not parse results."
            }
        }
        
    }
    
}

