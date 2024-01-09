app "hello"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br" }
    imports [pf.Arg, pf.Stdout, pf.Task.{ Task }, pf.Http]
    provides [main] to pf

main =
    args <- Arg.list |> Task.await
    
    ip = List.get args 1
        |> Result.withDefault ""

    # Stdout.line "IP: \(ip)"

    url = "http://\(ip)/win&T=2"
    request = {
        method: Get,
        headers: [],
        url,
        body: Http.emptyBody,
        timeout: NoTimeout,
    }

    result <- Http.send request
        |> Task.onErr \err -> err 
            |> Http.errorToString 
            |> Task.ok
        |> Task.await

    Stdout.line result
