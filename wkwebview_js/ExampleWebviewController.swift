//
//  ExampleWebviewController.swift
//  wkwebview_js
//
//  Created by Karthik on 28/4/19.
//  Copyright © 2019 Karthik. All rights reserved.
//

import Foundation

class ExampleWebviewController : NativeWebBridgeController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runPluginJS(names: ["Currencies", "Console"])
        
        self.wk.loadFileURL(Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www")!, allowingReadAccessTo: Bundle.main.resourceURL!.appendingPathComponent("www", isDirectory: true))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
