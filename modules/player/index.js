import './index.scss'
import Artplayer from 'artplayer'
import Hls from 'hls.js'


let art = null


window.init = (option) => {
    art = new Artplayer(
        {
            container: '#app',
            url: option.url,
            poster: option?.poster ?? '',
            volume: 1,
            muted: false,
            autoplay: option?.autoPlay ?? false,
            loop: option?.loop ?? false,
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
                poster: 'noposter',
                preload: 'auto',
            },
            customType: {
                m3u8: function playM3u8(video, url, art) {
                    if (Hls.isSupported()) {
                        if (art.hls) art.hls.destroy()
                        const hls = new Hls({
                            maxBufferLength: 60,
                            maxMaxBufferLength: 120,
                            maxBufferSize: 120 * 1024 * 1024,
                            enableWorker: true,
                        })
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
            if (option?.seek) {
                p.seek = option.seek
            }
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

// - [url]: 播放地址, string
// - [poster]: 播放封面, string
// - [seek]: 播放开始位置, number
// - [loop]: 循环播放, boolean
// - [playbackRate]: 播放倍速，number
// - [aspectRatio]: 视频纵横比，string，eg: '16:9'
// - [flip]: 播放器翻转，'normal' | 'horizontal' | 'vertical'
window.change = (obj) => {

    const newObj = Object.assign({}, obj)

    if (newObj.hasOwnProperty('url')) {
        art.switchUrl(newObj.url).then(r => {})
    }
    if (newObj.hasOwnProperty('poster')) {
        art.poster = newObj.poster
    }
    if (newObj.hasOwnProperty('loop')) {
        art.loop = newObj.loop
    }
    if (newObj.hasOwnProperty('seek')) {
        art.seek = newObj.seek
    }
    if (newObj.hasOwnProperty('playbackRate')) {
        art.playbackRate = newObj.playbackRate
    }
    if (newObj.hasOwnProperty('aspectRatio')) {
        art.aspectRatio = newObj.aspectRatio
    }
    if (newObj.hasOwnProperty('flip')) {
        art.aspectRatio = newObj.flip
    }
}

// t - 秒，eg: 2.232
window.seek = (t = 0) => {
    art.seek = t
}