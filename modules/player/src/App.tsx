// import 'xgplayer/dist/index.min.css'

import {HotaruPlayer} from "./artplayer.ts";
import {onMount} from "solid-js";


function App() {



    onMount(() => {
        const hp = new HotaruPlayer()

        // test: https://gcore.jsdelivr.net/gh/misakafs/hotaru_server@master/assets/test.mp4
        const url = import.meta.env.DEV ? 'https://gcore.jsdelivr.net/gh/misakafs/hotaru_server@master/assets/test.mp4' : new URLSearchParams(window.location.search).get('url')

        if (url) {
            hp.init({
                url: url
            })
        }

        window.Client = window.Client || {
            postMessage: (msg: string) => {
                hp.listen(msg)
            }
        }
    })

    return (
        <>
            <div id="vs"></div>
        </>
    )
}

export default App
