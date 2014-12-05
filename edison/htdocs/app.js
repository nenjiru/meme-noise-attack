(function () {
    'use strict';
    /*
    --------------------------------------------------------------------------------
        Param
    --------------------------------------------------------------------------------
    */
    var _h = ~~(Math.random() * 360),
        _s = 50,
        _l = 50,
        _hsl,
        _rgb = { r:0, g:0, b:0 };

    /**
     * DOM
     */
    var $body = document.body,
        $console = document.getElementById('console');

    var hasTouchEvent = ('ontouchstart' in window);

    /**
     * Point event
     * @type {{START: string, MOVE: string, END: string}}
     * @private
     */
    var PointEvent = {
        START: (hasTouchEvent) ? 'touchstart' : 'mousedown',
        MOVE : (hasTouchEvent) ? 'touchmove'  : 'mousemove',
        END  : (hasTouchEvent) ? 'touchend'   : 'mouseup'
    };

    /*
    --------------------------------------------------------------------------------
        Bounce scroll cancel
    --------------------------------------------------------------------------------
    */
    function preventScroll(event)
    {
      event.preventDefault();
    }

    document.addEventListener('touchstart', preventScroll, false);
    document.addEventListener('touchmove',  preventScroll, false);
    document.addEventListener('touchend',   preventScroll, false);

    /*
    --------------------------------------------------------------------------------
        Socket
    --------------------------------------------------------------------------------
    */
    setInterval(function ()
    {
        // sendign node server
        socket.emit('sendColor', { rgb: _rgb });
    }, 1000/30);

    /*
    --------------------------------------------------------------------------------
        Method
    --------------------------------------------------------------------------------
    */

    /**
     * Draw
     */
    function draw()
    {
        _hsl = new d3.hsl(_h, _s / 100.0, _l / 100.0);
        _rgb = new d3.rgb(_hsl);

        $body.style.backgroundColor = 'hsl('+ _h +', '+ _s +'%, '+ _l +'%)';
        $body.style.color = 'rgb('+ (Math.min(_rgb.r + 96, 200)) +', '+ (Math.min(_rgb.g + 96, 200)) +', '+ (Math.min(_rgb.b + 96, 200)) +')';

        $console.innerHTML = consoleParser(_hsl, _h, _s, _l, _rgb);
    };

    /**
     * Console
     */
    function consoleParser(hsl, h, s, l, rgb)
    {
        var html = '<div class="color">'+ hsl.toString() +'</div>'
         + '<div class="color">rgb('+ rgb.r + ', ' + rgb.g + ', ' + rgb.b +')</div>'
         + '<div class="color">hsl('+ h + ', ' + s + '%, ' + l +'%)</div>'
         ;
         return html;
    };

    /**
     * Mouse move
     */
    function onMoveHandler(event)
    {
        var maxX = window.innerWidth,
            maxY = window.innerHeight,
            touch = (hasTouchEvent) ? event.targetTouches[0] : event,
            x = touch.pageX,
            y = touch.pageY;
        _h = ~~(x / maxX * 360);
        _l = ~~(y / maxY * 10000) / 100;
        draw();
    };


    window.addEventListener(PointEvent.MOVE, onMoveHandler);

    draw();

})();
