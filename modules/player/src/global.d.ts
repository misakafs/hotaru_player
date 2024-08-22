interface Window {
    Client: {
        postMessage: (msg: string) => void
    }
}

interface Server {
    postMessage: (msg: string) => void
}

declare var Server: Server;

