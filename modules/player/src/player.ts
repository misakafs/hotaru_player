import Player, {Events} from "xgplayer";
import MobilePlugin from "xgplayer/es/plugins/mobile";


export class HotaruPlayer {
    private player: Player;


    init(data: Record<string, any>) {
        try {
            console.log('正在初始化')
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

            Server.postMessage(JSON.stringify({event: 'init', data: {'status': 'ok'}}))

        } catch (e) {
            console.error('初始化异常:', e)
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

        console.log('监听消息:', msg)

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
