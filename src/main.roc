app "wled"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.7.1/Icc3xJoIixF3hCcfXrDwLCu4wQHtNdPyoJkEbkgIElA.tar.br" }
    imports [pf.Arg, pf.Stdout, pf.Task.{ Task, await }, pf.Http]
    provides [main] to pf

appName = "wled"
appVersion = "0.1.0"

main =
    args <- await Arg.list

    parseCommand args
        |> executeCommand

parseCommand = \args ->
    command = List.get args 1
        |> Result.withDefault ""
    when command is
        "version" -> Version
        "help" -> Help
        "toggle" -> Toggle (parseIp args)
        _ -> None

parseIp = \args ->
    List.get args 2
        |> Result.withDefault ""

executeCommand = \command ->
    when command is
        Toggle ip -> actToggle ip
        Version -> printVersion
        Help -> printHelp
        _ -> printHelp

printVersion =
    Stdout.line "\(appVersion)"

printHelp =
    str =
        """
        \(appName) v\(appVersion)

        Usage:
        \(appName) <command> [<arguments>]

        Commands:
          toggle <ip>    Toggle WLED instance power
          version        Print current version number and exit
          help           Print usage info and exit
        """
    Stdout.line str

actToggle = \ip ->
    _ <- await (Stdout.line "IP: \(ip)")

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
        |> await

    Stdout.line result
