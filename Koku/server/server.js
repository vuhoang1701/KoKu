// ------------------------------------------------------
// Import all required packages and files
// ------------------------------------------------------

const jsonServer = require('json-server')
const server = jsonServer.create()
const router = jsonServer.router('db.json')
const middlewares = jsonServer.defaults()
var http = require('http').Server(server);
var io = require('socket.io')(http);
var clients =[];
// ------------------------------------------------------
// Set up Express
// ------------------------------------------------------
server.use(middlewares)
// Add custom routes before JSON Server router
server.get('/echo', (req, res) => {
  res.jsonp(req.query)
})

// To handle POST, PUT and PATCH you need to use a body-parser
// You can use the one used by JSON Server
server.use(jsonServer.bodyParser)
server.use((req, res, next) => {
  if (req.method === 'POST' || req.method === 'PUT') {	
    if(req.url.indexOf('/transactions/') > -1)
    {
      console.log('Post transactions')
      if(req.body.status == 'Completed')
      {
          console.log('Inside')
          var date = new Date();
         req.body.receivedTime = date.toISOString();
   
      }
      for( var i=0, len=clients.length; i<len; ++i ){
                console.log('sent socket');
                var c = clients[i];

                if(c.customId == req.body.senderId){
                     c.socket.emit('updateListTransaction', c.clientId);
                     console.log('sent socket');
                     console.log(c.clientId)
                    break;
                }
            }
    }
  }
  // Continue to JSON Server router
  next()
})

// Use default router
server.use(router)
server.listen(3000, () => {
  console.log('JSON Server is running')
})

http.listen(4000, function(){
  console.log('Listening on *:4000');
});

io.on('connection', function(clientSocket){
    console.log('a new user connected');

    clientSocket.on('storeClientInfo', function (data) {

            var clientInfo = new Object();
            clientInfo.customId     = data.customId;
            clientInfo.clientId     = clientSocket.id;
            clientInfo.socket       = clientSocket
            clients.push(clientInfo);
            console.log('stored client')
        });

    clientSocket.on('disconnect', function (data) {

            for( var i=0, len=clients.length; i<len; ++i ){
                var c = clients[i];

                if(c.clientId == clientSocket.id){
                    clients.splice(i,1);
                    console.log('Socket disconnect')
                    break;
                }
            }

        });
                    

    clientSocket.on("updateTransaction", function(dataTransaction) {
        var obj = JSON.parse(dataTransaction)
        for( var i=0, len=clients.length; i<len; ++i ){
                var c = clients[i];

                if(c.customId == obj.senderId){
                     obj.socket.emit('updateListTransaction', obj);
                    break;
                }
            }

    });

});

function isEmpty(obj) {
    for(var prop in obj) {
        if(obj.hasOwnProperty(prop))
            return false;
    }
    return JSON.stringify(obj) === JSON.stringify({});
}