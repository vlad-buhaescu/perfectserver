import PerfectLib
import PerfectHTTP
import PerfectHTTPServer


let server = HTTPServer()
server.serverPort = 8080
server.documentRoot = "webroot"

var routes = Routes()
routes.add(method: .get, uri: "/") { (request, response) in
    response.setBody(string: "Hello smart boy!")
    .completed()
}



func returnJsonMessage(message: String, response: HTTPResponse)  {
    do {
        try response.setBody(json: ["message": message])
            .setHeader(.contentType, value: "application/json")
            .completed()
    } catch {
        response.setBody(string: "Err handl  \(error)")
        .completed(status: HTTPResponseStatus.internalServerError)
    }
}

routes.add(method: .get, uri: "/hello") { (req, resp) in
    returnJsonMessage(message: "Hello with routes", response: resp)
}

server.addRoutes(routes)

do {
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

//// An example request handler.
//// This 'handler' function can be referenced directly in the configuration below.
//func handler(request: HTTPRequest, response: HTTPResponse) {
//    // Respond with a simple message.
//    response.setHeader(.contentType, value: "text/html")
//    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
//    // Ensure that response.completed() is called when your processing is done.
//    response.completed()
//}
//
//// Configuration data for an example server.
//// This example configuration shows how to launch a server
//// using a configuration dictionary.
//
//
//let confData = [
//    "servers": [
//        // Configuration data for one server which:
//        //    * Serves the hello world message at <host>:<port>/
//        //    * Serves static files out of the "./webroot"
//        //        directory (which must be located in the current working directory).
//        //    * Performs content compression on outgoing data when appropriate.
//        [
//            "name":"localhost",
//            "port":8181,
//            "routes":[
//                ["method":"get", "uri":"/", "handler":handler],
//                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
//                 "documentRoot":"./webroot",
//                 "allowResponseFilters":true]
//            ],
//            "filters":[
//                [
//                "type":"response",
//                "priority":"high",
//                "name":PerfectHTTPServer.HTTPFilter.contentCompression,
//                ]
//            ]
//        ]
//    ]
//]
//
//do {
//    // Launch the servers based on the configuration data.
//    try HTTPServer.launch(configurationData: confData)
//} catch {
//    fatalError("\(error)") // fatal error launching one of the servers
//}
//
