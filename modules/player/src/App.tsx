import 'xgplayer/dist/index.min.css'

import {HotaruPlayer} from "./player.ts";
import {onMount} from "solid-js";


function App() {

    onMount(() => {
        const hp = new HotaruPlayer()

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
