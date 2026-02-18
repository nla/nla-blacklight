import jquery from 'jquery'
window.jQuery = jquery
window.$ = jquery

if (typeof jquery.isFunction !== 'function') {
    jquery.isFunction = function(obj) {
        return typeof obj === 'function'
    }
}