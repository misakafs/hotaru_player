import Artplayer from 'artplayer';
import Hls from 'hls.js';


export class HotaruPlayer {
    private player: Artplayer;


    init(data: Record<string, any>) {
        try {
            this.player = new Artplayer({
                container: '#vs',
                url: data.url ?? '',
                setting: true,
                miniProgressBar: true,
                lock: true,
                fastForward: true,
                autoOrientation: true,
                fullscreen: true,
                pip: true,
                hotkey: true,
                lang: 'zh-cn',
                plugins: [],
                // customType: {
                //     m3u8: function playM3u8(video, url, art) {
                //         if (Hls.isSupported()) {
                //             if (art.hls) art.hls.destroy();
                //             const hls = new Hls();
                //             hls.loadSource(url);
                //             hls.attachMedia(video);
                //             art.hls = hls;
                //             art.on('destroy', () => hls.destroy());
                //         } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
                //             video.src = url;
                //         } else {
                //             art.notice.show = 'Unsupported playback format: m3u8';
                //         }
                //     }
                // },
            })

            // Server?.postMessage(JSON.stringify({event: 'init', data: {'status': 'ok'}}))

        } catch (e) {
            console.error('初始化异常:', e)
        }
    }

    play(data: Record<string, any>) {
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
