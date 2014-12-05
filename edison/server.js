/*!
 * Meme Noise Attack.
 * CandyServer for Edison
 * https://github.com/nenjiru/meme-noise-attack
 *
 * Require fcserver-galileo
 * via https://github.com/scanlime/fadecandy/tree/master/bin
 */

/*
--------------------------------------------------------------------------------
    Module
--------------------------------------------------------------------------------
*/
var restify = require('restify'),
    socket  = require('socket.io'),
    OPC     = require('opc'),
    request = require('request');

/*
--------------------------------------------------------------------------------
    Setting
--------------------------------------------------------------------------------
*/
var PORT = 8888
var FPS = 10;
var PIXEL_NUMBER = 64; // 1slot 64 * 8slot = MAX 512
var TWEET_COLOR = 'http://27.120.89.129:8080/api/tweets/color';
var TWEET_COLOR_DELAY = 2000;

var COLOR = {
    'red'   : [255, 0,   0],
    'green' : [0,   204, 0],
    'purple': [204, 0,   204],
    'blue'  : [0,   51,  204],
    'yellow': [255, 255, 0]
};

// Params
var server,
    candy,
    color,
    io,
    rgb = { r:0, g:250, b:0 };

/*
--------------------------------------------------------------------------------
    Server
--------------------------------------------------------------------------------
*/
server = restify.createServer();

server.get(/\/.*/, restify.serveStatic(
{
    directory: __dirname + '/htdocs/',
    default: 'index.html'
}));

server.listen(PORT, function ()
{
    console.log('Server running at '+ PORT);
});

/*
--------------------------------------------------------------------------------
    Fadecandy client
--------------------------------------------------------------------------------
*/
candy = new OPC('localhost', 7890);

/*
--------------------------------------------------------------------------------
    Socket settiong
--------------------------------------------------------------------------------
*/
io = socket(server.server);

io.sockets.on('connection', function (socket)
{
    socket.on('sendColor', function (data)
    {
        rgb = data.rgb;
    });
});

/*
--------------------------------------------------------------------------------
    Private method
--------------------------------------------------------------------------------
*/
/**
 * Update NeoPixel
 */
function update()
{
    for (var i = 0; i < PIXEL_NUMBER; i++)
    {
        candy.setPixel(i, rgb.r, rgb.g, rgb.b);
    }
    candy.writePixels();
}

/**
 * Get color API
 */
function getColor()
{
    request.get(TWEET_COLOR, function(hd, res)
    {
        color = JSON.parse(res.body).response.color;
        rgb.r = COLOR[color][0];
        rgb.g = COLOR[color][1];
        rgb.b = COLOR[color][2];
    });
}

/*
--------------------------------------------------------------------------------
    Command
--------------------------------------------------------------------------------
*/

// Main loop
setInterval(update, 1000/FPS);
setInterval(getColor, TWEET_COLOR_DELAY);

