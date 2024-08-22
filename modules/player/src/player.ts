import Player, {Events} from "xgplayer";
import MobilePlugin from "xgplayer/es/plugins/mobile";


export class HotaruPlayer {
    private player: Player;


    init(data: Record<string, any>) {
        try {
            this.player = new Player({
                id: 'vs',
                url: data.url ?? '',
                autoplay: data.autoplay ?? true,
                height: window.innerHeight,
                width: window.innerWidth,
                miniprogress: true,
                mini: false,
                // @ts-ignore
                playbackRate: false,
                plugins: [MobilePlugin],
            })

            this.player.on(Events.ENDED, () => {
                const msg = {
                    'event': 'ended'
                }
                Server.postMessage(JSON.stringify(msg))
            })

        } catch (e) {
            console.error(e)
        }
    }

    play(data: Record<string, any>) {
        if (this.player && data.url) {
            this.player.playNext({
                url: data.url,
                poster: data.poster ?? this.player.poster ?? '',
            });
        }
    }


    listen(msg: string) {
        if (!msg.trim().length) {
            return;
        }

        const eventMessage = (JSON.parse(msg) ?? {}) as Record<string, any>
        if(!eventMessage.event?.toString()?.length) {
            return;
        }

        switch (eventMessage.event.toString()) {
            case 'init':
                this.init((eventMessage.data ?? {}) as Record<string, any>);
                return
            case 'play':
                this.play((eventMessage.data ?? {}) as Record<string, any>)
                return
        }
    }


}
