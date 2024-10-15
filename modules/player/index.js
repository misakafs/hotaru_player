import './index.scss'
import Artplayer from 'artplayer'
import Hls from 'hls.js'


let art = null


window.init = (option) => {
    art = new Artplayer(
        {
            container: '#app',
            url: option.url,
            poster: option.poster ?? '',
            volume: 1,
            muted: false,
            autoplay: option.autoPlay ?? false,
            loop: option.loop ?? false,
            setting: false,
            miniProgressBar: false,
            lock: false,
            fastForward: false,
            autoOrientation: true,
            fullscreen: false,
            fullscreenWeb: false,
            playbackRate: false,
            aspectRatio: true,
            playsInline: false,
            lang: 'zh-cn',
            moreVideoAttr: {
                poster: 'noposter'
            },
            customType: {
                m3u8: function playM3u8(video, url, art) {
                    if (Hls.isSupported()) {
                        if (art.hls) art.hls.destroy()
                        const hls = new Hls()
                        hls.loadSource(url)
                        hls.attachMedia(video)
                        art.hls = hls
                        art.on('destroy', () => hls.destroy())
                    } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
                        video.src = url
                    } else {
                        art.notice.show = 'Unsupported playback format: m3u8'
                    }
                }
            }
        },
        function onReady(p) {
            p.play()
            window.flutter_inappwebview.callHandler('Ready')
        }
    )

    // 视频的总时长已改变，秒
    art.on('video:durationchange', (event) => {
        window.flutter_inappwebview.callHandler('Duration', event.target.duration)
    })

    // 已播放时长，秒
    art.on('video:timeupdate', (event) => {
        window.flutter_inappwebview.callHandler('Position', event.target.currentTime)
    })

    // 已缓存时长，秒
    art.on('video:progress', (event) => {
        if (event.target.buffered.length) {
            window.flutter_inappwebview.callHandler('Buffered', event.target.buffered.end(event.target.buffered.length - 1))
        }
    })

    // 视频播放结束
    art.on('video:ended', (event) => {
        window.flutter_inappwebview.callHandler('Ended')
    })

    // 视频错误
    art.on('video:error', (error) => {
        window.flutter_inappwebview.callHandler('Error', error.message)
    })

}


// 播放
window.play = () => {
    art?.play()
}


// 暂停
window.pause = () => {
    art?.pause()
}

// - [url]: 播放地址
// - [poster]: 播放封面
// - [t]: 播放开始位置
// - [loop]: 循环播放
window.change = (obj) => {

    const newObj = Object.assign({
    }, obj)

    if (newObj.hasOwnProperty('url') && newObj.url?.length) {
        art.switchUrl(newObj.url).then(r => {})
    }
    if (newObj.hasOwnProperty('poster') && newObj.poster?.length) {
        art.poster = newObj.poster
    }
    if (newObj.hasOwnProperty('loop')) {
        art.loop = newObj.loop
    }
    if (newObj.hasOwnProperty('t')) {
        art.seek = newObj.t
    }

}

// t - 秒，eg: 2.232
window.seek = (t = 0) => {
    art.seek = t
}